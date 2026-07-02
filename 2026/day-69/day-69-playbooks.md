## First Playbook (Annotated)

``` yaml
- name: Install and start Nginx   # Play name
  hosts: web                      # Target inventory group
  become: true                    # Run with privilege escalation

  tasks:
    - name: Install nginx         # Task description
      apt:
        name: nginx
        state: present

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: true
```

### Section annotations

-   **name**: Human-readable description.
-   **hosts**: Target hosts or inventory group.
-   **become**: Runs tasks with elevated privileges.
-   **tasks**: Ordered list of actions.
-   **module block** (`apt`, `service`): The module being executed and
    its parameters.

## Seven Common Module Examples

1.  **ping** -- Tests Ansible connectivity.
2.  **command** -- Runs a command without a shell.
3.  **shell** -- Runs a command through a shell (supports pipes,
    redirects).
4.  **copy** -- Copies files from controller to managed hosts.
5.  **file** -- Creates, removes, or changes permissions/ownership of
    files and directories.
6.  **apt** -- Installs, removes, or updates packages on Debian/Ubuntu
    systems.
7.  **service** -- Starts, stops, restarts, or enables system services.

## Handlers: Before vs After

### Before (service restarts every run)

``` yaml
tasks:
  - copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf

  - service:
      name: nginx
      state: restarted
```

### After (restart only when configuration changes)

``` yaml
tasks:
  - copy:
      src: nginx.conf
      dest: /etc/nginx/nginx.conf
    notify: Restart nginx

handlers:
  - name: Restart nginx
    service:
      name: nginx
      state: restarted
```

**How handlers work:** A handler runs only when notified by a task that
reports a change, preventing unnecessary service restarts.

## `--check` vs `--diff` vs `-v`
  Option                              Purpose
  `--check`                           Dry run. Shows what would change without applying changes.
  `--diff`                            Shows line-by-line differences for supported file/template changes.
  `-v`                                Increases output verbosity for troubleshooting. Additional levels(`-vv`, `-vvv`, `-vvvv`) provide more detail.

