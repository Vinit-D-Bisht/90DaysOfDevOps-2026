## Task 1: Install and Authenticate

### Install GitHub CLI
```bash
sudo apt install gh -y
```

### Authenticate with GitHub
```bash
gh auth login
```

### Verify Logged-in Account
```bash
gh auth status
```

### 'gh' Supports authentication using: 
1. Browser login
2. Personal Access Token (PAT)
3. SSH authentication

---

# Task 2: Working with Repositories

### Create New Repository
```bash
gh repo create Demo-gh-cli --public --clone
```

### Clone Repository using gh
```bash
gh repo clone cli/cli
```

### View Repository Details
```bash
gh repo view
```

### List All Repositories
```bash
gh repo list
```

### Open Repository in Browser
```bash
gh repo view --web
```

### Delete the latest created Repository
```bash
gh repo delete Demo-gh-cli
```

---

# Task 3: Issues

### Create an Issue
```bash
gh issue create --title "Error in REPO" --body "Fix The error" --label bug
```

### List Open Issues
```bash
gh issue list
```

### View Specific Issue by it's number
```bash
gh issue view 1
```

### Close Issue
```bash
gh issue close 1
```

### 'gh' issues can be used in scripts for:
1. Automated bug tracking
2. CI/CD notifications
3. Auto issue creation during failures

---

# Task 4: Pull Requests

### Create New Branch
```bash
git checkout -b New-Branch
```

### Push Branch
```bash
git push -u origin New-Branch
```

### Create Pull Request
```bash
gh pr create --fill
```

### List Pull Requests
```bash
gh pr list
```

### View PR Details
```bash
gh pr view
```

### Merge Pull Request
```bash
gh pr merge --merge
```

### 'gh pr merge' supports:
1. Merge commit
2. Squash merge
3. Rebase merge

### You can review pr using:
1. `gh pr checkout`
2. `gh pr review`
3. `gh pr diff`

---

# Task 5: GitHub Actions & Workflows

### List Workflow Runs
```bash
gh run list
```

### View Workflow Run Details
```bash
gh run view <run-id>
```

### 'gh run' and 'gh workflow' are useful for:
1. Monitoring CI/CD pipelines
2. Triggering workflows manually
3. Checking deployment status
4. Automating DevOps tasks

---

# Task 6

### GitHub API Calls
```bash
gh api user
```

Makes raw GitHub API request.

### Create Gist
```bash
gh gist create notes.txt
```

Creates GitHub gist from terminal.

### Create Release
```bash
gh release create v1.0
```

Creates GitHub release.

### Create Alias
```bash
gh alias set prs "pr status"
```

Creates shortcut command.

### Search Repositories
```bash
gh search repos devops
```

Searches GitHub repositories from our terminal.

---

# What I Learned

1. GitHub CLI helps manage GitHub directly from terminal.
2. PRs, issues, repos, and workflows can all be managed using `gh`.
3. GitHub CLI is useful for automation and DevOps scripting.
