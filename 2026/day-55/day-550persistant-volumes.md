# Day 55 – Persistent Volumes (PV) and Persistent Volume Claims (PVC)

### Why containers need persistent storage ?
Persistant storage helps the pods to retain data beyond its lifecycle. if a pod gets deleted or restarts the data remains intact and safe with help of persistant volumes. 

### What PVs and PVCs are and how they relate ?
A PersistentVolume (PV) is a Kubernetes resource that represents a piece of storage in a cluster.It can be created in a number of ways, including statically provisioning a volume, dynamically provisioning a volume, or importing an existing volume.
A PersistentVolumeClaim (PVC) is a Kubernetes resource that represents a request for storage by a pod. It can specify requirements for storage, such as the size, access mode, and storage class. Kubernetes uses the PVC to find an available PV that satisfies the PVC’s requirements.

### Static vs dynamic provisioning ?
**Static Provisioning:** An administrator manually creates a **PersistentVolume (PV)** first, and users create **PVCs** that bind to those existing PVs.
**Dynamic Provisioning:** Users create only a **PVC** with a **StorageClass**, and Kubernetes automatically creates the required PV.
**Static** is useful when you need preconfigured storage with specific settings.
**Dynamic** is preferred in most environments because it automates storage creation and management.


### Access modes and reclaim policies ?

Access modes define how a volume can be mounted by Pods:
ReadWriteOnce (RWO): Mounted as read-write by a single node.
ReadOnlyMany (ROX): Mounted as read-only by multiple nodes.
ReadWriteMany (RWX): Mounted as read-write by multiple nodes simultaneously.

Reclaim policies define what happens to a PV after its PVC is deleted:
Retain: Preserves the volume and data for manual recovery.
Delete: Removes the PV and the underlying storage automatically.
Recycle (deprecated): Deletes the data and makes the volume available for r

