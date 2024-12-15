#!/bin/sh

TARGET="rotate-secret"
PROJECT="hproof-take-home"

./tf-run.sh -c init -t $TARGET -e $PROJECT -k "rotate-secret.${PROJECT}.tfstate"
# ./tf-run.sh -c apply -t $TARGET -e $PROJECT
