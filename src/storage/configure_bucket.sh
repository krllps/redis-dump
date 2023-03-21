#!/bin/bash

read -rp "AWS S3 bucket name [None]: " AWS_S3_BUCKET_NAME
echo "AWS_S3_BUCKET_NAME=$AWS_S3_BUCKET_NAME" >> "$HOME"/.bashrc
