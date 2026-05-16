## Task 1: Understanding Branches

### 1. What is a branch in Git?
- A branch is an independent version of your code where you can work separately without affecting the main branch.

### 2. Why do we use branches instead of committing everything to `main`?
- Branches help developers work on features, fixes, or experiments safely without breaking the stable code in `main`.

### 3. What is `HEAD` in Git?
- `HEAD` is a pointer that shows the current branch or commit you are working on.

### 4. What happens to your files when you switch branches?
- Git updates your working directory files according to the selected branch.

---

# Task 2: Branching Commands – Hands-On

### Branches Created
- feature-1
- feature-2

### Observations
- Commits made on `feature-1` are not visible on `main`.
- `git switch` is mainly used for switching branches, while `git checkout` can also restore files.
- Unused branches can be deleted  after work is done..

---

# Task 3: Push to GitHub

### Observations
- Local repository was connected to GitHub successfully.
- `main` and `feature-1` branches were pushed to GitHub.
- Both branches became visible on GitHub after pushing.

### Difference between `origin` and `upstream`
- `origin` refers to your own GitHub repository.
- `upstream` refers to the original repository from which we forked.

---

# Task 4: Pull from GitHub

### Observations
- Changes made directly on GitHub were pulled successfully into the local repository.

### Difference between `git fetch` and `git pull`
- `git fetch` only downloads latest changes.
- `git pull` downloads and merges changes into the current branch.
---

# Task 5: Clone vs Fork

### Difference between clone and fork
- Clone creates a local copy of a repository.
- Fork creates a copy of someone else’s repository into your own GitHub.

### When to use clone vs fork
- Use clone when you already have access to the repository.
- Use fork when contributing to repositories owned by others.

### How to keep fork updated
- Add the original repository as `upstream`.
- Fetch and merge changes from the upstream repository regularly.

---

# What I Learned.
- Branches allow isolated development without affecting the main codebase.
- GitHub remotes like `origin` and `upstream` are important for collaboration workflows.
- Commands like fetch, pull, switch, clone, and fork are essential in daily Git usage.
