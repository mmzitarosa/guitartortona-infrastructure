# Cert Manager

Gestione automatica certificati TLS.

## Installazione

Già installato nel cluster.

## CA Interna

Guitar Lab CA per certificati `*.guitar.lab`

### ClusterIssuer
```bash
kubectl get clusterissuer guitar-ca-issuer
```

## Utilizzo

Negli Ingress:
```yaml
metadata:
  annotations:
    cert-manager.io/cluster-issuer: guitar-ca-issuer
spec:
  tls:
    - hosts:
        - app.guitar.lab
      secretName: app-tls
```

Cert-manager creerà automaticamente il secret `app-tls` con il certificato.
