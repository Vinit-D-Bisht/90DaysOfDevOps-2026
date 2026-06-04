# Task 1: GitHub-Hosted Runners

## Workflow File

### `.github/workflows/hosted-runners.yml`

```yaml
name: Hosted Runners

on:
  push:
    branches:
         - main
         - master

jobs:
  ubuntu:
    runs-on: ubuntu-latest
    steps:
      - run: |
          echo "OS: Linux"
          hostname
          whoami

  windows:
    runs-on: windows-latest
      steps:
         - run: |
            echo OS: Windows
            hostname
            whoami

  macos:
    runs-on: macos-latest                                   
    steps:
      - run: |
          echo "OS: macOS"                                                 
          hostname                                         
          whoami

```

## Result
1. Workflow ran on Ubuntu, Windows, and macOS.
2. All jobs executed in parallel.
3. Each job displayed OS information, hostname, and current user.

## What is a GitHub-Hosted Runner?

A GitHub-hosted runner is a virtual machine provided and managed by GitHub that executes workflow jobs.

## Who Manages It?

GitHub manages the infrastructure, operating system, updates, and maintenance.

---

# Task 2: Explore Pre-Installed Software

## Workflow Step

```yaml
- name: Check Installed Tools
  run: |
      docker --version
      python --version
      node --version
      git --version

```

## Output Observed

1. Docker Version
2. Python Version
3. Node.js Version
4. Git Version

## Why Do Pre-Installed Tools Matter?

Pre-installed tools reduce setup time and allow workflows to start immediately without installing common software during every run.

---

# Task 3: Set Up a Self-Hosted Runner

## Steps Performed
1. Opened Repository Settings
2. Navigated to Actions -> Runners
3. Selected New Self-Hosted Runner
4. Chose Linux
5. Followed GitHub setup instructions
6. Started the runner using:

```bash
./run.sh
```

## Result

The runner successfully connected to GitHub and appeared as Idle with a green status indicator.

---

# Task 4: Use Your Self-Hosted Runner

## Workflow File

### `.github/workflows/self-hosted.yml`

```yaml
name: Self Hosted Runner

on:
  workflow_dispatch:

  jobs:
    self-hosted-job:
    runs-on: self-hosted

    steps:
      - name: Print Hostname
        run: hostname

      - name: Print Working Directory
        run: pwd

      - name: Create Test File
        run: touch runner-test.txt

      - name: Verify File
        run: ls -la

```

## Result

1. Workflow executed on my own machine.
2. Hostname matched my local system.
3. Working directory was displayed.
4. Test file was created successfully.
5. File existed on the runner machine after execution.

---

# Task 5: Labels

## Updated Workflow

```yaml
runs-on:
  - self-hosted
  - my-linux-runner
```

## Result

The workflow successfully selected the labeled runner and completed execution.

## Why Are Labels Useful?

Labels help target specific runners when multiple self-hosted runners are available, ensuring jobs run on the correct machine.

---

# Task 6: GitHub-Hosted vs Self-Hosted

1. *GitHub-hosted* runners are managed by GitHub, include many pre-installed tools, and are available within GitHub Actions usage limits. They are best for quick setup and standard workloads, with jobs running on GitHub-managed infrastructure.

2. *Self-hosted* runners are managed by the user or organization and run on their own infrastructure. They require users to install and maintain tools, making them suitable for custom environments, while security and maintenance remain the user's responsibility.

---

# Key Learnings

1. Runners are machines responsible for executing GitHub Actions workflows.
2. GitHub-hosted runners are managed by GitHub and come with many tools pre-installed.
3. Self-hosted runners provide greater control and customization but require user management.
