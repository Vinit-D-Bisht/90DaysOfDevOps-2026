# Day 52 – Kubernetes Namespaces and Deployments

### What namespaces are and why you would use them ?
Namespaces are mechanism for isolating group of resources in cluster. We use it for access control, structurin resources , sharing resource and preventing conflicts
 
### Your Deployment manifest and an explanation of each section ?
apiVersion : Specifies the version of resource we are using
kind : Type of resource
metadata : contains infor mation such as name, namespace it is in, labels etc
spec :defines specifications, selector-> how resources are gonna match, replicas(no. of pods)
template : it specifies the blueprint for pods
template-spec : defines container name and image tag with ports

### What happens when you delete a Pod managed by a Deployment vs a standalone Pod ?
if u delete a pod managed by deployment it recreates another one if its a part of replica set but if u delete a standalone it gets removed fully then u manually have to recreate it

### How scaling works (both imperative and declarative) ?
Imperative scaling means directly change the replicas using cli and commands
Declarative scaling means defining desired replicas in the config file so the cluster manages it automatically.

### How rolling updates and rollbacks work ?
Rolling updates means the pods are updated one after another replacing old ones with new with zero downtime
Rollbacks allows us to go to previous state of the cluster if update causes and issue
