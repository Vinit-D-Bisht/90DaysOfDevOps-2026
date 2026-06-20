## Metrics Server
- Metrics Server collects CPU and memory usage from Kubernetes nodes and pods.
- It provides resource metrics to the Kubernetes API.
- HPA needs Metrics Server because it uses these metrics to decide when to increase or decrease the number of pods.
- Without Metrics Server, HPA cannot monitor resource usage and will not work.

## How HPA Calculates Desired Replicas
HPA uses this formula:

Desired Replicas = Current Replicas × (Current Metric Value ÷ Target Metric Value)

Example:
- Current replicas = 2
- Current CPU usage = 80%
- Target CPU usage = 50%

Desired replicas = 2 × (80 ÷ 50) = 3.2

Kubernetes rounds up and scales to **4 pods**.

## autoscaling/v1 vs autoscaling/v2

### autoscaling/v1
- Supports CPU-based scaling only.
- Simpler configuration.
- Good for basic autoscaling needs.

### autoscaling/v2
- Supports CPU, memory, and custom/external metrics.
- More advanced scaling options.
- Recommended for production workloads.

Example:
- `autoscaling/v1` → Scale based on CPU only.
- `autoscaling/v2` → Scale based on CPU, memory, requests per second, queue length, etc.
