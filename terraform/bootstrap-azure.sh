#!/bin/sh

TARGET="bootstrap-azure"
PROJECT="terraform-shared"

if [ -z "$ARM_SUBSCRIPTION_ID" ]; then
    echo "ARM_SUBSCRIPTION_ID needs to be set."
    exit 1
fi

./tf-run.sh -c init -t $TARGET -e $PROJECT
# ./tf-run.sh -c plan -t $TARGET -e $PROJECT
./tf-run.sh -c apply -t $TARGET -e $PROJECT
