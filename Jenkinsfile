pipeline {
    agent any
    environment {
        BUCKET = "front.bucket.295devops.io"
            }
    stages {
        stage('Init') {
            agent {
                docker {
                    image 'node:erbium-alpine'
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
                    image 'roxsross12/node-chrome'
                    args '-u root:root'
                }
            }
            steps {
                sh 'npm run test'
            }
        }
        stage('Build') {
            agent {
                docker {
                    image 'node:erbium-alpine'
                    args '-u root:root'
                }
            }
            steps {
                sh 'npm run build'
                stash includes: 'dist/**/**', name: 'dist'
            }
        }  
        stage('Deploy to s3') {
            steps {
              withAWS(region: 'us-east-1',credentials:'aws-roxsross'){
                unstash 'dist'
                sh 'aws s3 sync dist/. s3://$BUCKET --exclude ".git/*"'
              }
            }
        }
    } //end stages
}//end pipeline
