#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/docker_getenv.sh

# Enforce tag build protection
# dont build if in jenkins and tag with same number exists
if [ -n "$JENKINS_HOME" ] && [ "$(git tag -l |grep $VERSION)"  ] && [ "$DOCKER_TAG_PROTECTION" ]
 then
        echo -e "\n\e[1;31m The version $VERSION already exists! \n...skipping build \n (Enforce tag build protection policy)"
        echo -e "\e[0m \n\n\n"
        exit 1
fi
docker build $1 $2 \
        --build-arg VCS_REF=`git rev-parse --short HEAD` \
        --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
        --build-arg GIT_USER="$GIT_USER" \
        -t $REGISTRY/$REPOSITORY:$VERSION . || exit 1
