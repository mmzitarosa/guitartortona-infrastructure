# GitHub Actions Self-Hosted Runner

Self-hosted runner per GitHub Actions usando Actions Runner Controller (ARC).

## Componenti

- **Namespace:** `actions-runner-system`
- **Controller:** Actions Runner Controller (installato via Helm)
- **Runner:** `guitartortona-api-runner`

## Prerequisiti

**GitHub Personal Access Token** con scopes:
- `repo` (Full control)
- `admin:repo_hook` (per webhook)
- `workflow`

Salva il token in `~/guitar-credentials.env`:
```bash
export GITHUB_RUNNER_TOKEN="ghp_your_token_here"
```

## Installazione

### 1. Aggiungi Helm repository
```bash
microk8s helm3 repo add actions-runner-controller \
  https://actions-runner-controller.github.io/actions-runner-controller
microk8s helm3 repo update
```

### 2. Installa Actions Runner Controller
```bash
source ~/guitar-credentials.env

microk8s helm3 install actions-runner-controller \
  actions-runner-controller/actions-runner-controller \
  --namespace actions-runner-system \
  --create-namespace \
  --set authSecret.create=true \
  --set authSecret.github_token="$GITHUB_RUNNER_TOKEN"
```

### 3. Verifica controller
```bash
kubectl get pods -n actions-runner-system

# Attendi Running
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=actions-runner-controller \
  -n actions-runner-system \
  --timeout=300s
```

### 4. Applica RunnerDeployment
```bash
kubectl apply -f github-runner/runner-deployment.yaml
```

### 5. Verifica runner
```bash
# RunnerDeployment
kubectl get runnerdeployment -n actions-runner-system

# Runner pod
kubectl get pods -n actions-runner-system -l app=github-runner

# Runner registrato
kubectl get runner -n actions-runner-system
```

### 6. Verifica su GitHub

https://github.com/mmzitarosa/guitartortona-api/settings/actions/runners

Dovresti vedere il runner con labels: `self-hosted`, `linux`, `k8s`

## Manutenzione

### Aggiorna token
```bash
source ~/guitar-credentials.env

kubectl delete secret controller-manager -n actions-runner-system

kubectl create secret generic controller-manager \
  --from-literal=github_token="$GITHUB_RUNNER_TOKEN" \
  -n actions-runner-system

kubectl rollout restart deployment actions-runner-controller \
  -n actions-runner-system
```

### Scale runner
```bash
kubectl scale runnerdeployment guitartortona-api-runner \
  -n actions-runner-system \
  --replicas=2
```

### Logs
```bash
# Controller logs
kubectl logs -n actions-runner-system \
  -l app.kubernetes.io/name=actions-runner-controller \
  -f

# Runner logs
kubectl logs -n actions-runner-system \
  -l runner-deployment-name=guitartortona-api-runner \
  -f
```

## Troubleshooting

### Runner non si registra
```bash
# Eventi
kubectl get events -n actions-runner-system --sort-by='.lastTimestamp'

# Logs dettagliati
kubectl logs -n actions-runner-system \
  -l runner-deployment-name=guitartortona-api-runner \
  --tail=100
```

### Elimina runner stale
```bash
kubectl get runner -n actions-runner-system
kubectl delete runner <runner-name> -n actions-runner-system
```

### Reinstalla controller
```bash
# Disinstalla
microk8s helm3 uninstall actions-runner-controller -n actions-runner-system

# Reinstalla
source ~/guitar-credentials.env

microk8s helm3 install actions-runner-controller \
  actions-runner-controller/actions-runner-controller \
  --namespace actions-runner-system \
  --create-namespace \
  --set authSecret.create=true \
  --set authSecret.github_token="$GITHUB_RUNNER_TOKEN"
```

## Disinstallazione
```bash
kubectl delete runnerdeployment guitartortona-api-runner -n actions-runner-system
microk8s helm3 uninstall actions-runner-controller -n actions-runner-system
kubectl delete namespace actions-runner-system
```
