# Day 73 – Observability with Prometheus

## The Three Pillars of Observability

Observability helps us understand what is happening inside a system without directly inspecting its code. It is built on three main pillars:

### 1. Metrics

Metrics are numerical values collected over time that describe the health and performance of a system. They are lightweight, easy to aggregate, and ideal for dashboards and alerting.

Examples:

* CPU usage
* Memory consumption
* HTTP request count
* Request latency

### 2. Logs

Logs are timestamped records of events that occur within an application. They provide detailed information for debugging and understanding failures.

Examples:

* User login events
* Application errors
* Database connection failures
* Startup and shutdown messages

### 3. Traces

Traces show the complete journey of a request as it travels through multiple services. They help identify where delays or failures occur in distributed systems.

Examples:

* API Gateway → User Service → Database
* Checkout Service → Payment Service → Inventory Service

Together, metrics answer **"What is happening?"**, logs answer **"What happened?"**, and traces answer **"Where did it happen?"**.

---

# `prometheus.yml`

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets:
          - localhost:9090
```

---

# `docker-compose.yml`

```yaml
version: "3.8"

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

---

# Five PromQL Queries

## 1. `up`

**Purpose:**
Checks whether each scrape target is reachable.

**Returned:**

```
prometheus = 1
```

Meaning:

* `1` → Target is healthy.
* `0` → Target is unreachable.

---

## 2. `prometheus_build_info`

**Purpose:**
Shows Prometheus version and build metadata.

**Returned:**

```
version="2.x.x"
branch="main"
go_version="go1.xx"
```

---

## 3. `process_cpu_seconds_total`

**Purpose:**
Displays the total CPU time consumed by the Prometheus process.

**Returned:**

A steadily increasing counter representing cumulative CPU seconds.

---

## 4. `process_resident_memory_bytes`

**Purpose:**
Displays the amount of RAM currently used by Prometheus.

**Returned:**

A value in bytes, for example:

```
8.7e+07
```

(Approximately 87 MB.)

---

## 5. `prometheus_tsdb_head_series`

**Purpose:**
Shows how many active time series are currently stored in memory.

**Returned:**

An integer representing the number of active series being tracked.

---

# Counter vs Gauge

## Counter

A counter only increases over time (except when it resets after a restart).

Use counters for things that accumulate.

Examples:

* Total HTTP requests
* Total errors
* Total processed messages

Example metric:

```
http_requests_total
```

Typical query:

```promql
rate(http_requests_total[5m])
```

---

## Gauge

A gauge can increase or decrease at any time.

Use gauges for measurements that represent the current state.

Examples:

* Memory usage
* CPU utilization
* Number of connected users
* Queue length
* Temperature

Example metric:

```
process_resident_memory_bytes
```

---

### Summary

| Counter                  | Gauge                     |
| ------------------------ | ------------------------- |
| Only increases           | Can increase or decrease  |
| Represents totals        | Represents current values |
| Best used with `rate()`  | Read directly             |
| Example: requests served | Example: memory usage     |

---

# Architecture (Days 73–77)

```text
                    +--------------------+
                    |    Web Browser     |
                    +---------+----------+
                              |
                              v
                    +--------------------+
                    |     Grafana        |
                    | Dashboards         |
                    +---------+----------+
                              |
                              | PromQL
                              v
                    +--------------------+
                    |    Prometheus      |
                    | Metrics Storage    |
                    +---------+----------+
                              |
                  Scrapes Metrics Every 15s
                              |
      +-----------+-----------+-----------+
      |           |                       |
      v           v                       v
+-------------+ +-------------+ +----------------+
| Sample App  | | Node Exporter| | cAdvisor       |
| (/metrics)  | | Host Metrics | | Docker Metrics |

