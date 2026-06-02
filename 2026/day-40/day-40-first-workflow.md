# Task 1: Set Up

## Repository Created / Present

```text
github-actions-practice
```

## Folder Structure

```text
github-actions-practice/.github/ workflows/HOhello.yml
```

---

# Task 2: Hello Workflow

## Workflow File

```yaml
name: HOHello Workflow

on:
  push:
    branches:
      - main
      - master

  jobs:
    greet:
      runs-on: ubuntu-latest

      steps:
        - name: Checkout Repository
          uses: actions/checkout@v4

        - name: Print Greeting
          run: echo "Hello from GitHub Actions!"

```

## Result
After pushing the workflow file to GitHub, the workflow automatically started running.
The workflow completed successfully and displayed a green checkmark in the Actions tab.

---

# Task 3: Workflow Anatomy

## What does `on:` do?

Defines the event that triggers the workflow.

## What does `jobs:` do?

Contains all jobs that will run in the workflow.

## What does `runs-on:` do?

Specifies the operating system used by the runner.

## What does `steps:` do?

Lists all actions and commands executed inside a job.

## What does `uses:` do?

Runs a reusable GitHub Action.

Example:

```yaml
uses: actions/checkout@v4
```

## What does `run:` do?

Executes shell commands on the runner.

Example:

```yaml
run: echo "Hello from GitHub Actions!"
```

## What does `name:` do?

Provides a readable name for workflows, jobs, and steps.

---

# Task 4: Add More Steps

## Updated Workflow

```yaml
name: HOHello Workflow

on:
  push:
    branches:
        - main

  jobs:
    greet:
      runs-on: ubuntu-latest

      steps:
        - name: Checkout Repository
          uses: actions/checkout@v4

        - name: Print Greeting
          run: echo "Hello from GitHub Actions!"

        - name: Print Date and Time
          run: date

        -  name: Print Branch Name
           run: echo "${{ github.ref_name }}"

        - name: List Repository Files
          run: ls -la

        - name: Print Runner OS
          run: echo "$RUNNER_OS"

```

## Output Observed

1. Current date and time
2. Branch name
3. Repository files
4. Runner operating system

---

# Task 5: Break It On Purpose

## Failing Step

```yaml
- name: Fail Step
  run: exit 1
```

## What Happened?
The workflow failed and displayed a red status in the Actions tab.

## How To Read Errors

  1. Open the failed workflow run
  2. Open the failed job
  3. Expand the failed step
  4. Read the logs and error message
  5. Fix the issue and push again

## Result After Fix
After removing the failing step and pushing again, the workflow completed successfully and displayed a green  status.

---

# Key Learnings
1. GitHub Actions automatically runs workflows based on repository events.
2. Workflows are made up of jobs and steps executed on runners.
3. Failed pipelines help identify issues quickly through logs and error messages.
