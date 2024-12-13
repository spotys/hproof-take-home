#!/bin/sh

TARGET="bootstrap-azure"
PROJECT="terraform-shared"

./tf-run.sh -c init -t $TARGET -e $PROJECT
# ./tf-run.sh -c plan -t $TARGET -e $PROJECT
./tf-run.sh -c apply -t $TARGET -e $PROJECT
