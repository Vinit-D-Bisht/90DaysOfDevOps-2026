## Project Directory Structure

```text
ansible-project/
├── inventory/
│   └── hosts.ini
├── group_vars/
│   └── all.yml
├── host_vars/
├── roles/
│   ├── docker/
│   │   └── tasks/
│   │       └── main.yml
│   ├── app/
│   │   └── tasks/
│   │       └── main.yml
│   └── nginx/
│       ├── tasks/
│       │   └── main.yml
│       └── templates/
│           └── nginx.conf.j2
├── site.yml
├── vault.yml
└── ansible.cfg
```

## `site.yml`

```yaml
---
- hosts: web
  become: true

  roles:
    - { role: docker, tags: ["docker"] }
    - { role: app, tags: ["app"] }
    - { role: nginx, tags: ["nginx"] }
```

## `roles/docker/tasks/main.yml`

```yaml
---
- name: Install Docker
  package:
    name: docker
    state: present

- name: Start Docker
  service:
    name: docker
    state: started
    enabled: true

- name: Login to Docker Hub
  community.docker.docker_login:
    username: "{{ dockerhub_username }}"
    password: "{{ dockerhub_password }}"
```

## `roles/app/tasks/main.yml`

```yaml
---
- name: Pull application image
  community.docker.docker_image:
    name: "{{ app_image }}"
    source: pull

- name: Run application container
  community.docker.docker_container:
    name: app
    image: "{{ app_image }}"
    state: started
    restart_policy: always
    published_ports:
      - "8080:8080"
```

## `roles/nginx/tasks/main.yml`

```yaml
---
- name: Install Nginx
  package:
    name: nginx
    state: present

- name: Deploy reverse proxy configuration
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/conf.d/default.conf
  notify: restart nginx

- name: Start Nginx
  service:
    name: nginx
    state: started
    enabled: true
```

## Nginx Reverse Proxy Template (`templates/nginx.conf.j2`)

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Selective Deployment with Tags

```bash
ansible-playbook site.yml --tags docker
ansible-playbook site.yml --tags app
ansible-playbook site.yml --tags nginx
ansible-playbook site.yml --tags "docker,app"
```

Tags allow deploying or updating only the required components without running the entire playbook.

## Protecting Docker Hub Credentials with Vault

Sensitive variables were stored in `vault.yml`:

```yaml
dockerhub_username: your_username
dockerhub_password: your_password
```

Encrypt the file:

```bash
ansible-vault encrypt vault.yml
```

Run the playbook:

```bash
ansible-playbook site.yml --ask-vault-pass
```

This keeps Docker Hub credentials encrypted at rest while making them available only during playbook execution.

## Architecture
```text
Ansible Control Node
        |
        | SSH / Ansible Playbook
        v
Target Linux Server
        |
        v
Nginx (Port 80)
        |
        | Reverse Proxy
        v
Docker Container (Port 8080)
        |
        v
Web Application
```
