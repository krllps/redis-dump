#!/bin/ash

DUMP_FILEPATH="/data/dump.rdb"

timestamp() {
    date +%F_%T
}

while true
do
    echo "$(timestamp): VERIFYING USER IDENTITY"
    if aws sts get-caller-identity; then
        echo "$(timestamp): IDENTITY VERIFIED"
        source "$HOME/.bashrc"
        if test -f "$DUMP_FILEPATH"; then
            echo "$(timestamp): REDIS DUMP FILE EXISTS"

            TIMESTAMP=$(timestamp)
            TIMESTAMPED_DUMP_FILEPATH="/tmp/$TIMESTAMP.dump.rdb"
            echo "$(timestamp): COPYING dump.rdb TO /tmp/$TIMESTAMP.dump.rdb"
            cp "$DUMP_FILEPATH" "$TIMESTAMPED_DUMP_FILEPATH" || { echo "$(timestamp): FAILED TO COPY"; continue; }

            echo "$(timestamp): UPLOADING TO $AWS_S3_BUCKET_NAME"
            ( aws s3 cp "$TIMESTAMPED_DUMP_FILEPATH" "s3://$AWS_S3_BUCKET_NAME/" && echo "$(timestamp): UPLOADED" ) || \
                echo "$(timestamp): FAILED TO UPLOAD"

            rm "$TIMESTAMPED_DUMP_FILEPATH"
        else
            echo "$(timestamp): NO AVAILABLE REDIS DUMP FILES AT $DUMP_FILEPATH"
        fi
    else
        echo "$(timestamp): COULD NOT VERIFY USER IDENTITY"
        echo "$(timestamp): DID YOU FORGET TO CALL make aws-configure ?"
    fi

    sleep 60
done
