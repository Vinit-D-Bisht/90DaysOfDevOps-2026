# Task 1: Pull Request Lifecycle Events

## File

```text
.github/workflows/pr-lifecycle.yml
```

## YAML

```yaml
name: PR Lifecycle

on:
  pull_request:
    types:
      - opened
      - synchronize
      - reopened
      - closed

jobs:
  pr-info:
    runs-on: ubuntu-latest

    steps:
      - name: Print PR Information
        run: |
          echo "Event: ${{ github.event.action }}"
          echo "Title: ${{ github.event.pull_request.title }}"
          echo "Author: ${{ github.event.pull_request.user.login }}"
          echo "Source Branch: ${{ github.head_ref }}"
          echo "Target Branch: ${{ github.base_ref }}"

      - name: Run Only If Merged
        if: github.event.pull_request.merged == true
        run: echo "Pull Request was merged successfully"
```

## Result

1. Workflow triggered when PR was opened.
2. Triggered again when new commits were pushed.
3. Triggered after reopening.
4. Triggered after closing/merging.
5. Merge-specific step only executed when PR was merged.

---

# Task 2: PR Validation Workflow

## File

```text
.github/workflows/pr-checks.yml
```

## YAML

```yaml
name: PR Checks

on:
  pull_request:
    branches:
      - main

jobs:
  file-size-check:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Check Large Files
        run: |
          find . -type f -size +1M && exit 1 || echo "All files OK"

  branch-name-check:
    runs-on: ubuntu-latest

    steps:
      - name: Validate Branch Name
        run: |
          if [[ ! "${{ github.head_ref }}" =~ ^(feature|fix|docs)/ ]]; then
            echo "Invalid branch name"
            exit 1
          fi

  pr-body-check:
    runs-on: ubuntu-latest

    steps:
      - name: Check PR Description
        run: |
          if [ -z "${{ github.event.pull_request.body }}" ]; then
            echo "Warning: PR description is empty"
          fi
```

## Result

1. Large files are blocked.
2. Incorrect branch naming fails validation.
3. Empty PR descriptions generate warnings.

---

# Task 3: Scheduled Workflows

## File

```text
.github/workflows/scheduled-tasks.yml
```

## YAML

```yaml
name: Scheduled Tasks

on:
  workflow_dispatch:

  schedule:
    - cron: '30 2 * * 1'
    - cron: '0 */6 * * *'

jobs:
  scheduled-job:
    runs-on: ubuntu-latest

    steps:
      - name: Print Schedule
        run: echo "Triggered by ${{ github.event.schedule }}"

      - name: Website Health Check
        run: |
          curl -I https://github.com
```

---

## Cron Expressions

### Every Weekday At 9 AM IST

```text
30 3 * * 1-5
```

### First Day Of Every Month At Midnight UTC

```text
0 0 1 * *
```

### Why Scheduled Workflows May Be Delayed

1. GitHub schedules are best effort.
2. High platform load can delay execution.
3. Inactive repositories may have scheduled workflows temporarily disabled.

---

# Task 4: Path & Branch Filters

## File

```text
.github/workflows/smart-triggers.yml
```

## YAML

```yaml
name: Smart Trigger

on:
  push:
    branches:
      - main
      - release/**

    paths:
      - 'src/**'
      - 'app/**'

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Application files changed"
```

---

## Ignore Documentation Changes

```yaml
name: Ignore Docs

on:
  push:
    paths-ignore:
      - '*.md'
      - 'docs/**'

jobs:
  skip-docs:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Code changes detected"
```

---

## Paths vs Paths-Ignore

### paths

Runs workflow only when matching files change.

### paths-ignore

Skips workflow when only matching files change.

---

# Task 5: workflow_run

## File 1

```text
.github/workflows/tests.yml
```

## YAML

```yaml
name: Run Tests

on:
  push:

jobs:
  tests:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Running Tests"
```

---

## File 2

```text
.github/workflows/deploy-after-tests.yml
```

## YAML

```yaml
name: Deploy After Tests

on:
  workflow_run:
    workflows:
      - Run Tests
    types:
      - completed

jobs:
  deploy:
    if: github.event.workflow_run.conclusion == 'success'

    runs-on: ubuntu-latest

    steps:
      - run: echo "Deploying Application"

  failed:
    if: github.event.workflow_run.conclusion != 'success'

    runs-on: ubuntu-latest

    steps:
      - run: echo "Tests failed. Deployment skipped."
```

## Result

1. Tests workflow executes first.
2. Deployment workflow waits for completion.
3. Deployment occurs only after successful tests.

---

# Task 6: repository_dispatch

## File

```text
.github/workflows/external-trigger.yml
```

## YAML

```yaml
name: External Trigger

on:
  repository_dispatch:
    types:
      - deploy-request

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Print Payload
        run: |
          echo "Environment: ${{ github.event.client_payload.environment }}"
```

## Trigger Command

```bash
gh api repos/<owner>/<repo>/dispatches \
  -f event_type=deploy-request \
  -f client_payload='{"environment":"production"}'
```

## Use Cases

1. Slack deployment buttons.
2. Monitoring alerts triggering remediation.
3. External deployment systems.
4. Incident response automation.

---

# workflow_run vs workflow_call

## workflow_run

1. Triggers after another workflow completes.
2. Useful for workflow chaining.
3. Workflows remain independent.

## workflow_call

1. Reuses workflow logic directly.
2. Similar to calling a function.
3. Supports inputs, outputs, and secrets.

---

# Key Learnings

1. GitHub Actions supports many event-driven triggers beyond simple push events.
2. Path filters and branch filters help reduce unnecessary workflow runs.
3. workflow_run enables CI/CD pipeline chaining while workflow_call enables workflow reuse.
