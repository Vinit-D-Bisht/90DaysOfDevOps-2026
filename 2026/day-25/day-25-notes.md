# Task 1: Git Reset – Hands-On

## Observations

### `git reset --soft`
- Last commit was removed from history.
- Changes remained staged.

### `git reset --mixed`
- Last commit was removed.
- Changes remained unstaged in working directory.

### `git reset --hard`
- Last commit and changes were deleted completely.

---

## Answers

### Difference between `--soft`, `--mixed`, and `--hard`
- `--soft` keeps changes staged.
- `--mixed` keeps changes unstaged.
- `--hard` removes everything completely.

### Which one is destructive and why?
- `--hard` is destructive because it permanently deletes changes.

### When would you use each one?
- `--soft` → when recommitting changes quickly.
- `--mixed` → when modifying changes before staging again.
- `--hard` → when removing unwanted changes completely.

### Should you use reset on pushed commits?
- Avoid using reset on pushed/shared commits because it rewrites history.

---

# Task 2: Git Revert – Hands-On

## Observations
- Reverting commit `Y` created a new commit that undid its changes.
- Original commit still remained in history.

---

## Answers

### Difference between `git revert` and `git reset`
- `git reset` removes commits from history.
- `git revert` creates a new commit that reverses changes.

### Why is revert safer for shared branches?
- Revert does not rewrite commit history.

### When would you use revert vs reset?
- Use revert for shared branches.
- Use reset for local cleanup before pushing.

---

# Task 3: Reset vs Revert – Summary

|`git reset` | `git revert` |
|----------|-------------|
| Moves branch backward | Creates undo commit |
| Removes commit from history? | Yes | No |
| Safe for shared branches? | No | Yes |
| When to use | Local undo/cleanup | Safe undo on shared branches |

---

# Task 4: Branching Strategies

## 1. GitFlow

### How it works
- Uses `main`, `develop`, `feature`, `release`, and `other` branches.

### Flow

```text
main -> develop ->  feature branches -> release branch -> other branch
```

### Used in
- Large teams with scheduled releases.

 ### Pros
- Structured workflow
- Better release management

 ### Cons
- Complex for small teams

---

### 2. GitHub Flow

### How it works
- Uses a single `main` branch with short-lived feature branches.

### Flow
```text
main -> feature-1 ->  feature-2
```

### Used in
- Startups and fast deployments.

### Pros
- Simple and lightweight
- Fast collaboration

### Cons
- Less structured for large projects

---

## 3. Trunk-Based Development

### How it works
- Developers commit frequently to `main` using very short-lived branches.

### Flow

```text
main ─> short-lived branch ─> quick merge
```

### Used in
- Continuous integration and delivery environments.

### Pros
- Faster integration
- Fewer merge conflicts

### Cons
- Requires strong testing

---

# Answers

### Which strategy would you use for a startup shipping fast?                       
- GitHub Flow or Trunk-Based Development.

### Which strategy would you use for a large team with scheduled releases?

- GitFlow.

### Which strategy does a popular open-source project use?

- Many projects like React use GitHub Flow.

---
   
# What I Learned
- `git reset` rewrites history while `git revert` safely undoes changes.
- Different reset modes affect staged and working directory changes differently.
- Branching strategies help teams manage collaboration and releases effectively.
