FROM mongo:latest

RUN apt update && \
    apt install -y python3 python3-pip p7zip-full

# Install linode-cli
RUN pip3 install linode-cli

WORKDIR /scripts

COPY backup-mongodb.sh .
RUN chmod +x backup-mongodb.sh

ENV MONGODB_URI="" \
    MONGODB_OPLOG="" \
    BUCKET_NAME="" \
    LINODE_CLI_TOKEN="" \
    PASSWORD_7ZIP=""

# Configure linode-cli with the API token
RUN linode-cli configure --token $LINODE_CLI_TOKEN

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

CMD ["/scripts/backup-mongodb.sh"]