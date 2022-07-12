# Helm chart installation
```bash
helm repo add nfs-ganesha-server-and-external-provisioner https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/
helm install nfs-provider nfs-ganesha-server-and-external-provisioner/nfs-server-provisioner --namespace=om --values=chart-values.yaml
```