# Day 88 — Multi-Tool Agents, MCP, and CI/CD Analyzer

## Overview

Today I extended the DevOps AI agent to work across Docker, Kubernetes, MCP, and GitHub Actions.

The main goal was to build an agent that can select the correct tool based on the problem instead of having separate agents for every DevOps task.

---

## 1. Multi-Tool DevOps Agent

The Module 3 agent contains **6 tools** across two domains.

### Docker Tools

- `list_containers()` — lists Docker containers.
- `get_logs(container_name)` — retrieves container logs.
- `inspect_container(container_name)` — inspects container configuration.

### Kubernetes Tools

- `list_pods(namespace)` — lists Kubernetes pods and their status.
- `describe_pod(pod_name, namespace)` — provides detailed pod information and events.
- `get_events(namespace)` — retrieves Kubernetes events.

### Architecture

```text
                 User
                   |
                   v
            ReAct AI Agent
                   |
          +--------+--------+
          |                 |
          v                 v
      Docker Tools      Kubernetes Tools
       |  |  |             |  |  |
       v  v  v             v  v  v
     Docker CLI          kubectl CLI

The agent decides which tools to call based on the user's question.

For example:

"Why is broken-pod crashing?"
        ↓
list_pods()
        ↓
describe_pod()
        ↓
get_events()
        ↓
AI explains the problem
2. Broken Resources

To test the agent, I created a Kubernetes pod that intentionally crashes:

apiVersion: v1
kind: Pod
metadata:
  name: broken-pod
spec:
  containers:
  - name: app
    image: nginx:alpine
    command: ["sh", "-c", "echo 'app starting...' && sleep 2 && exit 1"]

I also created a broken Docker container:

docker run -d --name broken-container nginx:alpine \
  sh -c "echo 'container starting...' && sleep 2 && exit 1"

This allowed the agent to diagnose failures from both Docker and Kubernetes.

3. Model Context Protocol (MCP)

MCP (Model Context Protocol) is an open standard for connecting AI applications to external tools and data.

Instead of defining tools directly inside an agent, an MCP server exposes tools that compatible AI clients can discover and use.

MCP Architecture
              MCP Server
                  |
        +---------+---------+
        |         |         |
   list_pods  describe   get_events
        |         |         |
        +---------+---------+
                  |
             MCP Protocol
                  |
        +---------+---------+
        |         |         |
      Claude    VS Code   Python Agent
Why MCP Matters

Without MCP:

AI Agent → Hardcoded Tools

With MCP:

AI Client → MCP → Tools

This means the same tools can potentially be reused by different MCP-compatible clients.

4. MCP Kubernetes Server

The module-3/mcp_server.py file exposes Kubernetes functionality through FastMCP.

The tools use:

@mcp.tool

instead of LangChain's:

@tool

The server is created using:

mcp = FastMCP("Kubernetes Tools")

and started with:

mcp.run()

The MCP server provides:

list_pods()
describe_pod()
get_events()
5. MCP Client Agent

agent_with_mcp.py connects the AI agent to the MCP server using:

MultiServerMCPClient

The client dynamically discovers the tools:

tools = await client.get_tools()

The important difference is that the agent does not need to contain the Kubernetes tool implementations itself.

Python Agent
     |
     v
MCP Client
     |
     v
MCP Server
     |
     v
   kubectl
     |
     v
 Kubernetes
6. CI/CD Failure Analyzer

Module 6 contains a separate agent for diagnosing GitHub Actions failures.

It uses the GitHub CLI (gh) to inspect workflow runs.

Tools
list_workflow_runs()
        ↓
Find failed GitHub Actions runs

get_failed_logs(run_id)
        ↓
Retrieve logs from the failed run

get_workflow_file(workflow_name)
        ↓
Read the workflow YAML

The agent can answer questions such as:

What failed in my last CI run?

Show me the recent workflow runs.

Read the gitops-ci.yml workflow and explain it.
Log Truncation

CI logs can become very large, so the analyzer limits the output:

if len(output) > 5000:
    output = output[:5000] + "\n\n[...truncated]"

This prevents unnecessary context from being sent to the LLM.

7. Custom Tool

I followed the same tool pattern to create a custom DevOps tool.

The general pattern is:

@tool
def my_tool() -> str:
    """Describe exactly when the agent should use this tool."""

    result = subprocess.run(
        ["some", "cli", "command"],
        capture_output=True,
        text=True,
    )

    return result.stdout or result.stderr

The important part is the tool description.

The LLM uses the function name and docstring to understand when the tool should be used.

8. General CLI Tool Pattern

The main pattern learned today is:

1. Define a tool
       ↓
2. Wrap a CLI/API command
       ↓
3. Return useful output
       ↓
4. Give the tool a clear docstring
       ↓
5. Register it with the agent
       ↓
6. Let the LLM decide when to use it

This pattern can be applied to:

Docker
Kubernetes
GitHub
Terraform
AWS
Linux
Logs
Monitoring
CI/CD

9. Key Takeaways
Built a multi-tool DevOps agent with 6 tools.
Combined Docker and Kubernetes troubleshooting in one agent.
Created an intentionally broken Kubernetes pod for testing.
Learned how MCP separates tools from the AI client.
Built an MCP server using FastMCP.
Connected an agent to MCP tools dynamically.
Built a GitHub Actions CI/CD Failure Analyzer.
Learned why large CI logs should be truncated.
Learned that almost any CLI command can be converted into an AI tool.
Day 88 Result
Docker + Kubernetes
        ↓
 Multi-Tool Agent
        ↓
   ReAct Reasoning
        ↓
   Correct Tool
        ↓
 DevOps Diagnosis

MCP extends this further by making the tools reusable across different AI clients.
