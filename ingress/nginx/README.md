# NGINX Ingress Controller

Ingress controller per gestire il traffico HTTP/HTTPS.

## Installazione

Già installato tramite MicroK8s addon:
```bash
microk8s enable ingress
```

## Configurazione

Gli Ingress sono definiti nelle rispettive applicazioni.

## Verifica
```bash
# IP assegnato da MetalLB
kubectl get svc -n ingress

# ConfigMap
kubectl get configmap -n ingress
```

## MetalLB Range

IP assegnati: 192.168.1.190-200
Ingress NGINX usa: 192.168.1.200
