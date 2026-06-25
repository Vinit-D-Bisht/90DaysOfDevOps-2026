# Day 63 - Variables and Outputs

## Variable Precedence

When the same variable is defined in multiple places, Ansible uses the value with the highest precedence.

Example:

```yaml
# group_vars/all.yml
app_port: 8080
```

```yaml
# playbook.yml
vars:
  app_port: 9090
```

Result:

```yaml
app_port = 9090
```

The playbook variable overrides the group variable.

Common order (low → high):

1. Inventory variables
2. Group variables
3. Host variables
4. Playbook variables
5. Extra vars (`-e`)

---

## Five Useful Built-in Functions

### 1. default()

```yaml
{{ username | default('guest') }}
```

Returns a default value if the variable is not defined.

### 2. length

```yaml
{{ users | length }}
```

Returns the number of items.

### 3. upper

```yaml
{{ name | upper }}
```

Converts text to uppercase.

### 4. lower

```yaml
{{ name | lower }}
```

Converts text to lowercase.

### 5. join

```yaml
{{ servers | join(', ') }}
```

Combines list items into a string.

---

## Difference Between variable, local, output, and data

| Term         | Meaning                                                                       |
| ------------ | ----------------------------------------------------------------------------- |
| **variable** | Stores a value that can be reused in a playbook.                              |
| **local**    | Value or task limited to a specific host or scope.                            |
| **output**   | Information displayed after a task runs.                                      |
| **data**     | Raw information used by Ansible (facts, inventory values, API results, etc.). |

### Example

```yaml
vars:
  app_name: nginx

tasks:
  - debug:
      msg: "{{ app_name }}"
```

* `app_name` → variable
* `"nginx"` → data
* `msg` result shown on screen → output
* Host-specific values can be considered local to that host.

---

