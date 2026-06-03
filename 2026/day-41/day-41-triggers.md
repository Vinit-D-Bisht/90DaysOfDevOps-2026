# Task 1: Trigger on Pull Request

## Workflow File

### `.github/workflows/pr-check.yml`

```yaml
name: PR Check

on:
  pull_request:
      branches:
        - main
      types:
        - opened
        - synchronize

jobs:
  pr-check:
    runs-on: ubuntu-latest

    steps:
      - name: Print PR Branch
        run: echo "PR check running for branch: ${{ github.head_ref }}"

```

## Result
1. Created a new branch
2. Pushed a commit
3. Opened a Pull Request against main
4. Workflow triggered automatically
5. Workflow appeared in the PR Checks section

---

# Task 2: Scheduled Trigger

## Schedule Workflow

```yaml
on:
  schedule:
      - cron: '0 0 * * *'
```

Runs every day at midnight UTC.

## Cron Expression Answer

Every Monday at 9 AM:

```text
0 9 * * 1
```

---

# Task 3: Manual Trigger

## Workflow File

### `.github/workflows/manual.yml`

```yaml
name: Manual Workflow

on:
  workflow_dispatch:
    inputs:
      environment:
        description: Environment Name
        required: true
        default: staging

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Print Environment
        run: echo "Environment: ${{ github.event.inputs.environment }}"
```

## Result
1. Opened Actions tab
2. Selected workflow
3. Clicked Run Workflow
4. Entered environment value
5. Workflow executed successfully

---

# Task 4: Matrix Builds

## Workflow File

### `.github/workflows/matrix.yml`

```yaml
name: Matrix Build

on:
  push:

jobs:
  test:
    runs-on: ${{ matrix.os }}

    strategy:
      matrix:
        os:
          - ubuntu-latest
          - windows-latest

        python-version:
           - "3.10"
           - "3.11" 
           - "3.12"
       steps:
         - uses: actions/checkout
       
         - name: Setup Python
           uses: actions/setup-python@v5
           with:
             python-version: ${{ matrix.python-version }}

         - name: Print Python Version
           run: python --version
```

## Result

Python Versions:

1. Python 3.10
2. Python 3.11
3. Python 3.12

Operating Systems:

1. Ubuntu
2. Windows

Total Jobs:

```text
3 × 2 = 6 jobs
```

All jobs ran in parallel.

---

# Task 5: Exclude & Fail-Fast

## Updated Matrix

```yaml
strategy:
  fail-fast: false

matrix:
  os:
    - ubuntu-latest
    - windows-latest

  python-version:
    - "3.10"
    - "3.11"
    - "3.12"
    
  exclude:
    - os: windows-latest
      python-version: "3.10"
```

## Result

Excluded Combination:

```text
Windows + Python 3.10
```

Remaining Jobs:

```text
5 jobs
```

## Fail-Fast Comparison

### fail-fast: true
If one matrix job fails, GitHub cancels the remaining jobs automatically.

### fail-fast: false
If one matrix job fails, all other jobs continue running until completion.

---

# Key Learnings
1. GitHub Actions supports push, pull request, scheduled, and manual triggers.
2. Matrix builds allow testing across multiple versions and operating systems simultaneously.
3. Fail-fast controls whether remaining matrix jobs continue after a failure

