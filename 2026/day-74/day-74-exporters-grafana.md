# Day 74 – Exporters & Grafana

## `docker-compose.yml`
```yaml
version: "3.9"
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports: ["9090:9090"]

  grafana:
    image: grafana/grafana
    ports: ["3000:3000"]
    volumes:
      - ./provisioning:/etc/grafana/provisioning

  node-exporter:
    image: prom/node-exporter
    ports: ["9100:9100"]
    pid: host
    volumes:
      - /:/host:ro,rslave
    command:
      - --path.rootfs=/host

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports: ["8080:8080"]
    privileged: true
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker:/var/lib/docker:ro
```

## `prometheus.yml`
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["prometheus:9090"]

  - job_name: node
    static_configs:
      - targets: ["node-exporter:9100"]

  - job_name: cadvisor
    static_configs:
      - targets: ["cadvisor:8080"]
```

## Node Exporter vs cAdvisor

| Feature | Node Exporter | cAdvisor |
|---|---|---|
| Scope | Host OS metrics | Container metrics |
| Use for | CPU, RAM, disks, network, filesystem | CPU, memory, filesystem, network per container |
| Best when | Monitoring servers/VMs | Monitoring Docker/Kubernetes containers |

Use Node Exporter for infrastructure health. Use cAdvisor for container-level visibility. They are commonly deployed together.

## Useful PromQL

```promql
# CPU usage (%)
100 - (avg by(instance)(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage (%)
100 * (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)

# Disk usage (%)
100 * (1 - node_filesystem_avail_bytes{fstype!=""} / node_filesystem_size_bytes{fstype!=""})

# Container CPU
rate(container_cpu_usage_seconds_total[5m])

# Container memory
container_memory_usage_bytes

# Container filesystem
container_fs_usage_bytes
```

## Grafana datasource provisioning (YAML)

Grafana automatically loads YAML files placed under
`/etc/grafana/provisioning/datasources`.

Example:

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
```
