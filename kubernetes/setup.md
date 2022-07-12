# OM k8s Setup
## Previous Step
- Attach DigitalOcean Container Registry to current k8s cluster.

## Deploy with ArgoCD
- Cluster provisioning: ```doctl k8s cluster create --size=s-2vcpu-4gb-intel --region=ams3 <name> --1-clicks argocd```
- ArgoCD password: ```kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo```
- ArgoCD server port forward: ```kubectl port-forward svc/argocd-server -n argocd 8080:443```
- ArgoCD cli login: ```argocd login localhost:8080```
- Cloudflare credentials are not created by ArgoCD.
### Create required repositories
- Github: ssh://git@github.com/smartnexus/OrchestraManager
  ```
  argocd repo add ssh://git@github.com/smartnexus/OrchestraManager --ssh-private-key-path ~/.ssh/id_ed25519
  ```
- NFS-provider: https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/
  ```
  argocd repo add https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/ --type helm --name nfs-ganesha-server-and-external-provisioner
  ```
- Traefik: https://helm.traefik.io/traefik
  ```
  argocd repo add https://helm.traefik.io/traefik --type helm --name traefik
  ```
### Deploy aplications
- NFS: ```kubectl -n argocd apply -f templates/kubernetes/argocd/nfs-app.yaml```
- Volumes: ```kubectl -n argocd apply -f templates/kubernetes/argocd/values-app.yaml```
- MongoDB: ```kubectl -n argocd apply -f templates/kubernetes/argocd/mongodb-app.yaml```
- Traefik: 
  - ```kubectl apply -f templates/kubernetes/traefik/cloudflare-config.yaml``` 
  - ```kubectl -n argocd apply -f templates/kubernetes/argocd/traefik-app.yaml```
- Duplicati: ```kubectl -n argocd apply -f templates/kubernetes/argocd/duplicati-app.yaml```
- OM: ```kubectl -n argocd apply -f templates/kubernetes/argocd/om-app.yaml```


## Deploy with ```kubectl``` cmd
- Create "om" namespace
- Install nfs-provisioner helm chart
- Create Persistent volume claims
- Deploy mongodb svc and statefulset
- Init database with: ```docker run --rm -it -e WAIT_FOR=host.docker.internal:27017 -e RESTORE_ENV=yes -v $(pwd)/cluster/volumes/mongo/backup:/backup mongo-tools``` (first forward ports with ```kubectl port-forward```)
- Create cloudflare credentials config map
- Install traefik helm chart
- Create config map for backend deploy
- Attach do container registry to current cluster
- Change config map name and apply deployment
```bash
kubectl create namespace om
helm install nfs-provider nfs-ganesha-server-and-external-provisioner/nfs-server-provisioner --namespace=storage-provider --values=templates/kubernetes/shared-storage/chart-values.yaml
kubectl apply -f templates/kubernetes/shared-storage/volume-claims.yaml
kubectl apply -f templates/kubernetes/mongodb
kubectl port-forward svc/mongodb 27017
docker run --rm -it -e WAIT_FOR=host.docker.internal:27017 -e RESTORE_ENV=yes -v $(pwd)/cluster/volumes/mongo/backup:/backup mongo-tools
kubectl apply -f templates/kubernetes/traefik/cloudflare-config.yaml
helm install traefik traefik/traefik --namespace=om --values=templates/kubernetes/traefik/chart-values.yaml
kubectl apply -f templates/kubernetes/traefik/traefik-hpa.yaml
kubectl apply -f templates/vendor/registry.yaml
sudo kubectl -n storage-provider port-forward pod/nfs-provider-nfs-server-provisioner-0 2049 111 662 20048 32803 875
nfs://localhost/export/pvc-redis (finder)
copy dump.rdb
kubectl apply -k templates/kubernetes/om
```

# Mounting nfs volumes
- sudo kubectl port-forward pod/nfs-provider-nfs-server-provisioner-0 2049 111 662 20048 32803 875
- nfs://localhost/export/pvc-name (finder)

# Kube-prometheus-stack
- kubectl create namespace kube-prometheus-stack
- helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace=kube-prometheus-stack
- kubectl port-forward -n kube-prometheus-stack svc/kube-prometheus-stack-grafana 8080:80