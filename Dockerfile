FROM mongo:latest

RUN apt update && \
    apt install -y python3 python3-pip

# Install linode-cli and boto3
RUN pip3 install linode-cli boto3

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI="" \
    MONGODB_OPLOG="" \
    BUCKET_NAME="" \
    LINODE_CLI_TOKEN="" \
    LINODE_CLI_OBJ_ACCESS_KEY="" \
    LINODE_CLI_OBJ_SECRET_KEY="" \
    REGION="" \
    DATABASE=""

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

CMD ["/scripts/backup-mongodb.sh"]