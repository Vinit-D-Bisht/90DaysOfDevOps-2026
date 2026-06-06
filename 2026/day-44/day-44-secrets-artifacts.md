# Task 1: GitHub Secrets

## Secret Created

```text
MY_SECRET_MESSAGE
```

## Workflow File

```yaml
name: Secrets Demo

on:
  push:
    branches:
      - main
      - master

jobs:
  secrets-test:
    runs-on: ubuntu-latest

    steps:
      - name: Check Secret
        run: |
         if [ -n "${{ secrets.MY_SECRET_MESSAGE }}" ]; then
           echo "The secret is set: true"
         else    
           echo "The secret is set: false"
         fi
```

## What Happens If You Print The Secret?

```yaml
run: echo "${{ secrets.MY_SECRET_MESSAGE }}"
```

GitHub automatically masks the value in logs and displays:

```text
***
```

## Why Should Secrets Never Be Printed?

Secrets may contain passwords, API keys, access tokens, or credentials. Exposing them in CI logs could allow unauthorized access to systems and services.

---

# Task 2: Using Secrets as Environment Variables

## Example Workflow

```yaml
name: Secret Environment Variable

on:
  push:
    branches:
      - main
      - master

jobs:
  env-secret:
    runs-on: ubuntu-latest

    steps:
      - name: Use Secret
        env:
          SECRET_MESSAGE: ${{ secrets.MY_SECRET_MESSAGE }}

        run: |
          echo "Secret loaded successfully"
```

## Additional Secrets Added

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

These secrets will be used later for Docker Hub authentication.

---

# Task 3: Upload Artifacts

## Workflow File

```yaml
name: Upload Artifact

on:
  push:
    branches:
      - main
      - master

jobs:
  upload:
    runs-on: ubuntu-latest

    steps:
      - name: Generate Report
        run: echo "Pipeline Report" > report.txt

      - name: Upload Artifact
        uses: actions/upload-artifact@v4
        with:
          name: report
          path: report.txt
```

## Result

1. File was generated successfully.
2. Artifact appeared in the workflow summary.
3. Artifact could be downloaded from the Actions tab.

---

# Task 4: Download Artifacts Between Jobs

## Workflow File

```yaml
name: Artifact Sharing

on:
  push:

jobs:
  create-artifact:
    runs-on: ubuntu-latest

    steps:
      - run: echo "Hello from Job 1" > message.txt

      - uses: actions/upload-artifact@v4
        with:
          name: message
          path: message.txt

    use-artifact:
      runs-on: ubuntu-latest
      needs: create-artifact

    steps:
      - uses: actions/download-artifact@v4
        with:
          name: message
      - run: cat message.txt
```

## When Are Artifacts Useful?

Artifacts are useful for sharing reports, logs, build outputs, test results, compiled binaries, and deployment packages between jobs.

---

# Task 5: Run Real Tests in CI

## Example Python Script

### `calculator.py`

```python
def add(a, b):
    return a + b

    assert add(2, 3) == 5

    print("Tests Passed")
```

## Workflow File

```yaml
name: Python Test

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest
        
    steps:
      - uses: actions/checkout@v4

    - uses: actions/setup-python@v5
      with:
        python-version: "3.12"

    - name: Run Tests
      run: python calculator.py
```

## Testing Failure

Changed:

```python
assert add(2, 3) == 6
```

Result:

```text
AssertionError
```

Pipeline status became red 

## After Fix

Changed back to:

```python
assert add(2, 3) == 5
```

Pipeline status became green 

---

# Task 6: Caching

## Workflow File

```yaml
name: Cache Demo

on:
  push:
    branches:
      - main 
      - master

jobs:
  cache:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - uses: actions/cache@v4
        with:
          path: ~/.cache/pip
          key: pip-${{ runner.os }}-${{ hashFiles('requirements.txt') }

        - run: pip install -r requirements.txt
```

## What Is Being Cached?

Installed Python packages and dependencies.

## Where Is It Stored?

The cache is stored by GitHub and restored automatically in future workflow runs when the cache key matches.

---

# Key Learnings

1. GitHub Secrets securely store sensitive information and automatically mask values in logs.
2. Artifacts allow files to be shared between jobs and downloaded after workflow execution.
3. Caching speeds up workflows by reusing previously downloaded dependencies.
