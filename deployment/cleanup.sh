#!/bin/bash
echo
read -p "Stack name: " STACKNAME
HELLO_WORLD_REPOSITORY_NAME=hello-world-demo-images

printf "\nRemoving stack \x1b[33m$STACKNAME\x1b[0m...\n"
aws cloudformation delete-stack --stack-name $STACKNAME
aws cloudformation wait stack-delete-complete --stack-name $STACKNAME

printf "\nRemoving ECR repository \"$HELLO_WORLD_REPOSITORY_NAME\"...\n"
aws ecr delete-repository --repository-name $HELLO_WORLD_REPOSITORY_NAME --force

printf "\nCleanup complete!\n"