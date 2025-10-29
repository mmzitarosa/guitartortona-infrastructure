# 🎸 Guitar Tortona Infrastructure

GitOps repository per la gestione dell'infrastruttura Kubernetes di Guitar Tortona.

## 🏗️ Componenti

- **MariaDB** - Database condiviso per tutte le applicazioni
- **Vault** - Secret management (HashiCorp Vault)
- **External Secrets** - Sincronizzazione automatica secrets da Vault
- **Ingress NGINX** - Traffic management
- **Cert Manager** - Gestione certificati TLS automatica
- **Prometheus + Grafana** - Monitoring e observability
- **ArgoCD** - GitOps deployment controller

## 📂 Struttura
```
├── databases/mariadb/      # MariaDB StatefulSet
├── secrets/
│   ├── vault/              # Vault deployment
│   ├── external-secrets/   # External Secrets Operator
│   └── stores/             # SecretStores per namespace
├── ingress/                # NGINX Ingress (reference)
├── cert-manager/           # Cert Manager (reference)
├── monitoring/             # Prometheus/Grafana (Helm)
└── argocd/
    └── applications/       # ArgoCD Application definitions
```

## 🚀 Deploy

### Setup Iniziale

1. **Clone repository**
```bash
git clone https://github.com/mmzitarosa/guitartortona-infrastructure.git
cd guitartortona-infrastructure
```

2. **Applica infrastruttura base**
```bash
# Namespaces
kubectl apply -f databases/mariadb/namespace.yaml
kubectl apply -f secrets/vault/namespace.yaml
kubectl apply -f secrets/external-secrets/namespace.yaml

# Vault
kubectl apply -f secrets/vault/

# MariaDB
kubectl apply -f databases/mariadb/

# SecretStores
kubectl apply -f secrets/stores/

# ArgoCD Applications
kubectl apply -f argocd/applications/
```

3. **Inizializza Vault** (prima volta)
```bash
# Vedi: secrets/vault/README.md
kubectl exec -it vault-0 -n vault -- vault operator init -key-shares=1 -key-threshold=1
# SALVA unseal key e root token!
```

4. **Configura vault-token secrets**
```bash
# In ogni namespace che usa External Secrets
kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n staging

kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n default

kubectl create secret generic vault-token \
  --from-literal=token=<VAULT_ROOT_TOKEN> \
  -n databases
```

## 🔐 Secrets Management

Tutti i secrets sono in Vault. Nessun secret reale è committato in questo repository.

**Path structure:**
```
secret/guitartortona/
├── mariadb/
│   ├── root_password
│   ├── production/{username,password}
│   └── staging/{username,password}
├── production/ghcr/{username,password}
└── staging/ghcr/{username,password}
```

## 📖 Documentazione

- [Setup MariaDB](databases/mariadb/README.md)
- [Setup Vault](secrets/vault/README.md)
- [SecretStores](secrets/stores/README.md)
- [Monitoring](monitoring/README.md)
- [ArgoCD](argocd/README.md)

## 🔄 Workflow

1. Modifiche a questo repository → Commit e push
2. ArgoCD rileva modifiche automaticamente
3. Applica modifiche al cluster
4. Verifica su ArgoCD UI: https://argocd.guitar.lab

## ⚠️ Note Importanti

- **Vault** va unsealed manualmente dopo ogni riavvio del pod
- **Backup** configurati per MariaDB (TODO)
- **Monitoring** accessibile via Grafana (https://grafana.guitar.lab)

## 🆘 Troubleshooting

### Vault sealed
```bash
kubectl exec -it vault-0 -n vault -- vault operator unseal <UNSEAL_KEY>
```

### ExternalSecret non sincronizza
```bash
kubectl describe externalsecret <name> -n <namespace>
kubectl logs -n external-secrets -l app.kubernetes.io/name=external-secrets
```

### ArgoCD non sincronizza
```bash
kubectl get application -n argocd
kubectl describe application <app-name> -n argocd
```
