# k8s-backup-mongodb-linode

Schedule MongoDB Backup to Linode Object Storage Using Kubernetes CronJob

### Ensure that the required Kubernetes secrets are created before deploying the chart:

```sh
kubectl create secret generic mongodb-uri --from-literal=MONGODB_URI='your-mongodb-uri'
kubectl create secret generic linode --from-literal=BUCKET_NAME='your-bucket-name' --from-literal=LINODE_CLI_TOKEN='your-linode-cli-token'
```
