#!/bin/sh

TARGET="setup-environment"
PROJECT="hproof-take-home"

if [ -z "$ARM_SUBSCRIPTION_ID" ]; then
    echo "ARM_SUBSCRIPTION_ID needs to be set."
    exit 1
fi

./tf-run.sh -c init -t $TARGET -e $PROJECT -k "environment.${PROJECT}.tfstate" \
# && ./tf-run.sh -c plan -t $TARGET -e $PROJECT \
  && ./tf-run.sh -c apply -t $TARGET -e $PROJECT \
  && ./tf-run.sh -c output  -t $TARGET -e $PROJECT -o client_secret \
  && ./tf-run.sh -c output  -t $TARGET -e $PROJECT -o google_sa_keyfile
