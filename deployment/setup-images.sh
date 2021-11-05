#!/bin/bash

# Setup variables
AWS_REGION=$(aws configure get region)
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
HELLO_WORLD_REPOSITORY_NAME=hello-world-demo-images

# Log in into registry
printf "\n\nLogging in into default private registry...\n"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY
if [ $? != 0 ]; then exit 1; fi

cd ../serverless

# Build and push Stream service image
printf "\n\nCreating image repository for Stream service...\n"
aws ecr create-repository --repository-name $HELLO_WORLD_REPOSITORY_NAME
printf "\n\nBuilding and pushing Stream service image...\n"
docker build -q -t $ECR_REGISTRY/$HELLO_WORLD_REPOSITORY_NAME:latest .
docker push $ECR_REGISTRY/$HELLO_WORLD_REPOSITORY_NAME:latest
if [ $? != 0 ]; then exit 1; fi

cd ../deployment
printf "\n\nECS container images setup complete!\n"