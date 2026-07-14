# Day 76 — OpenTelemetry and Alerting

## Overview

Today I extended the observability stack by adding the third pillar of observability — **distributed tracing** — using OpenTelemetry (OTEL).

The stack now covers:

* **Metrics** → Prometheus + Grafana
* **Logs** → Loki + Promtail + Grafana Explore
* **Traces** → OpenTelemetry Collector

I also configured alerting so the system can notify when problems occur instead of requiring manual dashboard monitoring.

---

# 1. OpenTelemetry Architecture

## What is OpenTelemetry?

OpenTelemetry (OTEL) is a vendor-neutral, open-source framework used to generate, collect, process, and export telemetry data.

It supports the three observability signals:

* Metrics
* Logs
* Traces

OpenTelemetry is not a monitoring backend. It does not store or visualize data.

Instead, it collects telemetry and sends it to backend systems such as:

* Prometheus
* Grafana Tempo
* Jaeger
* Loki
* Datadog

Architecture:

```
Application
    |
    |
OpenTelemetry SDK
    |
    |
OTLP Protocol
    |
    |
OpenTelemetry Collector
    |
    +------------+
    |            |
 Metrics      Traces
    |            |
Prometheus    Tempo/Jaeger
```

---

# 2. OpenTelemetry Collector

The OpenTelemetry Collector is a standalone service responsible for receiving, processing, and exporting telemetry.

The collector pipeline has three main components:

## Receivers

Receivers accept telemetry from different sources.

Examples:

* OTLP
* Prometheus
* Jaeger
* Zipkin

In this setup:

```
OTLP Receiver
    |
    +-- gRPC :4317
    |
    +-- HTTP :4318
```

---

## Processors

Processors modify or optimize telemetry before exporting.

Example:

```
batch processor
```

The batch processor groups telemetry together before sending it, reducing network overhead.

---

## Exporters

Exporters send telemetry to storage or visualization systems.

Configured exporters:

```
Metrics  → Prometheus exporter
Traces   → Debug exporter
Logs     → Debug exporter
```

---

# 3. OpenTelemetry Collector Configuration

File:

```
otel-collector/otel-collector-config.yml
```

Configuration:

```yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  batch:

exporters:
  prometheus:
    endpoint: "0.0.0.0:8889"

  debug:
    verbosity: detailed

service:
  pipelines:

    metrics:
      receivers:
        - otlp
      processors:
        - batch
      exporters:
        - prometheus

    traces:
      receivers:
        - otlp
      processors:
        - batch
      exporters:
        - debug

    logs:
      receivers:
        - otlp
      processors:
        - batch
      exporters:
        - debug
```

---

## Explanation

### Receivers

The collector accepts OTLP traffic:

```
OTLP gRPC → 4317
OTLP HTTP → 4318
```

---

### Processor

The batch processor improves performance:

```
Telemetry
    |
Batch processor
    |
Exporter
```

---

### Exporters

Metrics:

```
OTLP Metrics
      |
      |
OTEL Collector
      |
      |
Prometheus :8889
```

Traces:

```
OTLP Trace
      |
      |
OTEL Collector
      |
      |
Debug logs
```

---

# 4. Running OpenTelemetry Collector

Added service:

```yaml
otel-collector:
  image: otel/opentelemetry-collector-contrib:latest
  container_name: otel-collector

  ports:
    - "4317:4317"
    - "4318:4318"
    - "8889:8889"

  volumes:
    - ./otel-collector/otel-collector-config.yml:/etc/otelcol-contrib/config.yaml

  restart: unless-stopped
```

Start services:

```bash
docker compose up -d
```

Verify:

```bash
docker logs otel-collector
```

---

# 5. OTLP and Distributed Traces

## What is OTLP?

OTLP (OpenTelemetry Protocol) is the standard protocol used to transmit telemetry data.

Supported protocols:

| Protocol  | Port |
| --------- | ---- |
| OTLP gRPC | 4317 |
| OTLP HTTP | 4318 |

---

## Distributed Tracing

A trace represents one request moving through multiple services.

Example:

```
User Request

     |
     v

API Gateway
(span 1)

     |
     v

Authentication Service
(span 2)

     |
     v

Database
(span 3)
```

Each span contains:

* Trace ID
* Span ID
* Parent Span ID
* Start time
* End time
* Duration
* Attributes

---

# 6. Sending Test Trace

A sample OTLP trace was sent:

```bash
curl -X POST http://localhost:4318/v1/traces \
-H "Content-Type: application/json" \
-d '<trace payload>'
```

The collector received the trace and printed it using the debug exporter.

Verification:

```bash
docker logs otel-collector | grep test-span
```

Expected output:

```
test-span

trace_id:
5b8efff798038103d269b633813fc60c

service.name:
my-test-service
```

---

# 7. Sending OTLP Metrics

Metrics were sent through OTLP:

```
curl
 |
 |
OTLP HTTP
 |
 |
OTEL Collector
 |
 |
Prometheus exporter
 |
 |
Prometheus
```

Query in Prometheus:

```promql
test_requests_total
```

Result:

```
test_requests_total 42
```

---

# 8. Prometheus Alerting

Prometheus evaluates alert rules periodically and changes alert states:

```
Inactive
    |
    |
Condition becomes true
    |
    |
Pending
    |
(after "for" duration)
    |
    |
Firing
```

---

# Alert Rules

File:

```
alert-rules.yml
```

---

## High CPU Usage

```yaml
alert: HighCPUUsage
expr: 100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
for: 2m
```

Triggers when CPU usage stays above 80% for 2 minutes.

---

## High Memory Usage

```yaml
alert: HighMemoryUsage
expr: (1 - node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100 > 85
for: 2m
```

Triggers when memory usage exceeds 85%.

---

## Container Down

```yaml
alert: ContainerDown
expr: absent(container_last_seen{name="notes-app"})
for: 1m
```

Detects missing containers.

---

## Target Down

```yaml
alert: TargetDown
expr: up == 0
for: 1m
```

Detects unreachable Prometheus targets.

---

## High Disk Usage

```yaml
alert: HighDiskUsage
expr: (1 - node_filesystem_avail_bytes /
node_filesystem_size_bytes) * 100 > 90
for: 5m
```

Triggers when disk usage exceeds 90%.

---

# 9. Grafana Alerting

Grafana alerting was configured for notifications.

## Contact Point

Created:

```
Name:
DevOps Team

Type:
Email
```

SMTP was configured to allow Grafana to send alert notifications.

---

## Grafana Alert Rule

Created rule:

```
Name:
High Container Memory
```

Query:

```promql
container_memory_usage_bytes{name="notes-app"} / 1024 / 1024
```

Condition:

```
IS ABOVE 100 MB
```

Evaluation:

```
Every: 1 minute
For: 2 minutes
```

Label:

```
severity=warning
```

---

# Prometheus Alerts vs Grafana Alerts

## Prometheus Alerts

Advantages:

* Defined as code
* Stored with infrastructure configuration
* Good for infrastructure monitoring

Example:

```
CPU > 80%
Disk > 90%
Container down
```

---

## Grafana Alerts

Advantages:

* Easy UI management
* Multiple notification integrations
* Good dashboard-based alerting

Example:

```
Application latency
Business metrics
Dashboard queries
```

---

# 10. Complete Observability Architecture

```
                    METRICS

Node Exporter
      |
      |
cAdvisor
      |
      |
OTEL Collector :8889
      |
      |
Prometheus
      |
      |
Grafana Dashboards
      |
      |
Alert Notifications


                    LOGS

Docker Containers
        |
        |
     Promtail
        |
        |
       Loki
        |
        |
     Grafana Explore


                    TRACES

Application / curl
        |
        |
       OTLP
        |
        |
OTEL Collector
        |
        |
 Debug Exporter
        |
        |
Future:
Tempo / Jaeger
```

---

# 11. Final Stack

| Service        | Port           | Purpose              |
| -------------- | -------------- | -------------------- |
| Prometheus     | 9090           | Metrics storage      |
| Node Exporter  | 9100           | Host metrics         |
| cAdvisor       | 8081           | Container metrics    |
| Grafana        | 3000           | Dashboards + Alerts  |
| Loki           | 3100           | Log storage          |
| Promtail       | 9080           | Log collection       |
| OTEL Collector | 4317/4318/8889 | Telemetry collection |
| Notes App      | 8000           | Sample application   |

---

# 12. Verification

All services running:

```bash
docker compose ps
```

Expected:

```
prometheus       running
grafana          running
loki             running
promtail         running
node-exporter    running
cadvisor         running
otel-collector   running
notes-app        running
```

