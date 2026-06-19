# Day 57 — Resources and Probes (Short Notes)

## Requests vs Limits

* **Request** = Minimum resources needed by a container.

  * Used by the scheduler to place Pods on nodes.
* **Limit** = Maximum resources a container can use.

  * Enforced at runtime.

## When Limits Are Exceeded

### CPU Limit Exceeded

* Container is **throttled**.
* Keeps running but becomes slower.

### Memory Limit Exceeded

* Container is **OOMKilled**.
* Kubernetes may restart it.

## Kubernetes Probes

### Liveness Probe

* Checks if the app is healthy.
* Failure → Container is restarted.

### Readiness Probe

* Checks if the app can receive traffic.
* Failure → Pod is removed from Service endpoints.

### Startup Probe

* Checks if the app has finished starting.
* Prevents liveness checks during startup.
* Failure → Container is restarted.

## Quick Summary

* **Request = Scheduling**
* **Limit = Enforcement**
* **Liveness = Restart?**
* **Readiness = Receive traffic?**
* **Startup = Finished starting?**

