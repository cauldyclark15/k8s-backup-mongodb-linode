#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb

if [ -n "$ENV" ]; then
    ARCHIVE_NAME=mongodump_${DATABASE}_${ENV}.gz
else
    ARCHIVE_NAME=mongodump_${DATABASE}.gz
fi

echo "[$SCRIPT_NAME] Dumping $DATABASE database to compressed archive..."

mongodump --archive="$ARCHIVE_NAME" \
	--db="$DATABASE" \
	--authenticationDatabase "admin" \
	--gzip \
	--uri "$MONGODB_URI"

COPY_NAME=$ARCHIVE_NAME

echo "[$SCRIPT_NAME] Setting LINODE_CLI_TOKEN environment variable..."
export LINODE_CLI_TOKEN="$LINODE_CLI_TOKEN"
export LINODE_CLI_OBJ_SECRET_KEY="$LINODE_CLI_OBJ_SECRET_KEY"
export LINODE_CLI_OBJ_ACCESS_KEY="$LINODE_CLI_OBJ_ACCESS_KEY"
export REGION="$REGION"

echo "[$SCRIPT_NAME] Uploading compressed archive to Linode Object Storage..."

linode-cli obj put "$COPY_NAME" "$BUCKET_NAME/$COPY_NAME" --cluster "$REGION"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"