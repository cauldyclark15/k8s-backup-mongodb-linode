FROM --platform=linux/amd64 mongo:latest

RUN apt update && \
    apt install -y python3 python3-pip python3-venv

# Create and activate virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install linode-cli and boto3 in virtual environment
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
    DATABASE="" \
    ENV=""

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

CMD ["/scripts/backup-mongodb.sh"]