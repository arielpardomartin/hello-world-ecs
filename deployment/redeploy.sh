#!/bin/bash
region=$(aws configure get region)
printf "\nThe region currently configured is \x1b[33m${region}\x1b[0m.\n\n"

read -p "Cluster name: " clustername
read -p "Service name: " servicename

# Setup variables
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY=$AWS_ACCOUNT_ID.dkr.ecr.$region.amazonaws.com
HELLO_WORLD_REPOSITORY_NAME=hello-world-demo-images

# Log in into registry
printf "\n\nLogging in into default private registry...\n"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $ECR_REGISTRY
if [ $? != 0 ]; then exit 1; fi

cd ../serverless

printf "\n\nBuilding and pushing Hello World service image...\n"
docker build -q -t $ECR_REGISTRY/$HELLO_WORLD_REPOSITORY_NAME:latest .
docker push $ECR_REGISTRY/$HELLO_WORLD_REPOSITORY_NAME:latest
if [ $? != 0 ]; then exit 1; fi

cd ../deployment
printf "\n\nECS container images setup complete!\n"

printf "\n\nUpdating service!\n"
aws ecs update-service --cluster $clustername --service $servicename --force-new-deployment