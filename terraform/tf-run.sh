#!/bin/sh

while getopts :c:t:e:k:o: flag
do
    case "${flag}" in
        c) CMD=${OPTARG};;
        t) TARGET=${OPTARG};;
        e) ENVIRONMENT=${OPTARG};;
        e) ENVIRONMENT=${OPTARG};;
        o) OUTPUT=${OPTARG};;
    esac
done

# echo "CMD=${CMD}, TARGET=${TARGET}, ENVIRONMENT=${ENVIRONMENT}, BACKEND_CFG=${BACKEND_CFG}"
# exit 1


TARGET_DIR="targets/${TARGET}"
VAR_FILE="../../vars/${TARGET}.${ENVIRONMENT}.tfvars"


if [ "$CMD" != "output" ]; then
    ARGS="${ARGS} -var-file ${VAR_FILE}"
fi

if [ "$CMD" = "init" ]; then 
    ARGS="${ARGS} ${BACKEND_CFG}"
elif [ "$CMD" = "apply" ]; then 
    ARGS="${ARGS} -auto-approve"
elif [ "$CMD" = "output" ]; then 
    ARGS="${ARGS} ${OUTPUT}"
fi



pushd ${TARGET_DIR}

echo "Running: > terraform $CMD ${ARGS}"
terraform $CMD ${ARGS}

popd
