#!/bin/bash

set -e

SCRIPT_NAME=backup-mongodb
ARCHIVE_NAME=mongodump_$(date +%Y%m%d_%H%M%S).gz
OPLOG_FLAG=""

# Install Python3 and pip if not already installed
if ! command -v python3 &> /dev/null; then
    echo "[$SCRIPT_NAME] Installing Python3..."
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
fi

# Install linode-cli if not already installed
if ! command -v linode-cli &> /dev/null; then
    echo "[$SCRIPT_NAME] Installing linode-cli..."
    pip3 install linode-cli
fi

if [ -n "$MONGODB_OPLOG" ]; then
    OPLOG_FLAG="--oplog"
fi

echo "[$SCRIPT_NAME] Dumping all MongoDB databases to compressed archive..."

mongodump $OPLOG_FLAG \
    --archive="$ARCHIVE_NAME" \
    --gzip \
    --uri "$MONGODB_URI"

COPY_NAME=$ARCHIVE_NAME
if [ ! -z "$PASSWORD_7ZIP" ]; then
    echo "[$SCRIPT_NAME] 7Zipping with password..."
    COPY_NAME=mongodump_$(date +%Y%m%d_%H%M%S).7z
    7za a -tzip -p"$PASSWORD_7ZIP" -mem=AES256 "$COPY_NAME" "$ARCHIVE_NAME"
fi

echo "[$SCRIPT_NAME] Configuring Linode CLI with the provided token..."
linode-cli configure --token "$LINODE_CLI_TOKEN"

echo "[$SCRIPT_NAME] Uploading compressed archive to Linode Object Storage..."
linode-cli obj put "$COPY_NAME" "$BUCKET_NAME/$COPY_NAME"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"
