# Helm chart installation
```bash
helm repo add traefik https://helm.traefik.io/traefik
helm install traefik traefik/traefik --namespace=om --values=chart-values.yaml
```

## In case of permissions to wide error (acme.json)
- Run ```kubectl exec deploy/traefik -- chmod 600 /data/acme.json```
- Uncomment lines on values on ```traefik-chart-values.yaml```
- Execute ```helm upgrade traefik traefik/traefik --namespace=traefik --values=traefik-chart-values.yaml```