# 🎸 Guitar Tortona Infrastructure

GitOps repository per la gestione dell'infrastruttura Kubernetes del progetto Guitar Tortona.

## 🏗️ Architettura

Questo repository contiene la configurazione di:
- **Databases**: MariaDB condiviso
- **Secrets Management**: HashiCorp Vault + External Secrets Operator
- **Ingress**: NGINX Ingress Controller
- **Monitoring**: Prometheus + Grafana
- **GitOps**: ArgoCD Applications

## 📂 Struttura
```
├── databases/
│   └── mariadb/              # MariaDB StatefulSet
├── secrets/
│   ├── vault/                # Vault deployment
│   ├── external-secrets/     # External Secrets Operator
│   └── stores/               # SecretStores per staging/production
├── ingress/
│   └── nginx/                # NGINX Ingress Controller
├── monitoring/
│   ├── prometheus/           # Prometheus deployment
│   └── grafana/              # Grafana deployment
└── argocd/
    ├── install.yaml          # ArgoCD installation
    └── applications/         # ArgoCD Applications definitions
```

## 🔐 Secrets

**IMPORTANTE:** Nessun secret reale è committato in questo repository.

Tutti i secrets sono gestiti tramite:
1. **Vault** (storage sicuro)
2. **External Secrets Operator** (sync automatico a Kubernetes)
3. **Git** contiene solo le **definizioni** degli ExternalSecrets

## 🚀 Deploy

Il deploy è gestito da **ArgoCD**:
- Modifiche su Git → ArgoCD sincronizza automaticamente
- Branch `main` → Production
- Branch `staging` → Staging (futuro)

## 📖 Documentazione

- [Setup iniziale](docs/setup.md)
- [Gestione secrets](docs/secrets.md)
- [Disaster Recovery](docs/disaster-recovery.md)
