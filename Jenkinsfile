pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
       // AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        BUCKET = "deploy.web.static.io"
        REGISTRY = "roxsross12"
        APPNAME = "jenkins-node-demo"
    }
    stages {
        stage('init') {
            agent {
                docker {
                    image 'node:alpine'
                    args '-u root:root'
                }
            }
            steps {
                sh 'npm install'
            }
        }
        stage('test') {
            agent {
                docker {
                    image 'node:alpine'
                    args '-u root:root'
                }
            }
            steps {
                sh 'npm run test'
            }
        }
        stage('Check Version') {
            steps {
                sh '''
                VERSION=$(jq --raw-output .version package.json)
                echo $VERSION >version.txt
                '''
            }
        }
        stage('Docker Build') {
            steps {
               sh 'docker build -t $REGISTRY/$APPNAME:$(cat version.txt) .'
            }
        }
        stage('Docker Push') {
            steps {
               sh '''
               docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
               docker push $REGISTRY/$APPNAME:$(cat version.txt)
               '''
            }
        }
    }
}