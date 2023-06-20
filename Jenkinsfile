pipeline {
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
       // AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        BUCKET = "deploy.web.static.io"
    }
    stages {
        stage('Check AWS') {
            steps {
                sh 'aws sts get-caller-identity'
            }
        }
        stage('Deploy to S3') {
            steps {
               sh 'aws s3 sync . s3://$BUCKET --exclude ".git/*"'
            }
        }
        stage('List Objets S3') {
            steps {
               sh 'aws s3 ls . s3://$BUCKET'
            }
        }
    }
}