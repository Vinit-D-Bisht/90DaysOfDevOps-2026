## 1. group_vars/ and host_vars/ Directory Structure

```
ansible/
│── inventory.ini
│── server-report.yml
│── group_vars/
│   ├── all.yml
│   └── webservers.yml
│
│── host_vars/
│   ├── server1.yml
│   └── server2.yml
```

### group_vars/all.yml

```yaml
company: DevOpsLab
timezone: Asia/Kolkata
package_name: git
```

### group_vars/webservers.yml

```yaml
http_port: 80
web_package: nginx
```

### host_vars/server1.yml

```yaml
server_role: Production
owner: Admin
```

### host_vars/server2.yml

```yaml
server_role: Testing
owner: Developer
```

---

# 2. Variable Precedence

Ansible uses variable precedence to determine which variable value is used when the same variable is defined in multiple places.

Example:

### group_vars/all.yml

```yaml
package_name: git
```

### group_vars/webservers.yml

```yaml
package_name: nginx
```

### host_vars/server1.yml

```yaml
package_name: apache2
```

### Playbook Variable

```yaml
vars:
  package_name: docker
```

If the playbook is executed on **server1**, the final value will be:

```
package_name = docker
```

because playbook variables have higher precedence than inventory variables.

Without the playbook variable:

```
package_name = apache2
```

because **host_vars** override **group_vars**.

Precedence (highest to lowest):

1. Extra variables (-e)
2. Task variables
3. Play variables
4. Host variables
5. Group variables
6. Role defaults

---

# 3. Five Useful Ansible Facts

### 1. ansible_distribution

Example:

```yaml
{{ ansible_distribution }}
```

Use:
Identify the operating system (Ubuntu, CentOS, Debian, etc.).

---

### 2. ansible_distribution_version

Example:

```yaml
{{ ansible_distribution_version }}
```

Use:
Run different tasks based on OS version.

---

### 3. ansible_default_ipv4.address

Example:

```yaml
{{ ansible_default_ipv4.address }}
```

Use:
Display or configure the server's primary IP address.

---

### 4. ansible_memtotal_mb

Example:

```yaml
{{ ansible_memtotal_mb }}
```

Use:
Check total RAM available on the server.

---

### 5. ansible_hostname

Example:

```yaml
{{ ansible_hostname }}
```

Use:
Identify the hostname during deployments and reporting.

---

# 4. Server Report Output

Playbook:

```bash
ansible-playbook -i inventory.ini server-report.yml
```

output:

```
TASK [Generate report] ************************************************

ok: [server1] => {
    "msg": [
        "========== server1 ==========",
        "OS: Ubuntu 24.04",
        "IP: 192.168.1.101",
        "RAM: 3916MB",
        "Disk: /dev/sda1        25G  8.1G  16G  35% /",
        "Running services (first 20): 20"
    ]
}

ok: [server2] => {
    "msg": [
        "========== server2 ==========",
        "OS: Ubuntu 24.04",
        "IP: 192.168.1.102",
        "RAM: 3916MB",
        "Disk: /dev/sda1        25G  7.8G  17G  33% /",
        "Running services (first 20): 20"
    ]
}
```

---

# 5. Report File Verification

Verified the generated report using:

```bash
ssh ubuntu@server1
```

```bash
cat /tmp/server-report-server1.txt
```

```
Server: server1
OS: Ubuntu 24.04
IP: 192.168.1.101
RAM: 3916MB
Disk:
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        25G  8.1G   16G  35% /

```

The report contained the correct hostname, operating system, IP address, RAM information, disk usage, and timestamp, 
confirming that the playbook executed successfully and generated accurate server reports.
