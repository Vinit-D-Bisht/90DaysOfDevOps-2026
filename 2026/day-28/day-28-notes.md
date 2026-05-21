# Task 1: Self-Assessment Checklist

## Linux

- Navigate the file system, create/move/delete files and directories  
= Can do confidently

- Manage processes — list, kill, background/foreground  
= Can do confidently

- Work with systemd — start, stop, enable, check status of services  
= Can do confidently

- Read and edit text files using vi/vim or nano  
= Can do confidently

- Troubleshoot CPU, memory, and disk issues using top, free, df, du  
= Can do confidently

- Explain the Linux file system hierarchy  
= Need to revisit

- Create users and groups, manage passwords  
= Can do confidently

- Set file permissions using chmod  
= Can do confidently

- Change file ownership with chown and chgrp  
= Can do confidently

- Create and manage LVM volumes  
= Need to revisit

- Check network connectivity  
= Can do confidently

- Explain DNS resolution, IP addressing, subnets, and common ports  
= Need to revisit

---

## Shell Scripting

- Write a script with variables, arguments, and user input  
= Can do confidently

- Use if/elif/else and case statements  
= Can do confidently

- Write for, while, and until loops  
= Can do confidently

- Define and call functions with arguments and return values  
= Can do confidently

- Use grep, awk, sed, sort, uniq for text processing  
= Can do confidently

- Handle errors with set -e, set -u, set -o pipefail, trap  
= Can do confidently

- Schedule scripts with crontab  
= Can do confidently

---

## Git & GitHub

- Initialize a repo, stage, commit, and view history  
= Can do confidently

- Create and switch branches  
= Can do confidently

- Push to and pull from GitHub  
= Can do confidently

- Explain clone vs fork  
= Can do confidently

- Merge branches — understand fast-forward vs merge commit  
= Can do confidently

- Rebase a branch and explain when to use it vs merge  
= Can do confidently

- Use git stash and git stash pop  
= Can do confidently

- Cherry-pick a commit from another branch  
= Can do confidently

- Explain squash merge vs regular merge  
= Can do confidently

- Use git reset (soft, mixed, hard) and git revert  
= Can do confidently

- Explain GitFlow, GitHub Flow, and Trunk-Based Development  
= Can do confidently

- Use GitHub CLI to create repos, PRs, and issues  
= Can do confidently

---

# Task 2: Revisit Weak Spots

## 1. Linux File System Hierarchy

### Revisited
- `/etc` for configuration files
- `/var` for logs and variable data
- `/tmp` for temporary files
- `/home` for user directories
- `/bin` and `/sbin` for binaries

### Re-learned
Understanding Linux directories is important for troubleshooting and server administration.

---

## 2. LVM (Logical Volume Management)

### Revisited
- Physical Volumes (PV)
- Volume Groups (VG)
- Logical Volumes (LV)

### Re-learned
LVM allows flexible disk management and resizing without repartitioning the entire disk.

---

## 3. DNS, Subnets & Ports

### Revisited
- DNS resolution process
- Private vs Public IP addresses
- Common ports like 22, 80, 443
- Basics of subnetting

### Re-learned
Networking fundamentals are essential for troubleshooting connectivity and server communication.

---

# Task 3: Quick-Fire Questions

## 1. What does `chmod 755 script.sh` do?

It gives the owner read, write, and execute permissions while others get read and execute permissions.

---

## 2. What is the difference between a process and a service?

A process is a running program while a service is a background process managed by the system.

---

## 3. How do you find which process is using port 8080?

```bash
sudo lsof -i :8080
```

---

## 4. What does `set -euo pipefail` do in a shell script?

- `set -e` → exits on error
- `set -u` → treats unset variables as errors
- `set -o pipefail` → catches errors inside pipes

---

## 5. What is the difference between `git reset --hard` and `git revert`?

`git reset --hard` removes commits and changes completely while `git revert` creates a new commit that undoes previous changes safely.

---

## 6. What branching strategy would you recommend for a team of 5 developers shipping weekly?

GitHub Flow because it is simple and fast for small teams.

---

## 7. What does `git stash` do and when would you use it?

It temporarily saves uncommitted changes so work can be resumed later.

---

## 8. How do you schedule a script to run every day at 3 AM?

We can use cron jobs
```bash
0 3 * * * /path/to/script.sh
```

---

## 9. What is the difference between `git fetch` and `git pull`?

`git fetch` only downloads changes
`git pull` downloads and merges them.

---

## 10. What is LVM and why would you use it instead of regular partitions?

LVM is Logical Volume Management which provides flexible storage management and resizing compared to traditional partitions.

---

# Task 4: Organize Your Work

## Completed

- Verified all daily submissions from Day 1–27
- Updated `git-commands.md`
- Reviewed shell scripting cheat sheet
- Cleaned and organized GitHub profile and repositories

---

# Task 5: Teach It Back

## Explaining Git Branching

Git branches allow developers to work on different features without affecting the main project. Each branch acts like a separate workspace where changes can be made safely. Once the work is completed and tested, the branch can be merged back into the main branch. This helps teams work on multiple features at the same time without conflicts. Branching also makes experimentation safer because mistakes in one branch do not break the main codebase.

---

# Key Learnings

- Revision helps identify weak areas
- Linux fundamentals are critical for DevOps
- Git branching and version control are essential for collaboration
- Shell scripting improves automation skills
- Networking knowledge is important for troubleshooting

