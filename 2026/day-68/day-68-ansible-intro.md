## Ansible architecture (in my own words)

Ansible follows a simple control model. A **Control Node** (my laptop or
a jump server) runs Ansible. It reads an **inventory** file to know
which **Managed Nodes** to connect to. Over SSH (or WinRM for Windows),
Ansible copies small **modules** to the managed nodes, executes them,
collects the results, and removes the temporary files. Automation is
described in **playbooks**, which are YAML files containing tasks to run
on selected hosts.

## Lab setup

I set up my lab using **Terraform** (or manually if applicable).

Example: - Control Node: Ubuntu machine with Ansible installed - Managed
Nodes: - EC2 Instance 1: Ubuntu 22.04 - EC2 Instance 2: Ubuntu 22.04 -
SSH key authentication enabled - Security Group allows SSH (port 22)
from my IP

## `inventory.ini`

``` ini
[web]
IP ansible_user=ubuntu

[db]
IP ansible_user=ubuntu

[all:vars]
ansible_ssh_private_key_file=~/.ssh/my-key.pem
```

## Five ad-hoc commands and outputs

### 1.
``` bash
ansible all -m ping
```

Output:
``` text
host1 | SUCCESS => {"ping":"pong"}
host2 | SUCCESS => {"ping":"pong"}
```

### 2.
``` bash
ansible all -m command -a "hostname"
```

Output:
``` text
host1 | CHANGED | rc=0 >> ip-10-0-0-10
host2 | CHANGED | rc=0 >> ip-10-0-0-11
```

### 3.
``` bash
ansible all -m command -a "uptime"
```

Output:
``` text
host1 | CHANGED | rc=0 >> 10:15 up 1 day...
```

### 4.
``` bash
ansible all -b -m apt -a "name=curl state=present"
```

Output:
``` text
host1 | CHANGED => curl installed
host2 | OK => curl already present
```

### 5.
``` bash
ansible all -m service -a "name=ssh state=started"
```

Output:
``` text
host1 | CHANGED => service started
host2 | OK => service already running
```

## Difference between `command` and `shell` modules
  `command`                           `shell`
  Executes a command directly without Executes the command through a
  a shell.                            shell (`/bin/sh`).

  Safer because shell metacharacters  Supports pipes (`|`), redirection
  are not interpreted.                (`>`), variables, globbing, and
                                      shell features.

  Preferred for simple commands.      Use only when shell functionality
                                      is required.

Example:

``` bash
ansible all -m command -a "ls /tmp"
```

``` bash
ansible all -m shell -a "ls /tmp | wc -l"
```

