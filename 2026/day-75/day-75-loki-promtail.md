# Day 75 - Centralized Logging with Loki & Promtail

## Objective

Today I integrated centralized logging into my observability stack using **Loki** and **Promtail**. The goal was to collect logs from Docker containers, store them in Loki, and visualize them in Grafana alongside Prometheus metrics.

---

# Architecture

```text
                    +--------------------+
                    |  Docker Containers |
                    |--------------------|
                    | Notes App          |
                    | Prometheus         |
                    | cAdvisor           |
                    | Node Exporter      |
                    +---------+----------+
                              |
                              | Docker log files
                              |
                       +------+------+
                       |   Promtail  |
                       | Log Collector|
                       +------+------+
                              |
                              | Push Logs
                              |
                       +------+------+
                       |     Loki    |
                       | Log Storage |
                       +------+------+
                              |
          +-------------------+------------------+
          |                                      |
          |                                      |
+---------v----------+                 +---------v----------+
|     Prometheus     |                 |      Grafana       |
| Metrics Collection |---------------> | Metrics + Logs     |
+--------------------+                 +--------------------+
```

---

# Loki Configuration (`loki-config.yml`)

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

common:
  path_prefix: /loki

storage_config:
  filesystem:
    directory: /loki/chunks

schema_config:
  configs:
    - from: 2024-01-01
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

limits_config:
  allow_structured_metadata: false

ruler:
  alertmanager_url: http://localhost:9093
```

### Explanation

- **auth_enabled** disables authentication for local development.
- **server** exposes Loki on port **3100**.
- **storage_config** stores logs locally.
- **schema_config** defines how Loki indexes log data.
- **limits_config** keeps the configuration simple for development.

---

# Promtail Configuration (`promtail-config.yml`)

```yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker
    static_configs:
      - targets:
          - localhost
        labels:
          job: docker
          __path__: /var/lib/docker/containers/*/*-json.log
```

### Explanation

- **clients** sends logs to Loki.
- **positions** remembers the last log line read.
- **scrape_configs** tells Promtail where Docker stores container logs.
- The `job` label is used later while querying logs inside Grafana.

---

# Updated Docker Compose

```yaml
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana-enterprise
    ports:
      - "3000:3000"

  loki:
    image: grafana/loki
    ports:
      - "3100:3100"

  promtail:
    image: grafana/promtail

  cadvisor:
    image: gcr.io/cadvisor/cadvisor
    ports:
      - "8081:8080"

  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"

  notes-app:
    image: trainwithshubham/notes-app
    ports:
      - "8000:8000"
```

---

# LogQL Queries

### 1. View all Docker logs

```logql
{job="docker"}
```

**Result:** Displayed logs from all monitored Docker containers.

---

### 2. Search logs for my Notes App container

```logql
{job="docker"} |= "<notes-app-container-id>"
```

**Result:** Displayed logs only from the Notes App container.

---

### 3. Search for health logs

```logql
{job="docker"} |= "health"
```

**Result:** Returned log entries containing the word **health**.

---

### 4. Search for error logs

```logql
{job="docker"} |= "error"
```

**Result:** No error logs were generated during testing.

---

### 5. Search for HTTP requests

```logql
{job="docker"} |= "GET"
```

**Result:** Displayed HTTP request logs generated while accessing the application.

---

# Metrics and Logs Correlation

Using Grafana Explore split view:

**Left Panel (Prometheus)**

```promql
rate(container_cpu_usage_seconds_total{name="notes-app"}[5m])
```

**Right Panel (Loki)**

```logql
{job="docker"} |= "<notes-app-container-id>"
```

This allowed me to observe CPU usage and application logs simultaneously, making it easier to correlate performance spikes with application activity.

---

# Screenshot

**Insert your Grafana screenshot here showing:**

- Prometheus metrics on the left
- Loki logs on the right

Example:

```
docs/images/day75-metrics-logs.png
```

---

# Loki vs ELK Stack

| Loki | ELK Stack |
|------|-----------|
| Stores only log metadata (labels), making it lightweight. | Indexes the full log content, requiring more storage. |
| Easy integration with Grafana. | Uses Kibana for visualization. |
| Lower infrastructure and storage costs. | Higher resource usage but more powerful search capabilities. |
| Best suited for Kubernetes and cloud-native workloads. | Better for enterprise log analytics and complex searches. |

### When would I use each?

**Loki**
- Kubernetes environments
- Docker-based applications
- Small to medium-sized deployments
- Teams already using Grafana

**ELK Stack**
- Large enterprises
- Advanced full-text log searches
- Security analysis and SIEM use cases
- Long-term log retention and analytics

---

# Conclusion

Today I successfully integrated Loki and Promtail into my observability stack. I configured centralized log collection, visualized logs in Grafana, and correlated application logs with Prometheus metrics using Grafana Explore. This setup provides a unified view of both metrics and logs, making troubleshooting and monitoring much more effective.
