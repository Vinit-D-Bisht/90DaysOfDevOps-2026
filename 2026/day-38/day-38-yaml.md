## Task 1: Key-Value Pairs

### person.yaml

```yaml
name: Vinit Bisht
role: DevOps Learner
experience_years: 0
learning: true
```

---

## Task 2: Lists

### Updated person.yaml

```yaml
name: Vinit Bisht
role: DevOps Learner
experience_years: 0
learning: true

tools:
  - Linux
  - Git
  - GitHub
  - Docker
  - YAML

hobbies: [Coding, Gaming, Learning, Music, Reading]

```

### Answer

#### What are the two ways to write a list in YAML?

1. Block Style

```yaml
tools:
  - Docker
  - Git
  - Linux
                
```

2. Inline Style

```yaml
tools: [Docker, Git, Linux]
```

---

## Task 3: Nested Objects

### server.yaml

```yaml
server:
  name: web-server
  ip: 192.168.1.10
  port: 80

database:
  host: localhost
  name: appdb

  credentials:
    user: admin
    password: secret123
```

### Verification

Using tabs instead of spaces causes YAML validation errors because YAML only supports spaces for indentation.

---

## Task 4: Multi-line Strings

### Using Pipe (|)

```yaml
startup_script_pipe: |
  echo "Starting Server"
  docker compose up -d
  echo "Server Started"
```

### Using Greater Than (>)

```yaml
startup_script_fold: >
  echo "Starting Server"
  docker compose up -d
  echo "Server Started"
```

### Answer

#### When would you use | vs > ?

1. `|` preserves line breaks exactly as written.
2. `>` folds multiple lines into a single line.
3. Use `|` for scripts, configuration files, and commands.
4. Use `>` for long text paragraphs.

## Task 5: Validate Your YAML

### Validation Tool

```bash
yamllint person.yaml
yamllint server.yaml
```

### Broken Indentation Example

```yaml
server:
 name: web-server
 ip: 192.168.1.10
```

### Error

```text
mapping values are not allowed here
```

### Fix

Use consistent two-space indentation.

---

## Task 6: Spot the Difference

### Correct

```yaml
name: devops
tools:
  - docker
  - kubernetes
```

### Broken

```yaml
name: devops
tools:
    - docker
      - kubernetes
```

### What is wrong?
The list indentation is inconsistent. YAML relies on proper spacing and indentation to understand structure.

---

## Key Learnings

1. YAML uses spaces only and does not support tabs.
2. Indentation determines structure and hierarchy.
3. YAML supports key-value pairs, lists, nested objects, and multi-line strings.

