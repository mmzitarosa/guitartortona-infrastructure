# External Secrets Operator

Sincronizza automaticamente secrets da Vault a Kubernetes.

## Installazione

External Secrets Operator va installato via Helm:
```bash
helm repo add external-secrets https://charts.external-secrets.io
helm repo update

helm install external-secrets \
  external-secrets/external-secrets \
  -n external-secrets \
  --create-namespace
```

## Configurazione

Dopo l'installazione, creare i SecretStore nei vari namespace.
Vedi: `secrets/stores/`

## Verifica
```bash
# Verifica operator funzionante
kubectl get pods -n external-secrets

# Verifica ExternalSecrets
kubectl get externalsecrets -A

# Debug
kubectl describe externalsecret <name> -n <namespace>
```
