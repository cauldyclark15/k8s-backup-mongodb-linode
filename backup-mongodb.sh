#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
OPLOG_FLAG=""

if [ -n "$MONGODB_OPLOG" ]; then
	OPLOG_FLAG="--oplog"
fi

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."

mongodump $OPLOG_FLAG \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	--uri "$MONGODB_URI"

COPY_NAME=$ARCHIVE_NAME

echo "[$SCRIPT_NAME] Setting LINODE_CLI_TOKEN environment variable..."
export LINODE_CLI_TOKEN="$LINODE_CLI_TOKEN"
export LINODE_CLI_OBJ_SECRET_KEY="$LINODE_CLI_OBJ_SECRET_KEY"
export LINODE_CLI_OBJ_ACCESS_KEY="$LINODE_CLI_OBJ_ACCESS_KEY"
export REGION="$REGION"

echo "[$SCRIPT_NAME] Uploading compressed archive to Linode Object Storage..."

linode-cli obj put "$COPY_NAME" "$BUCKET_NAME/$COPY_NAME"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"