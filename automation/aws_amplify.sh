#!/bin/bash
source ./automation/read_config.sh
source ./automation/docker_getenv.sh

check () {
    aws amplify list-apps
}

uploads3() {
    # CREATE BUCKET IF NOT EXISTS
    aws s3 mb s3://$s3bucketname --region us-east-1
    #cp to s3
    aws s3 cp dist.zip s3://$s3bucketname
}

deploy () {
    if [ -z "$APP_ID" ]
      then
      echo "ERROR! no APP_ID defined"
      exit 1  
    fi
    if [ -z "$AMPLIFY_BRANCH_NAME" ]
        then
        AMPLIFY_BRANCH_NAME="$BRANCH_NAME"
    fi

    aws amplify start-deployment --app-id $APP_ID --source-url s3://$s3bucketname/dist.zip --branch-name $AMPLIFY_BRANCH_NAME
}


case "$1" in

  'check')
    check ;;

  'uploads3')
    uploads3 ;;  

  'deploy')
    deploy ;;
    *)
      echo "error: unknown option $1"
      exit 1
      ;;
  esac
