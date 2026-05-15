# Task 1: Install and Configure Git

## Verify Git Installation

```bash
git --version
```

### Example Output

```bash
git version 2.43.0
```

---

## Configure Git Username

```bash
git config --global user.name "Vinit Bisht"
```

---

## Configure Git Email

```bash
git config --global user.email "yourmail@example.com"
```

---

## Verify Configuration

```bash
git config --list
```

---

# Task 2: Create Your Git Project

## Create Project Directory

```bash
mkdir devops-git-practice
cd devops-git-practice
```

---

## Initialize Git Repository

```bash
git init
```

### Output

```bash
Initialized empty Git repository
```

---

## Check Repository Status

```bash
git status
```

### Observation

- Git shows untracked files
- Current branch is `main` or `master`

---

## Explore .git Directory

```bash
ls -la .git
```

### Observation

- `.git` stores all repository history, commits, and configurations

---

# Task 3: Git Commands Reference

## Create File and add contents

```bash
vim git-commands.md
```


---

# Task 4: Stage and Commit

## Stage Files

```bash
git add git-commands.md
```

---

## Check Staged Files

```bash
git status
```

---

## Commit Changes

```bash
git commit -m "Added git commands reference"
```

---

## View Commit History

```bash
git log
```

---

# Task 5: Build Commit History

## Edit File and Add More Commands

```bash
vim git-commands.md
```

---

## Check Changes

```bash
git diff
```

---

## Stage and Commit Again

```bash
git add .
git commit -m "Updated git commands notes"
```

---

## Repeat Multiple Times

Example commits:

```bash
git commit -m "Added workflow commands"
git commit -m "Updated viewing changes section"
git commit -m "Improved git notes"
```

---

## View Compact History

```bash
git log --oneline
```

### Example Output

```bash
f3a1b2c Improved git notes
a8d2f11 Updated viewing changes section
c9e2a44 Added workflow commands
b2f7d12 Initial commit
```

---

# Task 6: Understanding Git Workflow

## 1. Difference Between git add and git commit

- `git add` moves changes to the staging area.
- `git commit` saves staged changes into repository history.

---

## 2. What Does Staging Area Do?

- Staging area allows selecting specific changes before committing.
- It helps organize commits cleanly instead of committing everything directly.

---

## 3. What Does git log Show?

- Commit IDs
- Author name
- Commit date
- Commit messages

---

## 4. What is .git Folder?

- `.git` stores all repository data and commit history.
- Deleting it removes Git tracking completely.

---

## 5. Working Directory vs Staging Area vs Repository

Working Directory -> Current files being edited 
Staging Area -> Files prepared for commit 
Repository -> Permanent Git commit history 

---

# What I Learned
- Git helps track file changes and maintain project history.
- The staging area allows better control before committing changes.
- Commands like `git status`, `git add`, and `git log` are essential for daily Git workflows.
