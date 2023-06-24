pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        //AWS_SESSION_TOKEN = credentials('AWS_SESSION_TOKEN')
        BUCKET = "web.bucket.295devops.io"
            }
    stages {
        stage('Check AWS') {
            steps {
                sh 'aws sts get-caller-identity'
            }
        } 
        stage('Deploy to s3') {
            steps {
                sh 'aws s3 sync . s3://$BUCKET --exclude ".git/*"'
            }
        }
        stage('list objets s3') {
            steps {
                sh 'aws s3 ls s3://$BUCKET'
            }
        }
    } //end stages
}//end pipeline