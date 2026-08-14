# Day 89 — KubeHealer and AIOps

## Overview

Day 89 focused on **AIOps (AI-powered IT operations)** and production-grade AI agents that can diagnose Kubernetes failures and take corrective action with human approval.

The project used **KubeHealer**, a Temporal-based Kubernetes healing agent. The agent scans the cluster for unhealthy pods, collects Kubernetes diagnostic information, sends the information to an LLM for diagnosis, proposes a remediation, waits for human approval, and then applies a targeted fix.

For this implementation, the LLM backend was adapted to **Groq** rather than Anthropic/Claude, while Kubernetes operations were performed through the Kubernetes API.

The lab demonstrated three failure scenarios:

- `web-app` — incorrect container image
- `memory-app` — insufficient memory limit
- `config-app` — missing ConfigMap

The agent successfully remediated the image and memory problems and correctly skipped/escalated the missing ConfigMap case.

---

## 1. What is AIOps?

**AIOps** is the use of artificial intelligence in IT operations to assist with monitoring, diagnosis, decision-making, and remediation.

Traditional operations often depend on engineers manually:

1. Detecting an alert
2. Inspecting logs and events
3. Finding the root cause
4. Deciding what to change
5. Applying the change
6. Verifying the result

An AIOps agent can combine these steps into an intelligent workflow.

The important principle is that AIOps is **not simply replacing humans**. The agent handles repetitive investigation and well-understood remediation while humans retain control over risky or ambiguous operations.

In KubeHealer, the agent:

```text
Kubernetes Cluster
       |
       v
Scan unhealthy pods
       |
       v
Collect pod details
       |
       v
LLM diagnosis
       |
       v
Propose remediation
       |
       v
Human approval
       |
       v
Execute targeted fix
       |
       v
Verify / report result
```

---

## 2. Production Guardrails

Production AI agents require strong safety controls because an agent that can modify infrastructure can also make incorrect or destructive changes.

### 2.1 Human Approval

The agent should not automatically perform potentially destructive infrastructure changes without permission.

KubeHealer uses a Temporal workflow approval gate. The agent diagnoses the issue and proposes a fix before execution.

Example:

```text
Pod: web-app
Root cause: incorrect container image
Proposed action: fix_image
Fix: nginx:latest

Approve fix? [y/n]:
```

This keeps a human in control of remediation.

### 2.2 Scope Limits

An agent must only operate within explicitly allowed boundaries.

For example, a production implementation could restrict the agent to:

- Specific namespaces
- Specific Kubernetes clusters
- Specific resource types
- Specific remediation actions

The agent should not be allowed to modify sensitive namespaces or critical infrastructure without additional authorization.

### 2.3 Audit Trail

Every important operation should be traceable.

Temporal provides workflow history containing the execution of activities and workflow state. This gives operators a record of:

- Cluster scanning
- Pod diagnosis
- LLM decisions
- Approval signals
- Remediation activities
- Workflow completion

This is important for debugging, compliance, and incident review.

### 2.4 Rollback Capability

Remediation should be reversible wherever possible.

KubeHealer uses targeted Kubernetes changes rather than blindly replacing the entire cluster state. Deployment changes can also be tracked through Kubernetes rollout history.

The principle is:

```text
Detect -> Diagnose -> Minimal Change -> Verify
```

rather than making broad, uncontrolled changes.

### 2.5 Timeout and Retry Limits

AI agents must not run indefinitely or repeatedly apply the same incorrect fix.

KubeHealer uses Temporal activity timeouts and retry policies. For example, the LLM diagnosis activity has a bounded timeout and a maximum retry count.

This prevents an LLM or external service failure from creating an uncontrolled loop.

### 2.6 Escalation Path

A production agent must know when it cannot safely solve a problem.

The `config-app` failure demonstrates this.

The pod referenced a ConfigMap named `app-config` that did not exist. Rather than inventing configuration values, the agent classified the issue as requiring manual intervention.

This is an important AIOps principle:

> A good agent knows when not to act.

---

## 3. Why Temporal is Important

Infrastructure agents need **durable execution**.

Without durable execution, consider this sequence:

```text
Scan cluster
   |
Diagnose web-app
   |
Diagnose memory-app
   |
Worker crashes
   |
All workflow state is lost
```

The operator may have to start the entire process again.

With Temporal:

```text
Workflow
   |
   +-- scan_cluster
   |
   +-- get_pod_details
   |
   +-- diagnose_pod
   |
   +-- approval signal
   |
   +-- execute_fix
   |
   +-- result
```

Temporal records workflow execution history.

If the worker is killed during execution:

```text
Temporal Server
      |
      | stores workflow history
      v
Worker crashes
      |
      v
Worker restarted
      |
      v
Temporal replays completed workflow history
      |
      v
Workflow continues from the required point
```

This makes the workflow resilient to worker failures.

Temporal therefore provides an important production capability for infrastructure agents: **the workflow state survives the failure of the worker process**.

---

## 4. KubeHealer Architecture

The core architecture is:

```text
                  +----------------------+
                  |   Kubernetes Cluster |
                  |                      |
                  | web-app              |
                  | memory-app           |
                  | config-app           |
                  +----------+-----------+
                             |
                             | Kubernetes API
                             v
                  +----------------------+
                  |    KubeHealer Worker  |
                  |                      |
                  | scan_cluster          |
                  | get_pod_details       |
                  | execute_fix           |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |   Temporal Server     |
                  |                      |
                  | Durable Workflows     |
                  | Activity History      |
                  | Approval Signals      |
                  +----------+-----------+
                             |
                             v
                  +----------------------+
                  |       Groq LLM        |
                  |                      |
                  | Root Cause Analysis   |
                  | Fix Recommendation    |
                  +----------------------+
                             |
                             v
                  +----------------------+
                  | Human Approval        |
                  +----------------------+
                             |
                             v
                  +----------------------+
                  | Targeted Kubernetes   |
                  | Remediation           |
                  +----------------------+
```

### Components

**Kubernetes**

Provides the workloads and exposes their state through the Kubernetes API.

**KubeHealer Worker**

Runs the Temporal worker and executes Kubernetes and LLM activities.

**Temporal**

Provides durable workflow execution, retries, workflow history, and approval signals.

**LLM**

The implementation used a Groq-backed LLM for Kubernetes diagnosis and remediation recommendations.

**Human**

Reviews proposed actions before they are executed.

---

## 5. The Three Broken Applications

### 5.1 `web-app` — Image Typo

The application was intentionally deployed using:

```text
ngnix:latest
```

instead of:

```text
nginx:latest
```

This caused Kubernetes to report:

```text
ErrImagePull
ImagePullBackOff
```

The agent diagnosed the problem as an invalid/incorrect container image and proposed:

```text
fix_image
nginx:latest
```

After approval, KubeHealer applied the targeted image correction.

### Result

```text
web-app -> fixed
Action  -> fix_image
```

---

### 5.2 `memory-app` — Insufficient Memory

The application was configured with:

```yaml
resources:
  limits:
    memory: "1Mi"
```

The extremely small memory limit caused the container to fail with memory-related errors such as `OOMKilled` / `CrashLoopBackOff` / `RunContainerError` during the intentionally broken deployment tests.

The agent diagnosed insufficient memory and proposed increasing the memory limit.

The approved remediation was:

```text
128Mi
```

KubeHealer patched the workload with the new memory limit.

### Result

```text
memory-app -> fixed
Action      -> patch_resources
Memory      -> 128Mi
```

---

### 5.3 `config-app` — Missing ConfigMap

The application referenced:

```yaml
envFrom:
  - configMapRef:
      name: app-config
```

but the `app-config` ConfigMap did not exist.

Kubernetes reported:

```text
CreateContainerConfigError
```

The agent correctly identified the missing ConfigMap.

However, it did **not** invent a ConfigMap or arbitrary configuration values.

It classified the problem as:

```text
skip
```

and escalated it for human intervention.

### Result

```text
config-app -> not automatically fixed
Action     -> skip / escalate
Reason     -> missing ConfigMap requires human decision
```

This demonstrates an important safety property of an infrastructure agent: **diagnosis does not always have to result in automatic action**.

---

## 6. Human Approval Flow

The production-oriented workflow is:

```text
1. Scan
      |
2. Diagnose
      |
3. Generate proposed fixes
      |
4. Human reviews proposals
      |
      +---- Reject ----> Skip
      |
      +---- Approve ---> Execute fix
                           |
                           v
                        Result
```

The Temporal workflow exposes approval signals:

```text
approve_pod
reject_pod
```

The workflow pauses at the approval stage until decisions are received.

This is safer than allowing an LLM to directly modify Kubernetes resources.

---

## 7. Crash Recovery

Temporal's durable execution was tested by stopping the KubeHealer worker while the workflow was running.

### Step 1 — Start the workflow

The healing workflow is started normally:

```bash
python starter.py
```

The workflow begins scanning and diagnosing the unhealthy pods.

### Step 2 — Kill the worker

The worker process is stopped while the workflow is still executing.

For example:

```bash
Ctrl+C
```

The worker is no longer processing Temporal tasks.

### Step 3 — Temporal retains workflow history

The Temporal server continues to hold the workflow execution and its event history.

The worker failure does not erase the workflow.

### Step 4 — Restart the worker

The worker is started again:

```bash
python worker.py
```

The worker reconnects to Temporal and resumes processing the workflow.

### Step 5 — Workflow resumes

Temporal uses the recorded workflow history to replay completed workflow steps and continue execution.

Conceptually:

```text
Before crash:

scan
  |
diagnose
  |
diagnose
  |
X Worker crashes
  |
  |
Temporal retains history
  |
  v
Worker restarted
  |
  v
Workflow resumes
  |
approval
  |
execute fix
  |
completed
```

This is the major difference between a normal Python automation script and a durable Temporal workflow.

---

## 8. When to Use AI Agents vs Traditional Automation

AI agents should not replace simple deterministic automation.

### Use AI Agents When

The problem requires reasoning or diagnosis.

Examples:

- Unknown Kubernetes failures
- Root-cause analysis
- Multiple possible causes
- Interpreting logs and events
- Choosing between several possible remediation strategies
- Producing explanations for humans

For example:

```text
Pod is failing
   |
Several possible causes
   |
Read events + logs + configuration
   |
Reason about likely root cause
```

This is a good use case for an AI agent.

### Use Traditional Automation When

The solution is already known and deterministic.

Examples:

- Restarting a known unhealthy pod
- Scaling a deployment
- Running a scheduled backup
- Applying a known configuration
- Triggering a standard CI/CD deployment
- Executing a predefined rollback

For example:

```text
IF CPU > 80%
THEN scale replicas from 3 to 5
```

There is no need for an LLM to make that decision.

### Key Principle

```text
Known problem + known solution
        -> Traditional automation

Unknown problem + requires reasoning
        -> AI agent
```

The best production systems can combine both approaches.

---

## 9. Agentic AI Journey — Days 87 to 89

The three-day progression shows how the system evolved from passive AI to controlled autonomous action.

| Day | Module | What Was Built | Pattern |
|---|---|---|---|
| 87 | Modules 0–2 | Docker Error Explainer + Docker Agent | LLM -> ReAct Agent |
| 88 | Modules 3, 6 | Multi-tool Agent + MCP Server + CI/CD Analyzer | Multi-domain tools + MCP |
| 89 | Modules 4–5 | KubeHealer | Diagnosis + human-approved remediation + Temporal durability |

### Day 87 — Passive AI to Agent

The first stage focused on using an LLM to understand DevOps problems.

```text
Error
  |
  v
LLM
  |
  v
Explanation
```

The next step introduced tools and the ReAct pattern.

```text
Observe -> Think -> Act -> Observe
```

### Day 88 — Multi-tool Agent

The agent gained access to multiple DevOps domains.

It could work with:

- Docker
- Kubernetes
- CI/CD
- MCP tools

This demonstrated that tools can expose existing DevOps commands and APIs to an AI agent.

### Day 89 — Autonomous Remediation

KubeHealer adds the ability to act on Kubernetes infrastructure.

```text
Observe
   |
Diagnose
   |
Plan
   |
Human approval
   |
Act
   |
Verify
```

Temporal adds durable execution so the action workflow survives worker failures.

---

## 10. Connection to the 90 Days of DevOps Challenge

Agentic AI connects directly to the technologies learned throughout the challenge.

| Previous Days | Connection to Agentic AI |
|---|---|
| Days 29–37 — Docker | Docker commands can be exposed as agent tools |
| Days 40–49 — GitHub Actions | Agents can diagnose CI/CD pipeline failures |
| Days 50–67 — Kubernetes | KubeHealer uses Kubernetes APIs and Kubernetes troubleshooting |
| Days 73–77 — Observability | Prometheus and Loki data can become agent diagnostic tools |
| Days 84–86 — ArgoCD | An agent could trigger syncs, rollbacks, or investigate GitOps drift |
| Day 89 — AIOps | AI combines diagnosis, decision-making, and controlled remediation |

The challenge therefore moves from learning individual DevOps technologies to building systems that can reason across those technologies.

---

## 11. Key Production Principles

The Day 89 implementation reinforced the following principles:

### 1. Tools are CLI/API wrappers

Commands and APIs that engineers already use can be exposed as tools for an agent.

```text
kubectl
Docker
GitHub
Prometheus
Loki
ArgoCD
      |
      v
    Tools
      |
      v
   AI Agent
```

### 2. ReAct is broadly applicable

The ReAct pattern allows an agent to:

```text
Reason
  |
Act
  |
Observe
  |
Reason again
```

This works across Docker, Kubernetes, CI/CD, and other operational domains.

### 3. MCP standardizes tool access

MCP provides a standardized approach for exposing tools and resources to AI systems.

This makes it easier to build reusable tool integrations rather than implementing every integration specifically for one agent.

### 4. Guardrails are mandatory

Infrastructure agents need:

- Human approval
- Scope restrictions
- Audit trails
- Rollback strategies
- Timeout/retry limits
- Escalation paths

AI capability without safety controls is not production automation.

### 5. Durability matters

Infrastructure changes can take time and may involve multiple dependent operations.

Temporal ensures that workflow progress is durable even if the worker process fails.

### 6. AI is not always the answer

Simple deterministic tasks should remain traditional automation.

AI should be introduced where reasoning provides meaningful value.

---

## 12. Final Result

KubeHealer demonstrated a production-oriented AIOps pattern:

```text
                 Kubernetes
                     |
                     v
              Detect failures
                     |
                     v
               Gather data
                     |
                     v
                LLM reason
                     |
                     v
              Proposed fixes
                     |
                     v
             Human approval
                     |
                     v
             Targeted change
                     |
                     v
                Verification
                     |
                     v
              Temporal history
```
