pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        //AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        REGISTRY="roxsross12"
        APPNAME="py-app"
        VERSION="1.0.0"
        EC2="ec2-user@184.73.89.92"
        BOT_URL = credentials('BOT_URL')
        TELEGRAM_CHAT_ID="-1001508340482"
            }
    stages {
        stage('Build') {
            steps {
                sh '''
                docker build -t $REGISTRY/$APPNAME:$VERSION .
                   '''  
            }
        }  
        stage('Push to DockerHub') {
            steps {
               sh '''
               docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
               docker push $REGISTRY/$APPNAME:$VERSION
               '''
            }
        }
        stage('Deploy to ec2') {
            steps {
                echo "===DEPLOY TO EC2"
                sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
                sh ("sed -i -- 's/APPNAME/$APPNAME/g' docker-compose.yml")
                sh ("sed -i -- 's/VERSION/$VERSION/g' docker-compose.yml")
                sshagent (['ssh-aws']){
                    sh 'scp -o StrictHostKeyChecking=no docker-compose.yml $EC2:/home/ec2-user'
                    sh 'ssh $EC2 docker-compose up -d'
                }

            }            
        }
    } //end stages
    post {
        success{
              sh  "curl -s -X POST $BOT_URL -d chat_id=${TELEGRAM_CHAT_ID} -d parse_mode=markdown -d text='*Full project name*: ${env.JOB_NAME} \n*Branch*: [$GIT_BRANCH]($GIT_URL) \n*Build* : [OK])'"
        }
        failure{
              sh  "curl -s -X POST $BOT_URL -d chat_id=${TELEGRAM_CHAT_ID} -d parse_mode=markdown -d text='*Full project name*: ${env.JOB_NAME} \n*Branch*: [$GIT_BRANCH]($GIT_URL) \n*Build* : [NOK])'"
        }
    }
}//end pipeline