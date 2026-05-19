# Git Commands Reference

## Setup & Config

### Check Git Version

```bash
git --version
```

---

### Configure Username

```bash
git config --global user.name "Vinit"
```

---

### Configure Email

```bash
git config --global user.email "you@example.com"
```

---

### Verify Git Config

```bash
git config --list
```

---

## Basic Workflow

### Initialize Repository

```bash
git init
```

---

### Check Repository Status

```bash
git status
```

---

### Stage File

```bash
git add file.txt
```

---

### Stage All Files

```bash
git add .
```

---

### Commit Changes

```bash
git commit -m "message"
```

---

### View Commit History

```bash
git log
```

---

### Compact Commit History

```bash
git log --oneline
```

---

### View Changes

```bash
git diff
```

---

## Branching

### List Branches

```bash
git branch
```

---

### Create Branch

```bash
git branch feature-1
```

---

### Switch Branch

```bash
git switch feature-1
```

---

### Create and Switch Branch

```bash
git checkout -b feature-2
```

---

### Delete Branch

```bash
git branch -d feature-1
```

---

## Remote Repository

### Add Remote Repository

```bash
git remote add origin <repo-url>
```

---

### Push Branch

```bash
git push -u origin main
```

---

### Pull Changes

```bash
git pull origin main
```

---

### Fetch Changes

```bash
git fetch
```

---

### Clone Repository

```bash
git clone <repo-url>
```

---

## Merge & Rebase

### Merge Branch

```bash
git merge feature-login
```

---

### Rebase Branch

```bash
git rebase main
```

---

### View Graph History

```bash
git log --oneline --graph --all
```

---

### Squash Merge

```bash
git merge --squash feature-profile
```

---

## Stash

### Stash Changes

```bash
git stash
```

---

### Stash with Message

```bash
git stash push -m "work in progress"
```

---

### List Stashes

```bash
git stash list
```

---

### Apply Stash

```bash
git stash apply
```

---

### Pop Stash

```bash
git stash pop
```

---

## Cherry Pick

### Cherry Pick Commit

```bash
git cherry-pick <commit-id>
```

---

## Reset & Revert

### Soft Reset

```bash
git reset --soft HEAD~1
```

---

### Mixed Reset

```bash
git reset --mixed HEAD~1
```

---

### Hard Reset

```bash
git reset --hard HEAD~1
```

---

### Revert Commit

```bash
git revert <commit-id>
```

---

### View Reflog

```bash
git reflog
```

---

## GitHub CLI (gh)

### Check gh Version

```bash
gh --version
```

---

### Login to GitHub

```bash
gh auth login
```

---

### Check Login Status

```bash
gh auth status
```

---

### Create Repository

```bash
gh repo create
```

---

### Clone Repository

```bash
gh repo clone owner/repo
```

---

### View Repository

```bash
gh repo view
```

---

### List Repositories

```bash
gh repo list
```

---

### Open Repository in Browser

```bash
gh repo view --web
```

---

### Delete Repository

```bash
gh repo delete repo-name
```

---

## GitHub Issues

### Create Issue

```bash
gh issue create
```

---

### List Issues

```bash
gh issue list
```

---

### View Issue

```bash
gh issue view 1
```

---

### Close Issue

```bash
gh issue close 1
```

---

## GitHub Pull Requests

### Create Pull Request

```bash
gh pr create --fill
```

---

### List Pull Requests

```bash
gh pr list
```

---

### View Pull Request

```bash
gh pr view
```

---

### Merge Pull Request

```bash
gh pr merge --merge
```

---

### Review Pull Request

```bash
gh pr review
```

---

## GitHub Actions

### List Workflow Runs

```bash
gh run list
```

---

### View Workflow Run

```bash
gh run view <run-id>
```

---

## Useful gh Commands

### GitHub API Request

```bash
gh api user
```

---

### Create Gist

```bash
gh gist create notes.txt
```

---

### Create Release

```bash
gh release create v1.0
```

---

### Create Alias

```bash
gh alias set prs "pr status"
```

---

### Search Repositories

```bash
gh search repos devops
```
