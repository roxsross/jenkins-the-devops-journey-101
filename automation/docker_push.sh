#!/bin/bash
	
##############################
## Get Environment Variables #
##############################
source ./automation/docker_getenv.sh

###############################################
## Request describe repositories from AWS ECR #
###############################################
RESPONSE=$(aws ecr describe-repositories \
  --repository-name $REPOSITORY)

##################################
## Checking if repository exists #
##################################
if [[ $? == 0 ]]; then
    PARSER=$(jq -r .repositories[0].repositoryName <<< $RESPONSE)
    echo "The repository exists:" $PARSER
else
    echo $REPOSITORY "does not exists"
    echo "Procced to create the repository."
    
    aws ecr create-repository \
      --repository-name $REPOSITORY  \
      --image-scanning-configuration scanOnPush=true
    
    # add access policy
    aws ecr set-repository-policy \
        --repository-name $REPOSITORY \
        --policy-text file://automation/aws_my-policy.json
fi

#####################
## Docker get login #
#####################
aws ecr get-login-password | docker login --username AWS --password-stdin $REGISTRY/$REPOSITORY

###############################################
## Pushing the image to repository on AWS ECR #
###############################################
docker push $REGISTRY/$REPOSITORY:$VERSION || exit 1
set +x	