# MariaDB Deployment

Database condiviso per tutte le applicazioni Guitar Tortona.

## Databases

- `guitartortona` - Production
- `guitartortona_staging` - Staging

## Credentials

Gestite tramite Vault:
- Root password: `secret/guitartortona/mariadb/root_password`
- App credentials: Separate per environment

## Accesso
```bash
# Da dentro il cluster
mysql -h mariadb.databases.svc.cluster.local -u root -p

# Port-forward per accesso locale
kubectl port-forward -n databases svc/mariadb 3306:3306
mysql -h 127.0.0.1 -u root -p
```

## Backup

TODO: Configurare backup automatici con script
