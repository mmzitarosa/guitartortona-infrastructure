# SecretStores

Configurazione SecretStore per ogni namespace che usa Vault.

## Token Vault

Ogni namespace che usa External Secrets deve avere un secret `vault-token`:
```bash
# Esempio per staging
kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n staging

# Esempio per production
kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n default

# Esempio per databases
kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n databases
```

## Verifica
```bash
kubectl get secretstore -A
```
