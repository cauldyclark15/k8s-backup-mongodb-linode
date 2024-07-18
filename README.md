# k8s-backup-mongodb-linode

Schedule MongoDB Backup to Linode Object Storage Using Kubernetes CronJob

### Ensure that the required Kubernetes secrets are created before deploying the chart:

```sh
kubectl create secret generic mongodb-uri --from-literal=MONGODB_URI='your-mongodb-uri'
kubectl create secret generic linode --from-literal=BUCKET_NAME='linode-bucket' --from-literal=LINODE_CLI_TOKEN='linode-personal-token' --from-literal=LINODE_CLI_OBJ_ACCESS_KEY='ak' --from-literal=LINODE_CLI_OBJ_SECRET_KEY='sk' --from-literal=REGION='default-region'
```

### Create a helm chart:

```sh
helm package mongodb-backup
```

### Deploy your helm chart

```sh
helm upgrade --install itemcount-mongodb-backup ./mongodb-backup-0.1.0.tgz:
```
