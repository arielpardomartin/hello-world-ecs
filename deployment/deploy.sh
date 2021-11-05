#!/bin/bash
region=$(aws configure get region)
printf "\nThe region currently configured is \x1b[33m${region}\x1b[0m.\n\n"

read -p "Stack name: " stackname

printf "\n\nInstalling dependencies...\n"
npm i --silent
if [ $? != 0 ]; then exit 1; fi

printf "\n# Building new Hello World service image with the loaded configuration..."
bash setup-images.sh
bash create-stack.sh $stackname
node generate-output.js --stackOutputFilePath stack.json