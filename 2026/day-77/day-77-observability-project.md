# Day 77 – Observability Stack Project

## Objective

Build a complete observability stack using Docker Compose to collect and visualize metrics, logs, and traces from a sample Notes application.

---

# Architecture Diagram

```text
                          ┌────────────────────┐
                          │    Notes App       │
                          │    (Port 8000)     │
                          └─────────┬──────────┘
                                    │
             ┌──────────────────────┼──────────────────────┐
             │                      │                      │
             │ Metrics              │ Logs                │ Traces
             ▼                      ▼                      ▼
     ┌──────────────┐      ┌────────────────┐      ┌────────────────────┐
     │ Prometheus   │      │ Promtail       │      │ OTEL Collector     │
     └──────┬───────┘      └──────┬─────────┘      └─────────┬──────────┘
            │                     │                          │
            │                     ▼                          │
            │               ┌───────────┐                   │
            │               │   Loki    │                   │
            │               └─────┬─────┘                   │
            │                     │                         │
            └──────────────┬──────┴──────────────┐          │
                           ▼                     ▼          ▼
                     ┌─────────────────────────────────────────┐
                     │              Grafana                    │
                     │ Dashboards (Metrics + Logs + Traces)    │
                     └─────────────────────────────────────────┘

Host Metrics
     │
     ▼
Node Exporter ─────────► Prometheus

Docker Metrics
     │
     ▼
cAdvisor ──────────────► Prometheus
```

---

# Services Used

| Service | Purpose |
|----------|---------|
| Notes App | Sample application |
| Prometheus | Metrics collection |
| Grafana | Dashboards & visualization |
| Loki | Log storage |
| Promtail | Log collection |
| OpenTelemetry Collector | Trace and telemetry collection |
| Node Exporter | Host metrics |
| cAdvisor | Docker container metrics |

---

# Comparison with Reference Repository

| Component | Reference Repo | My Project |
|------------|---------------|------------|
| Docker Compose | ✅ | ✅ |
| Prometheus | ✅ | ✅ |
| Grafana | ✅ | ✅ |
| Loki | ✅ | ✅ |
| Promtail | ✅ | ✅ |
| OpenTelemetry Collector | ✅ | ✅ |
| Node Exporter | ✅ | ✅ |
| cAdvisor | ✅ (container labels unavailable due to Docker 29 + cgroup v2) |
| Custom Dashboard | Basic | Built Production Overview dashboard |
| Logs | Working | Working |
| Metrics | Working | Working |
| Traces | Debug exporter | Debug exporter |

---

# Grafana Dashboard

Created dashboard:

**Production Overview – Observability Stack**

### Row 1 – System Health

- CPU Usage
- Memory Usage
- Disk Usage
- Targets Up

### Row 2 – Container Metrics

- Container CPU
- Container Memory
- Container Count

*(Container labels were unavailable with Docker Engine 29 + cgroup v2, so only host/container metrics could be visualized.)*

### Row 3 – Application Logs

- Notes App Logs
- Error Rate
- Log Volume

### Row 4 – Service Overview

- Prometheus Scrape Duration
- Targets Status
- Active Time Series
- Prometheus Target Health

---

# What I Would Add for Production

- Alertmanager for Slack, Teams, Email, and PagerDuty notifications.
- Grafana Tempo for distributed trace storage.
- TLS/HTTPS encryption for all services.
- Authentication and RBAC for Grafana, Prometheus, and Loki.
- Persistent storage using Docker volumes or Kubernetes Persistent Volumes.
- Log retention policies and storage limits.
- High Availability deployment with multiple Prometheus, Loki, and OTEL Collector replicas.
- Long-term metric storage using Thanos or Cortex.
- Backup and disaster recovery strategy.
- Kubernetes deployment with Helm charts.

---

# Key Takeaways from the 5-Day Observability Block

- Learned the three pillars of observability:
  - Metrics
  - Logs
  - Traces

- Built a complete observability stack using Docker Compose.

- Understood how Prometheus scrapes metrics from exporters.

- Configured Node Exporter for host monitoring.

- Used cAdvisor for Docker container monitoring.

- Collected logs with Promtail and stored them in Loki.

- Built custom Grafana dashboards using PromQL and LogQL.

- Configured OpenTelemetry Collector for telemetry pipelines.

- Learned Docker networking, service discovery, and monitoring architecture.

- Troubleshot real-world issues including Docker DNS, Prometheus scrape failures, and cAdvisor compatibility with Docker Engine 29.

---

# Configuration Files

Project includes the following configuration files:

```
docker-compose.yml
```

Contains all eight services:

- Notes App
- Prometheus
- Grafana
- Loki
- Promtail
- OpenTelemetry Collector
- Node Exporter
- cAdvisor

---

```
prometheus.yml
```

Responsible for:

- Prometheus scrape configuration
- Node Exporter scraping
- cAdvisor scraping
- Prometheus self-monitoring

---

```
loki-config.yml
```

Responsible for:

- Log storage
- Index configuration
- Retention
- Query configuration

---

```
promtail-config.yml
```

Responsible for:

- Docker log discovery
- Log scraping
- Label assignment
- Shipping logs to Loki

---

```
otel-collector-config.yml
```

Responsible for:

- OTLP receivers
- Metrics pipeline
- Trace pipeline
- Debug exporter
.
