## Architecture of the Deployment

```text
User
  |
NodePort Service
  |
WordPress Deployment (2 Pods)
  |
ConfigMap + Secret
  |
MySQL Headless Service
  |
MySQL StatefulSet
  |
PVC (Persistent Storage)
```

* WordPress uses a ConfigMap and Secret for database configuration.
* WordPress connects to MySQL through the Headless Service.
* MySQL stores data in a PVC so data survives pod restarts and deletions.

## Self-Healing and Persistence Test Results

| Test                   | Result                            |
| ---------------------- | --------------------------------- |
| Deleted WordPress Pod  | New pod was automatically created |
| Deleted MySQL Pod      | StatefulSet recreated the pod     |
| Checked WordPress Site | Site remained accessible          |
| Checked Blog Post      | Data remained available           |
| Checked Database       | Data persisted after restart      |

**Conclusion:**
The application recovered automatically after pod deletion and all data remained intact because of persistent storage.

## Concept Mapping

| Concept              | Day    |
| -------------------- | ------ |
| Kubernetes Basics    | Day 50 |
| Pods & Manifests     | Day 51 |
| Deployments          | Day 52 |
| Services             | Day 53 |
| ConfigMaps & Secrets | Day 54 |
| PV & PVC             | Day 55 |
| StatefulSets         | Day 56 |
| Resources & Probes   | Day 57 |
| HPA & Metrics Server | Day 58 |
| Helm                 | Day 59 |
| Capstone Project     | Day 60 |
