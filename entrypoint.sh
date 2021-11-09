#!/bin/bash

set -e

if [[ -z "$TEMPLATE" ]]; then
    echo "Empty template specified. Looking for template.yaml..."

    if [[ ! -f "template.yaml" ]]; then
        echo template.yaml not found
        exit 1
    fi

    TEMPLATE="template.yaml"
fi

if [[ -z "$AWS_STACK_NAME" ]]; then
    echo AWS Stack Name invalid
    exit 1
fi

if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo AWS Access Key ID invalid
    exit 1
fi

if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo AWS Secret Access Key invalid
    exit 1
fi

if [[ -z "$AWS_REGION" ]]; then
    echo AWS Region invalid
    exit 1
fi

if [[ $FORCE_UPLOAD == true ]]; then
    FORCE_UPLOAD="--force-upload"
fi

if [[ -z "$CAPABILITIES" ]]; then
    CAPABILITIES="--capabilities CAPABILITY_IAM"
else
    CAPABILITIES="--capabilities $CAPABILITIES"
fi

if [[ ! -z "$PARAMETER_FILE" ]]; then
    PARAMETER_OVERRIDES="--parameter-overrides $(jq -r 'to_entries[] | "\(.key)=\"\(.value)\""' $PARAMETER_FILE | tr '\r\n' ' ')"
fi

if [[ ! -z "$TAGS" ]]; then
  TAGS="--tags $TAGS"
fi

if [[ ! -z "$ROLE_ARN" ]]; then
  ROLE_ARN="--role-arn $ROLE_ARN"
fi

if [[ -n "$AWS_DEPLOY_BUCKET" ]]; then
    DEPLOY_BUCKET="--s3-bucket $AWS_DEPLOY_BUCKET"
fi

mkdir -p ~/.aws
touch ~/.aws/credentials
touch ~/.aws/config

echo "[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
region = $AWS_REGION" > ~/.aws/credentials

echo "[default]
output = text
region = $AWS_REGION" > ~/.aws/config

array=(aws cloudformation deploy --stack-name $AWS_STACK_NAME --template-file $TEMPLATE $PARAMETER_OVERRIDES $CAPABILITIES $ROLE_ARN $FORCE_UPLOAD $TAGS $DEPLOY_BUCKET --no-fail-on-empty-changeset)
eval $(echo ${array[@]})
