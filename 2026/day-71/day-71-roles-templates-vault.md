# 1. Webserver Role Directory Structure

```
roles/
└── webserver/
    ├── defaults/
    │   └── main.yml
    ├── files/
    ├── handlers/
    │   └── main.yml
    ├── meta/
    │   └── main.yml
    ├── tasks/
    │   └── main.yml
    ├── templates/
    │   └── index.html.j2
    ├── vars/
    │   └── main.yml
    └── README.md
```

### Purpose of Each Directory

| Directory | Purpose |
|------------|----------|
| tasks | Main automation tasks |
| handlers | Restart/reload services |
| templates | Jinja2 template files |
| files | Static files |
| vars | High-priority variables |
| defaults | Default variables |
| meta | Role metadata and dependencies |

---

# 2. Jinja2 Template Created

## Template: templates/index.html.j2

```html
<!DOCTYPE html>
<html>
<head>
    <title>{{ website_title }}</title>
</head>
<body>

<h1>{{ heading }}</h1>

<p>Server Name : {{ ansible_hostname }}</p>
<p>Operating System : {{ ansible_distribution }}</p>
<p>IP Address : {{ ansible_default_ipv4.address }}</p>

</body>
</html>
```

---

## Variables Used

```yaml
website_title: DevOps Demo
heading: Welcome to My Web Server
```

---

## Rendered Output

```html
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Demo</title>
</head>
<body>

<h1>Welcome to My Web Server</h1>

<p>Server Name : ubuntu-server</p>
<p>Operating System : Ubuntu</p>
<p>IP Address : 192.168.1.20</p>

</body>
</html>
```

The variables were automatically replaced with values collected from the managed host using Ansible facts.

---

# 3. Installing and Using an Ansible Galaxy Role

## Install Role

```bash
ansible-galaxy role install geerlingguy.nginx
```

Output:

```
Starting galaxy role install process
- downloading role 'nginx', owned by geerlingguy
- extracting geerlingguy.nginx
- installed successfully
```

---

## Use the Role

```yaml
---
- hosts: webservers
  become: yes

  roles:
    - geerlingguy.nginx
```

Execute:

```bash
ansible-playbook nginx.yml
```

The Galaxy role automatically installed and configured the Nginx web server.

---

# 4. Ansible Vault Workflow

## Create Encrypted File

```bash
ansible-vault create secrets.yml
```

---

## Edit Encrypted File

```bash
ansible-vault edit secrets.yml
```

---

## View Contents

```bash
ansible-vault view secrets.yml
```

---

## Encrypt Existing File

```bash
ansible-vault encrypt secrets.yml
```

---

## Decrypt File

```bash
ansible-vault decrypt secrets.yml
```

---

## Run Playbook Using Vault

```bash
ansible-playbook site.yml --ask-vault-pass
```

or

```bash
ansible-playbook site.yml --vault-password-file vault_pass.txt
```

Vault keeps passwords, API keys, SSH credentials, and other sensitive data encrypted and secure.

---

# 5. Roles vs Playbooks vs Ad-hoc Commands

| Feature | Roles | Playbooks | Ad-hoc Commands |
|----------|-------|-----------|-----------------|
| Purpose | Reusable automation modules | Execute automation workflows | Run one-time commands |
| Reusability | High | Medium | None |
| Best For | Large projects | Complete deployments | Quick tasks |
| Structure | Organized directory | YAML file | Single command |
| Variables | Supported | Supported | Limited |
| Handlers | Supported | Supported | Not Supported |
| Templates | Supported | Supported | Not Supported |
| Version Control | Easy | Easy | Difficult |

### When to Use Each

**Roles**
- Large infrastructure
- Reusable configurations
- Team projects
- Production deployments

**Playbooks**
- Deploy applications
- Provision servers
- Configure infrastructure
- Execute multiple tasks in order

**Ad-hoc Commands**
- Check server status
- Restart a service
- Copy a file
- Install a package quickly
- Gather information from hosts

