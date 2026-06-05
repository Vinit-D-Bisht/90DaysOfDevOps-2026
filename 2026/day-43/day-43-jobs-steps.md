# 1: Multi-Job Workflow

## Workflow File

### `.github/workflows/multi-job.yml`

```yaml
name: Multi Job Workflow

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - run: echo "Building the app"

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - run: echo "Running tests"

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - run: echo "Deploying"

```

## Result

1. Build job ran first.
2. Test job started only after build succeeded.
3. Deploy job started only after test succeeded.
4. Workflow graph displayed the dependency chain correctly.

---

# Task 2: Environment Variables

## Workflow File

```yaml
name: Environment Variables

on:
  push:

env:
  APP_NAME: myapp

jobs:
  demo:
    runs-on: ubuntu-latest

    env:
      ENVIRONMENT: staging

    steps:
      - name: Print Variables
        env:
          VERSION: 1.0.0
        run: |
          echo "App: $APP_NAME"
          echo "Environment: $ENVIRONMENT"
          echo "Version: $VERSION"

      - name: Print GitHub Context Variables
        run: |
          echo "SHA: ${{ github.sha }}"
          echo "Actor: ${{ github.actor }}"

```

## Result

Successfully accessed:

1. Workflow-level variable
2. Job-level variable
3. Step-level variable
4. GitHub context variables

---

# Task 3: Job Outputs

## Workflow File

```yaml
name: Job Outputs

on:
  push:

jobs:
  generate-date:
   runs-on: ubuntu-latest

   outputs:
    today: ${{ steps.date.outputs.today }}

   steps:
     - id: date
       run: echo "today=$(date)" >> $GITHUB_OUTPUT

  print-date:
    runs-on: ubuntu-latest
    needs: generate-date

    steps:
     - run: echo "${{ needs.generate-date.outputs.today }}"
```

## Why Pass Outputs Between Jobs?

Outputs allow one job to generate data that can be reused by other jobs later in the workflow.

Examples include version numbers, image tags, build results, and deployment information.

---

# Task 4: Conditionals

## Example Workflow

```yaml
name: Conditionals

on:
  push:
    pull_request:

jobs:
  demo:
    runs-on: ubuntu-latest

    steps:
      - name: Main Branch Only
        if: github.ref == 'refs/heads/main'
        run: echo "Running on main"

      - name: Intentional Failure
        run: exit 1
        continue-on-error: true

      - name: Run After Failure
        if: failure()
        run: echo "Previous step failed"
```

## Push Only Job

```yaml
job-push-only:
  if: github.event_name == 'push'
  runs-on: ubuntu-latest

   steps:
      - run: echo "Push Event"
```

## What Does continue-on-error Do?

The workflow continues executing even if that specific step fails.

---

# Task 5: Smart Pipeline

## Workflow File

### `.github/workflows/smart-pipeline.yml`

```yaml
name: Smart Pipeline

on:
  push:

jobs:
    lint:
      runs-on: ubuntu-latest

      steps:
        - run: echo "Linting Code"

    test:
      runs-on: ubuntu-latest

       steps:
         - run: echo "Running Tests"

    summary:
      runs-on: ubuntu-latest
      needs:
        - lint
        - test

      steps:
        - name: Branch Type
          run: |
            if [ "${{ github.ref_name }}" = "main" ]; then
              echo "Main Branch Push"
            ele
              echo "Feature Branch Push"
            fi

        - name: Commit Message
          run: echo "${{ github.event.commits[0].message }}"
```

## Result

1. Lint and test jobs ran in parallel.
2. Summary job waited for both jobs.
3. Branch type was displayed.
4. Commit message was printed.

---

# Understanding Key Concepts

## What Does `needs:` Do?

`needs:` creates job dependencies and ensures a job runs only after specified jobs complete successfully.

## What Does `outputs:` Do?

`outputs:` allows a job to expose values that can be consumed by other jobs later in the workflow.

---

# Key Learnings

1. Jobs can run sequentially using `needs` or in parallel when no dependency exists.
2. Environment variables can be defined at workflow, job, and step levels.
3. Conditions and outputs make workflows dynamic and more intelligent.
