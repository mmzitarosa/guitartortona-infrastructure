# HashiCorp Vault

Secret management per Guitar Tortona.

## Setup Iniziale

Dopo il primo deploy:
```bash
# 1. Inizializza Vault
kubectl exec -it vault-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1

# SALVA L'OUTPUT (unseal key e root token)!

# 2. Unseal Vault
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY>

# 3. Login
kubectl exec -it vault-0 -n vault -- vault login <ROOT_TOKEN>

# 4. Abilita KV engine v2
kubectl exec -it vault-0 -n vault -- vault secrets enable -version=2 -path=secret kv
```

## Struttura Secrets
```
secret/
└── guitartortona/
    ├── mariadb/
    │   ├── root_password
    │   ├── production/
    │   │   ├── username
    │   │   └── password
    │   └── staging/
    │       ├── username
    │       └── password
    ├── staging/
    │   └── ghcr/
    │       ├── username
    │       └── password
    └── production/
        └── ghcr/
            ├── username
            └── password
```

## Accesso UI
```bash
kubectl port-forward -n vault svc/vault 8200:8200
# Apri http://localhost:8200
```

## Unseal dopo riavvio

Vault va unsealed manualmente dopo ogni riavvio:
```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY>
```
