FROM amazon/aws-cli:2.11.4

COPY configure_bucket.sh configure_bucket.sh
COPY backup_redis_dump.sh backup_redis_dump.sh

ENTRYPOINT [ "/bin/bash", "backup_redis_dump.sh" ]
