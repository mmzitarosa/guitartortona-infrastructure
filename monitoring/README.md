# Monitoring Stack

Prometheus + Grafana per monitoring del cluster.

## Installazione

Installato via Helm (kube-prometheus-stack):
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install kube-prometheus-stack \
  prometheus-community/kube-prometheus-stack \
  -n monitoring \
  --create-namespace \
  -f prometheus-values.yaml
```

## Accesso

- **Grafana:** https://grafana.guitar.lab
  - Username: admin
  - Password: (saved in credentials file)

- **Prometheus:** https://prometheus.guitar.lab

## Configurazione

Vedi: `monitoring/prometheus-values.yaml`

## ServiceMonitors

Per applicazioni Spring Boot, creare ServiceMonitor:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: app-name
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: app-name
  endpoints:
    - port: http
      path: /actuator/prometheus
```
