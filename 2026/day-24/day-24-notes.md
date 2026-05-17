## Task 1: Git Merge – Hands-On

### Observations
- `feature-login` branch was created from `main`.
- Changes were merged successfully into `main`.
- First merge was a fast-forward merge because no new commits existed on `main`.

### Second Merge Observation
- `feature-signup` branch and `main` both had separate commits.
- Git created a merge commit while merging.
- A merge conflict can occur if the same line is modified in both branches.

### Answers

#### What is a fast-forward merge?
- A fast-forward merge happens when `main` has no new commits and Git simply moves the branch pointer forward.

#### When does Git create a merge commit?
- Git creates a merge commit when both branches contain different commit histories.

#### What is a merge conflict?
- A merge conflict happens when Git cannot automatically decide which changes to keep.

---

# Task 2: Git Rebase – Hands-On

### Observations
- `feature-dashboard` was rebased onto the updated `main`.
- Commit history became cleaner and linear compared to merge history.

### Answers

#### What does rebase actually do?
- Rebase moves feature branch commits on top of another branch’s latest commits.

#### How is history different from merge?
- Rebase creates a straight linear history while merge preserves branch history.

#### Why should you never rebase shared commits?
- Rebasing shared commits changes commit history and can create confusion or conflicts for other developers.

#### When would you use rebase vs merge?
- Use rebase for clean history before merging.
- Use merge when preserving original branch history is important.

---

# Task 3: Squash Commit vs Merge Commit

### Observations
- `feature-profile` branch commits were combined into a single commit using squash merge.
- `feature-settings` was merged normally and preserved all commits.

### Answers

#### What does squash merging do?
- Squash merge combines multiple commits into one single commit.

#### When would you use squash merge vs regular merge?
- Squash merge is useful for cleaning small unnecessary commits.
- Regular merge is useful when complete commit history should be preserved.

#### What is the trade-off of squashing?
- Commit history becomes cleaner but detailed commit information is lost.

---

# Task 4: Git Stash – Hands-On

### Observations
- Uncommitted work was temporarily saved using stash.
- Changes were restored successfully using stash pop.
- Multiple stashes were listed and specific stashes could be applied individually.

### Answers

#### Difference between `git stash pop` and `git stash apply`
- `git stash pop` applies and removes the stash.
- `git stash apply` applies the stash but keeps it saved.

#### When would you use stash in real workflow?
- Stash is useful when switching tasks quickly without committing incomplete work.

---

# Task 5: Cherry Picking

### Observations
- Only the selected commit from `feature-hotfix` was applied to `main`.
- Other commits from the branch were not copied.

### Answers

#### What does cherry-pick do?
- Cherry-pick copies a specific commit from one branch to another.

#### When would you use cherry-pick?
- It is useful for applying important fixes without merging the entire branch.

#### What can go wrong with cherry-picking?
- It may create duplicate commits or conflicts if related commits are missing.

---

# What I Learned

- Merge, rebase, and squash merging all manage Git history differently.
- Stash helps save temporary work during context switching.
- Cherry-pick is useful for selectively applying commits between branches.
