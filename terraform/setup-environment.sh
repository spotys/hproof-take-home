#!/bin/sh

TARGET="setup-environment"
PROJECT="hproof-take-home"

./tf-run.sh -c init -t $TARGET -e $PROJECT -k "environment.${PROJECT}.tfstate"
# ./tf-run.sh -c plan -t $TARGET -e $PROJECT
./tf-run.sh -c apply -t $TARGET -e $PROJECT
./tf-run.sh -c output  -t $TARGET -e $PROJECT -o client_secret
./tf-run.sh -c output  -t $TARGET -e $PROJECT -o google_sa_keyfile
