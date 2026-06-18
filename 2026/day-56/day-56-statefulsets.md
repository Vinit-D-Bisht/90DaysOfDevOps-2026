# Day 56 – Kubernetes StatefulSets

# What StatefulSets are and when to use them vs Deployments
Statefulsets is a workload api that are used for pods that require stable networking and persistant data such as databases. whereas deployment are used for pods wich can be replaced by other
such as frontend pages.

# The comparison table

| feature          |  Statefulsets      |     Deplyments           |
| pod name         |  ordered (0,1,2)   | random (abc-xyz-efg)     |
| Startup order    |    Ordered         |    All at once           |
| scaling          |    Ordered         |    All at once           |
| Storage          |   Shared PVC       | Each pod ahs its own PVC |
| Network identity | No stable hostname | Stable DNS per pod       |

# How Headless Services, stable DNS, and volumeClaimTemplates work

When using a **StatefulSet**, Kubernetes creates a **Headless Service** to give each Pod its own stable DNS name (for example, `db-0.my-service`, `db-1.my-service`). This allows cluster members to find and communicate with specific Pods reliably. The **volumeClaimTemplates** section automatically creates a dedicated Persistent Volume Claim (PVC) for each Pod, ensuring that each Pod keeps its own data even if it is restarted or moved to another node. Together, stable DNS and persistent volumes make StatefulSets ideal for databases and distributed systems.
