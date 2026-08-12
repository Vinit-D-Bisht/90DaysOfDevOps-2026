# Day 87 — Introduction to Agentic AI for DevOps

## 1. What are AI Agents and How They Differ from Chatbots

An **AI agent** is an LLM-based system that can use tools to interact with an environment and perform tasks based on a user's request.

A normal chatbot mainly follows this flow:

```text
User Question
      ↓
     LLM
      ↓
Text Response
```

An AI agent adds tools and an execution loop:

```text
User Question
      ↓
     LLM
      ↓
Choose Tool
      ↓
Execute Tool
      ↓
Observe Result
      ↓
LLM Reasons Again
      ↓
Final Answer / Action
```

The important difference is that an agent does not have to rely only on information already available in the conversation. It can obtain information from the actual environment.

For example, a Docker troubleshooting agent can execute:

```bash
docker ps -a
docker logs <container>
docker inspect <container>
docker images
docker restart <container>
```

The LLM decides which tool is useful based on the user's request and the results returned by previous tools.

### Why AI Agents are useful for DevOps

DevOps involves many CLI-based tools:

```text
Docker       → docker
Kubernetes   → kubectl
Terraform    → terraform
Ansible      → ansible
GitHub       → gh
AWS          → aws
```

These commands can be wrapped inside Python functions and exposed to an AI agent.

For example:

```text
User: Why is my pod crashing?

Agent:
    → kubectl get pods
    → sees CrashLoopBackOff
    → kubectl describe pod
    → reads events
    → kubectl logs
    → identifies the error
    → explains the root cause
```

This makes the LLM useful not just for explaining commands, but for actually investigating infrastructure.

---

# 2. ReAct Pattern Explained with the Broken-App Example

The agent uses the **ReAct pattern**, which stands for **Reason + Act**.

The basic cycle is:

```text
Reason → Act → Observe → Reason → Act → Observe → ...
```

The LLM decides what information it needs, selects an appropriate tool, receives the tool output, and then reasons about what to do next.

## Creating the Broken Container

For this lab, I created an intentionally failing Docker container:

```bash
docker run -d --name broken-app nginx:alpine sh -c "echo 'app starting...' && sleep 2 && exit 1"
```

The command does the following:

1. Starts an `nginx:alpine` container.
2. Prints `app starting...`.
3. Waits for two seconds.
4. Executes `exit 1`.
5. The process terminates with exit code `1`.

The container was verified using:

```bash
docker ps -a
```

Output:

```text
CONTAINER ID   IMAGE          COMMAND                  STATUS
8eab738bbc33   nginx:alpine   ...                      Exited (1)
```

The logs were checked using:

```bash
docker logs broken-app
```

Output:

```text
app starting...
```

The exit code was verified with:

```bash
docker inspect broken-app --format '{{.State.ExitCode}}'
```

Output:

```text
1
```

The container status was:

```bash
docker inspect broken-app --format '{{.State.Status}}'
```

Output:

```text
exited
```

## ReAct Investigation

When the user asks:

```text
Why is broken-app crashing?
```

the intended agent workflow is:

```text
User:
"Why is broken-app crashing?"
        │
        ▼
REASON:
"I need to check the Docker containers."
        │
        ▼
ACT:
list_containers()
        │
        ▼
OBSERVE:
broken-app exists and is Exited (1)
        │
        ▼
REASON:
"I should check its logs."
        │
        ▼
ACT:
get_logs("broken-app")
        │
        ▼
OBSERVE:
"app starting..."
        │
        ▼
REASON:
"I should inspect the container state and exit code."
        │
        ▼
ACT:
inspect_container("broken-app")
        │
        ▼
OBSERVE:
ExitCode = 1
Status = exited
        │
        ▼
FINAL ANSWER:
The container crashes because its command explicitly
exits with code 1 after two seconds.
```

The important concept is that the agent is not simply told:

```text
Run docker ps.
Then run docker logs.
Then run docker inspect.
```

Instead, the LLM is given tools and instructions, and it determines which tools are required to investigate the problem.

---

# 3. Environment Setup

The reference task uses **Gemma 4**, but for this lab I used:

```text
qwen2.5:1.5b
```

The reason for using the smaller model is the available Ubuntu environment has approximately **4 GB RAM**.

## Ollama

The local LLM runtime is Ollama.

The model was checked with:

```bash
ollama list
```

The model used by the agent is:

```text
qwen2.5:1.5b
```

## Python Environment

A Python virtual environment was created:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Dependencies were installed with:

```bash
pip install -r requirements.txt
```

The project uses packages including:

```text
ollama
langchain
langchain-ollama
langgraph
fastmcp
langchain-mcp-adapters
```

## Docker, Kubernetes and Kind

The agent environment was also verified for the DevOps tools required by the project:

```bash
docker --version
kubectl version --client
kind version
ollama list
```

The setup verification was adapted for the Qwen model used in this lab.

Expected result:

```text
[PASS] Python 3.10+
[PASS] Docker
[PASS] kubectl
[PASS] Kind
[PASS] Ollama + qwen2.5:1.5b

5/5 -- you're ready for Day 1!
```

## LLM Test

Before running the complete agent, I verified that LangChain could communicate with the Qwen model:

```python
from langchain_ollama import ChatOllama

llm = ChatOllama(model="qwen2.5:1.5b")
response = llm.bind_tools([]).invoke("What is Docker?")
print(response)
```

The model successfully returned a normal response, confirming that:

```text
Python
   ↓
LangChain
   ↓
Ollama
   ↓
Qwen 2.5 1.5B
```

was working correctly.

---

# 4. Agent Architecture Diagram

The Docker Troubleshooter Agent consists of four main parts:

- User
- LLM
- Tools
- Docker environment

```text
                         ┌─────────────────────┐
                         │        USER         │
                         │                     │
                         │ "Why is broken-app  │
                         │      crashing?"     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   Qwen 2.5 1.5B    │
                         │      via Ollama     │
                         │                     │
                         │       LLM Brain     │
                         └──────────┬──────────┘
                                    │
                              Reason / Act
                                    │
              ┌─────────────────────┼─────────────────────┐
              │                     │                     │
              ▼                     ▼                     ▼
     ┌────────────────┐    ┌────────────────┐    ┌──────────────────┐
     │list_containers │    │    get_logs    │    │inspect_container │
     └───────┬────────┘    └───────┬────────┘    └────────┬─────────┘
             │                     │                       │
             ▼                     ▼                       ▼
        docker ps -a          docker logs             docker inspect
             │                     │                       │
             └─────────────────────┼───────────────────────┘
                                   │
                                   ▼
                         ┌─────────────────────┐
                         │    Tool Results     │
                         │                     │
                         │ stdout / stderr     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   Qwen reads the    │
                         │    tool results     │
                         └──────────┬──────────┘
                                    │
                         Need another tool?
                              /          \
                            Yes           No
                             │             │
                             ▼             ▼
                       More tools    Final Answer
```

The architecture is not specific to Docker.

The same pattern can later be used for:

```text
Docker      → docker
Kubernetes  → kubectl
Terraform   → terraform
AWS         → aws
GitHub      → gh
Ansible     → ansible
```

This is why agentic AI is particularly useful for DevOps.

---

# 5. Tool Added and How the Agent Used It

The original Docker agent contained three tools:

```text
list_containers()
get_logs()
inspect_container()
```

I extended it by adding two tools.

## Tool 1 — `list_images()`

```python
@tool
def list_images() -> str:
    """List all Docker images on this machine with their sizes."""
    result = subprocess.run(
        ["docker", "images"],
        capture_output=True,
        text=True
    )
    return result.stdout or result.stderr
```

The tool executes:

```bash
docker images
```

Its purpose is to allow the agent to answer questions about Docker images.

For example:

```text
User:
"What Docker images do I have?"
```

The LLM can select:

```text
list_images()
```

which runs:

```bash
docker images
```

and returns the output to the LLM.

The LLM then converts that output into a human-readable response.

## Tool 2 — `restart_container()`

I also added an action tool:

```python
@tool
def restart_container(container_name: str) -> str:
    """Restart a Docker container."""
    result = subprocess.run(
        ["docker", "restart", container_name],
        capture_output=True,
        text=True
    )
    return result.stdout or result.stderr
```

This executes:

```bash
docker restart <container_name>
```

The complete tool list became:

```python
tools = [
    list_containers,
    get_logs,
    inspect_container,
    list_images,
    restart_container
]
```

The important difference is that `list_images()` is a **read-only tool**, while `restart_container()` is an **action tool** because it changes the state of a Docker container.

For example:

```text
User:
"Restart broken-app."
        ↓
LLM
        ↓
restart_container("broken-app")
        ↓
docker restart broken-app
        ↓
Docker output
        ↓
LLM
        ↓
Final response
```

One important observation from the experiment is that restarting `broken-app` does not permanently fix it. The container's command contains:

```bash
exit 1
```

so it will terminate again after restarting.

This demonstrates why an agent should diagnose the actual root cause instead of blindly performing actions.

---

# 6. System Prompt and Temperature Explained

## System Prompt

The agent uses a system prompt to define its role and provide rules for tool usage.

The system prompt used was:

```python
SYSTEM_PROMPT = """You are a Docker troubleshooting agent.

Your job is to diagnose Docker container problems using the available tools.

IMPORTANT:

- Do not guess the cause of a container problem.
- Always inspect the Docker environment before answering.
- If the user asks why a container is crashing:
  1. Call list_containers first.
  2. Call get_logs for the affected container.
  3. Call inspect_container to check its state and exit code.
- If the user explicitly asks to restart a container, use restart_container.
- If the user asks about Docker images, use list_images.
- Use the tool results as evidence.
- After investigating, give a short explanation of the root cause and the recommended fix.
"""
```

The prompt is important because the LLM needs to understand:

### Role

```text
You are a Docker troubleshooting agent.
```

This establishes what the agent is supposed to do.

### Evidence-based diagnosis

```text
Do not guess the cause.
```

This encourages the agent to inspect the environment instead of immediately generating a generic answer.

### Tool order

For a crashing container, the prompt tells the model to:

```text
1. list_containers
2. get_logs
3. inspect_container
```

This is particularly useful with a small local model such as `qwen2.5:1.5b`.

### Tool selection

The prompt also explains when to use the additional tools:

```text
restart_container → when the user asks for a restart

list_images → when the user asks about Docker images
```

The LLM can then map the user's request to the correct tool.

## Why the Prompt Matters

Without enough guidance, a small model may respond with a generic troubleshooting explanation instead of actually calling the Docker tools.

For example, it may say:

```text
The container could be crashing because of configuration,
dependencies, resources, or networking.
```

That is not useful when the agent has access to the actual Docker environment.

The system prompt pushes it toward:

```text
Inspect → Collect Evidence → Reason → Answer
```

instead of:

```text
Guess → Answer
```

## Temperature

The agent uses:

```python
llm = ChatOllama(
    model="qwen2.5:1.5b",
    temperature=0,
)
```

Temperature controls the randomness of the model's output.

### `temperature=0`

A temperature of `0` makes the model highly deterministic.

This is useful for DevOps troubleshooting because we generally want:

```text
Consistent
Predictable
Focused
Technical
```

responses.

The Docker Error Explainer uses a slightly higher value:

```python
temperature=0.3
```

This still keeps the response controlled while allowing a little more variation.

For an infrastructure agent, a low temperature is preferable because the goal is not creativity. The goal is reliable reasoning and correct tool usage.

---

## Summary

Day 87 introduced the basic architecture of an Agentic AI system for DevOps:

```text
LLM + Tools + ReAct Loop
```

Using **Qwen 2.5 1.5B with Ollama**, the agent can interact with Docker through Python tools.

The main tools implemented were:

```text
list_containers()
get_logs()
inspect_container()
list_images()
restart_container()
```

The intentionally broken `broken-app` container demonstrated how an agent can inspect real infrastructure, collect evidence, and diagnose a failure rather than simply generating a generic answer.

The architecture can now be extended beyond Docker to Kubernetes, Terraform, AWS, and other DevOps tools.

