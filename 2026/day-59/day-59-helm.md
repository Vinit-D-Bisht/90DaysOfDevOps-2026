# Day 59 – Helm Package Manager

## Objectives Completed

### 1. Installed Helm and Deployed a Bitnami Chart

* Installed Helm on the Kubernetes environment.
* Added the Bitnami chart repository:

  ```bash
  helm repo add bitnami https://charts.bitnami.com/bitnami
  helm repo update
  ```
* Deployed a sample application using a Bitnami chart:

  ```bash
  helm install my-nginx bitnami/nginx
  ```
* Verified the release and associated Kubernetes resources.

### 2. Customized, Upgraded, and Rolled Back a Release

* Customized deployment values using a custom `values.yaml` file.
* Upgraded the release with updated configuration:

  ```bash
  helm upgrade my-nginx bitnami/nginx -f values.yaml
  ```
* Checked release history:

  ```bash
  helm history my-nginx
  ```
* Performed a rollback to a previous revision:

  ```bash
  helm rollback my-nginx 1
  ```
* Verified that the application returned to the expected state after rollback.

### 3. Created and Installed a Custom Helm Chart

* Generated a new Helm chart:

  ```bash
  helm create my-chart
  ```
* Modified chart templates and values according to application requirements.
* Validated chart structure and templates:

  ```bash
  helm lint my-chart
  ```
* Installed the custom chart:

  ```bash
  helm install custom-app ./my-chart
  ```
* Confirmed successful deployment in the Kubernetes cluster.

