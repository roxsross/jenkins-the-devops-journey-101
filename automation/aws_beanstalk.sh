#!/bin/bash
source ./automation/docker_getenv.sh
source ./automation/read_config.sh

DOCKER_COMPOSE_FILE="docker-compose.yml"

check () {
    aws elasticbeanstalk describe-applications --output table    
}

compose () {
  if [ -f docker-compose.yml ] ; then
        echo "Patching Dockerrun.aws.json to Image = \"$REGISTRY/$REPOSITORY:$VERSION\""
        sed -i -- "s/REGISTRY/$REGISTRY/g" docker-compose.yml
        sed -i -- "s/REPOSITORY/$REPOSITORY/g" docker-compose.yml
        sed -i -- "s/VERSION/$VERSION/g" docker-compose.yml
  else 
        echo "No se encontró el docker-compose.yml" 
        exit 1 
  fi
}
deploy() {
    aws s3 cp ${DOCKER_COMPOSE_FILE} "s3://${s3bucketname}/${s3key}/${DOCKER_COMPOSE_FILE}"
    aws elasticbeanstalk create-application-version --application-name "${eb_applicationname}" --version-label "JenkinJob-${eb_environmentname}-${BUILD_NUMBER}" --description "${eb_environmentname}-${BUILD_NUMBER}" --source-bundle S3Bucket="${s3bucketname}",S3Key="${s3key}/${DOCKER_COMPOSE_FILE}" --no-auto-create-application
    aws elasticbeanstalk update-environment --environment-id "${eb_environmentid}" --environment-name "${eb_environmentname}" --version-label "JenkinJob-${eb_environmentname}-${BUILD_NUMBER}"
}
case "$1" in

  'check')
    check ;;

  'compose')
    compose ;;  

  'deploy')
    deploy ;;
    *)
      echo "error: unknown option $1"
      exit 1
      ;;
  esac