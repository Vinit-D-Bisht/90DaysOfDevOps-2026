# Day 49 – DevSecOps: Add Security to Your CI/CD Pipeline

## What DevSecOps Means (In My Own Words)

DevSecOps is the practice of integrating security into every stage of the CI/CD pipeline instead of treating it as a separate step at the end. By automating security checks such as vulnerability scanning, dependency reviews, and secret detection, teams can identify and fix issues early before they reach production. This helps improve application security while maintaining fast development and deployment cycles.

---

# Updated Secure CI/CD Pipeline

```text
Pull Request Opened -> Build & Test ->  Dependency Review, Scan for CVEs -> PR Checks Pass/Fail

Merge to main -> Build & Test -> Docker Build -> Trivy Security,Image Scan ->  Docker Push(Only if Scan Passes) -> Deploy to Production

Always Active Security -> GitHub Secret Scanning -> Push Protection for Secrets 
```

---

# What I Learned

## Secret Scanning

GitHub Secret Scanning automatically searches repositories for exposed credentials such as API keys, access tokens, passwords, and cloud secrets. If a secret is detected, GitHub alerts repository owners so it can be revoked and replaced quickly. This helps prevent accidental credential leaks.

## Push Protection

Push Protection works before code reaches the repository. If GitHub detects a supported secret during a push, it can block the push and warn the developer immediately. This reduces the risk of sensitive credentials being exposed in commit history.

## Dependency Review

The Dependency Review Action checks new dependencies added through Pull Requests and compares them against known vulnerability databases. If a dependency contains critical security vulnerabilities, the PR can fail automatically. This prevents insecure packages from being introduced into the project.

## Workflow Permissions

I learned that GitHub Actions workflows should follow the principle of least privilege. By limiting permissions such as:

```yaml
permissions:
  contents: read
```

workflows only receive the access they actually need. This reduces the impact of compromised actions or malicious workflow changes.

---

## Key Learnings

- Security should be integrated into the CI/CD pipeline from the beginning.
- Vulnerability scanning can automatically stop insecure Docker images from reaching production.
- Secret Scanning and Push Protection help prevent credential leaks.
- Dependency Review helps identify vulnerable packages before they are merged.
- Restricting workflow permissions improves pipeline security.
- DevSecOps focuses on automating security checks rather than relying on manual reviews.
