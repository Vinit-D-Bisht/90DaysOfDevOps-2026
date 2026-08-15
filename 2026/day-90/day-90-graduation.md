# Day 90 — Graduation: The Complete DevOps Journey

## 90-Day Timeline

### Week 1 — Linux Fundamentals
- Linux command line
- Files and directories
- Processes and system management
- Permissions
- LVM fundamentals

**Key lesson:** Linux is the foundation underneath almost every DevOps platform and tool.

### Week 2 — Networking & Shell Scripting
- DNS, IP addresses, subnets and ports
- Bash fundamentals
- Variables, conditions, loops and functions
- Shell automation projects

**Key lesson:** Understanding how systems communicate makes troubleshooting much easier, while scripting removes repetitive manual work.

### Week 3 — Git & GitHub
- Git fundamentals
- Branching and advanced Git
- GitHub workflows
- GitHub CLI

**Key lesson:** Version control is the backbone that connects development, automation and deployment.

### Week 4 — Docker
- Images and containers
- Dockerfiles
- Volumes
- Container networking
- Docker Compose
- Multi-stage builds

**Key lesson:** Containerization gives applications a consistent runtime environment.

### Week 5 — CI/CD & GitHub Actions
- YAML workflows
- Triggers and runners
- Secrets
- Build and deployment automation
- DevSecOps practices

**Key lesson:** Automation turns a manual release process into a repeatable pipeline.

### Week 6 — Kubernetes
- Pods
- Deployments
- Services
- Namespaces
- RBAC
- Kubernetes troubleshooting

**Key lesson:** Running containers is different from operating applications at scale; Kubernetes provides the orchestration layer.

### Week 7 — Terraform
- Providers
- Resources
- State
- Modules
- Workspaces
- Infrastructure as Code

**Key lesson:** Infrastructure can be version-controlled, reviewed and reproduced just like application code.

### Week 8 — Ansible & Configuration Management
- Inventories
- Playbooks
- Roles
- Templates
- Vault

**Key lesson:** Provisioning infrastructure and configuring systems are related but different problems.

### Week 9 — Observability
- Prometheus
- Grafana
- Loki
- Promtail
- OpenTelemetry
- Alerting

**Key lesson:** Monitoring tells you that something is wrong; logs, metrics and traces help explain why.

### Week 10 — Helm & Amazon EKS
- Helm charts
- Templates and values
- Multi-environment deployments
- Terraform-powered EKS
- Gateway API
- EBS storage
- IRSA
- HPA

**Key lesson:** Kubernetes becomes much more manageable when applications are packaged consistently and the cluster is provisioned as code.

### Week 11 — ArgoCD & GitOps
- GitOps principles
- ArgoCD
- Sync strategies
- Sync waves
- App of Apps
- RBAC
- CI/CD integration

**Key lesson:** Git can become the source of truth for the desired state of infrastructure and applications.

### Week 12 — Agentic AI for DevOps
- LLM-powered DevOps agents
- ReAct-style agent workflows
- MCP
- Kubernetes troubleshooting agents
- Temporal
- KubeHealer

**Key lesson:** AI can move beyond answering questions and participate in diagnosing infrastructure problems and executing controlled remediation.

### Final Stretch — KubeHealer
I built KubeHealer as the final integration of the DevOps and AI concepts from the challenge.

The system combined:
- Temporal for durable workflow orchestration
- Kubernetes APIs for cluster inspection and remediation
- An LLM for diagnosis
- Human approval before fixes
- Validation guardrails before changing resources
- Recovery through Temporal workflow execution

The project used broken Kubernetes workloads to test diagnosis and recovery, including image-pull failures, memory/resource problems and configuration failures.

---

## Top 5 Aha Moments

### 1. DevOps Is a System, Not a Collection of Tools

At the beginning, Linux, Git, Docker, Kubernetes, Terraform and monitoring looked like separate technologies.

By Day 90, the connection became clear:

**Code → Git → CI/CD → Container → Kubernetes → Cloud → GitOps → Observability → Automated remediation**

The real skill is understanding how the pieces work together.

### 2. Infrastructure Can Be Treated Like Code

Terraform and GitOps changed how I think about infrastructure.

Instead of manually creating and modifying infrastructure, the desired state can be:
- written as code
- reviewed
- version-controlled
- reproduced
- automatically applied

That makes infrastructure more predictable and auditable.

### 3. Observability Changes Troubleshooting

Before learning observability, troubleshooting often meant checking whatever happened to be visible.

Prometheus, Grafana, Loki and OpenTelemetry introduced a much better approach:

**Measure → observe → correlate → identify the cause → fix → verify**

Metrics, logs and traces provide the evidence required to troubleshoot production systems.

### 4. Kubernetes Problems Are Often Chain Problems

A broken application is rarely just "a broken pod."

A failure can involve:

**Application → Container → Pod → Deployment → Service → Gateway → Node → Cloud infrastructure**

Understanding Kubernetes ownership, resources, events and networking made troubleshooting much more systematic.

### 5. AI Becomes More Useful When It Is Connected to Real Tools

The biggest shift in the final days was seeing AI operate as part of a workflow.

Instead of only asking an LLM:

> "Why is this Kubernetes pod broken?"

KubeHealer can provide the model with actual diagnostic information, let it determine a possible action, validate that action and execute it through a controlled workflow.

The important lesson was not simply "AI can fix Kubernetes."

It was:

**AI + tools + guardrails + workflow orchestration = useful agentic automation.**

---

## Hardest Day and How I Pushed Through It

### Hardest Block: Agentic AI / KubeHealer

The final AI block was the most challenging part of the journey.

There were multiple moving pieces at once:

- Ollama and local LLM connectivity
- LLM response formatting
- Kubernetes API interaction
- Temporal workers
- Temporal workflow execution
- Activity retries
- Kubernetes ownership resolution
- Validation of AI-generated fixes
- Human approval
- Recovery after worker failures

There were also several real failures during development.

The worker initially expected an Anthropic API key even though the project was being run with a local Ollama model. The LLM integration was then changed to use Ollama/Groq as the available setup evolved.

KubeHealer also encountered issues such as:
- `ErrImagePull`
- `ImagePullBackOff`
- `CrashLoopBackOff`
- `RunContainerError`
- `CreateContainerConfigError`
- incorrect AI-generated fix details
- deployment lookup problems
- standalone Kubernetes pods without normal Deployment ownership
- Temporal activity/workflow failures

Instead of treating those failures as a reason to stop, I used them as debugging cases.

The biggest improvement was learning to separate the system into layers:

**LLM diagnosis → validation → Kubernetes action → Temporal orchestration → verification**

That made the project much easier to reason about.

---

## Skills Inventory

| Skill | Days | Confidence (1–5) |
|---|---:|---:|
| Linux command line | 1–13 | 4 |
| Shell scripting | 16–21 | 4 |
| Git & GitHub | 22–28 | 4 |
| Docker | 29–37 | 4 |
| CI/CD / GitHub Actions | 38–49 | 4 |
| Kubernetes | 50–58 | 4 |
| Terraform | 59–67 | 4 |
| Ansible | 68–72 | 3 |
| Observability | 73–77 | 4 |
| Helm | 78–80 | 4 |
| Amazon EKS | 81–83 | 4 |
| ArgoCD / GitOps | 84–86 | 4 |
| Agentic AI for DevOps | 87–89 | 3 |

These are practical confidence ratings based on completing the challenge and troubleshooting the projects, not claims of mastery.

---

## What I Plan to Learn Next

The 90-day challenge gives me a strong foundation, but it is not the end of the learning path.

### Kubernetes
- Multi-cluster Kubernetes
- Fleet management
- Advanced networking
- Service mesh with Istio or Linkerd
- Advanced security and policy

### Infrastructure
- Advanced Terraform
- Terragrunt
- Drift detection
- Custom providers
- Better cloud architecture patterns

### Security
- HashiCorp Vault
- AWS Secrets Manager
- External Secrets Operator
- Kubernetes security
- Supply-chain security

### Reliability
- Chaos engineering
- Disaster recovery
- Backup and restore strategies
- High availability
- Production incident response

### Cloud & FinOps
- AWS architecture
- Cost optimization
- Resource rightsizing
- Cloud governance

### AI for DevOps
- More capable tool-using agents
- Agent evaluation
- MCP-based infrastructure tooling
- Safer autonomous remediation
- Multi-agent workflows
- AI-assisted incident response

### Certifications
Potential next certifications:
- AWS Certified Solutions Architect
- Certified Kubernetes Administrator (CKA)
- Certified Kubernetes Application Developer (CKAD)
- HashiCorp Terraform Associate

---

## The Portfolio Project I Want to Build

The next major goal is to take the concepts from the final weeks and build an independent project from scratch.

The target architecture is:

```text
Developer
   |
   v
GitHub
   |
   v
GitHub Actions
   |
   v
Docker Image
   |
   v
Container Registry
   |
   v
Helm Chart
   |
   v
ArgoCD
   |
   v
Amazon EKS
   |
   +---- Prometheus
   +---- Grafana
   +---- Loki
   |
   v
AI DevOps Agent
   |
   v
Diagnosis / Controlled Remediation
```

The goal is not simply to reproduce the 90-day challenge.

The goal is to build something that demonstrates that I understand the patterns behind the tools.

---

## Advice for Someone Starting Day 1 Tomorrow

### 1. Do not rush.

Ninety days sounds impressive only after you finish it.

The real value comes from showing up consistently.

### 2. Break things intentionally.

A lot of my learning came from errors:

- failed Docker builds
- broken Kubernetes manifests
- Terraform errors
- CI failures
- ArgoCD sync problems
- monitoring issues
- AI agent failures

A broken system gives you something concrete to investigate.

### 3. Do not memorize commands without understanding them.

Knowing a command is useful.

Understanding **why** you are running it is much more valuable.

### 4. Build while learning.

Do not wait until you "know enough" to build a project.

The project is where the concepts start connecting.

### 5. Keep your work public.

GitHub repositories, documentation and LinkedIn updates create a visible record of progress.

They also force you to explain what you actually learned.

### 6. Learn the patterns underneath the tools.

Tools will change.

The patterns remain:

- version control
- automation
- infrastructure as code
- containerization
- orchestration
- observability
- desired state
- continuous delivery
- reliability
- controlled automation

Once those patterns make sense, learning a new DevOps tool becomes much easier.

---

## Final Reflection

90 days ago, the journey started with basic Linux commands.

It ended with an AI-powered Kubernetes self-healing workflow.

Between those two points were:

**Linux → Networking → Shell → Git → Docker → CI/CD → Kubernetes → Terraform → Ansible → Observability → Helm → EKS → ArgoCD → Agentic AI**

The biggest achievement is not knowing a list of tools.

It is understanding how those tools connect to move software from development toward production with automation, visibility and reliability.

The challenge is complete.

The learning is not.

**Day 90 is the end of the challenge — and the beginning of the next level.**

