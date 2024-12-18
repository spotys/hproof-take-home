#!/bin/sh

TARGET="rotate-secret"
PROJECT="hproof-take-home"


if [ -z "$ARM_SUBSCRIPTION_ID" ]; then
    echo "ARM_SUBSCRIPTION_ID needs to be set."
    exit 1
fi

./tf-run.sh -c init -t $TARGET -e $PROJECT -k "rotate-secret.${PROJECT}.tfstate" \
  && ./tf-run.sh -c apply -t $TARGET -e $PROJECT
