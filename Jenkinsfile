pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
       // AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        REGISTRY = "roxsross12"
        APPNAME = "jenkinspy"
        VERSION = "1.0.0"
        EC2 = "ec2-user@44.211.221.9"
    }
    stages {
        stage('Docker Build') {
            steps {
               sh 'docker build -t $REGISTRY/$APPNAME:$VERSION .'
               sh 'docker images |grep jenkinspy'
            }
        }
        stage('Docker Push') {
            steps {
               sh '''
               docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
               docker push $REGISTRY/$APPNAME:$VERSION
               '''
            }
        }
        stage('Deploy to ec2') {
            steps {
             echo "Deploy to ec2"
             sh ("sed -i -- 's/REGISTRY/$REGISTRY/g' docker-compose.yml")
             sh ("sed -i -- 's/IMAGEAPP/$APPNAME/g' docker-compose.yml")
             sh ("sed -i -- 's/VERSION/$VERSION/g' docker-compose.yml")
             sshagent (['ssh-aws']){
                sh 'scp -o StrictHostKeyChecking=no docker-compose.yml $EC2:/home/ec2-user'
                sh 'ssh $EC2 ls -lrt'
                sh 'ssh $EC2 docker-compose up -d'
             }
            }
        }
    }
}