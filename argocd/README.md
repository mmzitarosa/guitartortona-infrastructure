# ArgoCD

GitOps deployment controller.

## Installazione

ArgoCD è già installato nel cluster.

## Accesso
```bash
# URL
https://argocd.guitar.lab

# Credenziali
Username: admin
Password: (saved in ~/argocd-credentials.txt)
```

## Applications

Definizioni ArgoCD Applications in `argocd/applications/`:

- `infrastructure.yaml` - Questo repository stesso (bootstrap)
- `api-staging.yaml` - Guitar Tortona API staging
- `api-production.yaml` - Guitar Tortona API production

## Applicare Applications
```bash
kubectl apply -f argocd/applications/
```
