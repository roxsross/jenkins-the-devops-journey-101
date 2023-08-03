#!/bin/bash
# table utils
source ./automation/printTable.sh

#Variable
LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

DOCKER_TAG_PROTECTION=true
# check version
if [ -z "$VERSION" ]
      then
      VERSION=`jq -r '.version' ./package.json`
      
fi

#get reponame
git_url=$(basename $(git config --get remote.origin.url))
REPONAME=${git_url/\.git/''}

AUTOMATION_SHORT=$(cd automation;git rev-parse --short HEAD)
AUTOMATION_BRANCH_NAME=$(cd automation;git rev-parse --abbrev-ref HEAD)
GIT_SHORT=$(git rev-parse --short HEAD) 

GIT_LAST_TAG=$(git tag --sort=committerdate|tail -n 1)  > /dev/null 2>&1
#get BRANCH_NAME from  GIT
if [ -z $GIT_BRANCH ]; then
  BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
else 
  BRANCH_NAME=$GIT_BRANCH
fi

# check repository
if [ -z "$REPOSITORY" ]
then
      REPOSITORY="$REPONAME"
fi

# check registry if not present then set to gitlab ECR
if [ -z "$REGISTRY" ]
then
      REGISTRY="459137896070.dkr.ecr.us-east-1.amazonaws.com"
fi

# check git user
if [ -z "$GITLAB_USER_LOGIN" ]
      then
            GIT_USER=$(git log -1 --pretty=format:'%an')
      else
            GIT_USER=$GITLAB_USER_LOGIN
fi
# check git user_email
if [ -z "$GITLAB_USER_EMAIL" ]
      then
            GIT_USER_EMAIL=$(git log -1 --pretty=format:'%ae')
      else
            GIT_USER_EMAIL=$GITLAB_USER_EMAIL
fi
# echo result

echo -e "\n${LGREEN}»» AUTOMATION JENKINS | BRANCH: $BRANCH_NAME ✅ ${NC}"
printTable ',' "$(cat <<EOF
VAR,VALUE
GIT_SHORT,$GIT_SHORT
GIT_LAST_TAG,$GIT_LAST_TAG
BRANCH_NAME,$BRANCH_NAME 
REGISTRY,$REGISTRY 
VERSION,$VERSION 
REPOSITORY,$REPOSITORY 
DOCKER_IMAGENAME,$REGISTRY/$REPOSITORY:$VERSION
DOCKER_TAG_PROTECTION,$DOCKER_TAG_PROTECTION
GIT_USER,$GIT_USER 
GIT_USER_EMAIL,$GIT_USER_EMAIL 

EOF
)
"
echo -e "${LBLUE}by RoxsRoss🔥${NC}"
set +x