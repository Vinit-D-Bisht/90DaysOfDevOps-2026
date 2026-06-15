# Day 53 – Kubernetes Services

### What problem Services solve and how they relate to Pods and Deployments ?
A *Pod* runs your application, and a *Deployment* makes sure the required number of Pods are always running. The problem is that Pods can be created, deleted, or restarted, so their IP addresses can change. A *Service* solves this by providing a stable address that always points to the correct Pods. Instead of connecting directly to Pods, users connect to the Service, which automatically finds the Pods managed by the Deployment and routes traffic to them.

### Your three Service manifests with an explanation of each type ?
1. clusterip-service.yaml: Exposes the application only inside the cluster. Used for communication between Pods and services.
2. nodeport-service.yaml: Exposes the application outside the cluster using a port on each node (NodeIP:NodePort).
3. loadbalancer-service.yaml: Exposes the application to the internet using an external load balancer, which distributes traffic to the Pods.

### The difference between ClusterIP, NodePort, and LoadBalancer ?

1. ClusterIP = Works inside the cluster only Helps  Internal communication between services
2.  NodePort = Works outside via `<NodeIP>:<NodePort>` Used for  Development, testing, direct node access
3. LoadBalancer = works outside via cloud load balancer helps Production traffic in cloud environments 


### How Kubernetes DNS works for service discovery ?
Kubernets makes DNS records so it can locate and communicate with DNS names instead of IP addresses.

### What Endpoints are and how to inspect them ?

Endpoints are resources that represent IP address and Ports of pod. they are automatically created and updated by k8s to ensure correct traffic routing .* kubectl endpoints* this command is used to inspect the endpoints.
