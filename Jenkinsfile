pipeline {
    agent any
    environment {
        BUCKET = "front.bucket.295devops.io"
        TARGET_REGION = "us-east-1"
        BOT_URL = credentials('telegram')
            }
    stages {
        stage('Install dependencies ') {
            parallel {
                stage('Init') {
                agent {
                    docker {
                        image 'node:fermium-alpine'
                        args '-u root:root'
                    }           
                 }
                    steps {
                        sh 'npm install'
                    }
                }
                stage('Test') {
                agent {
                    docker {
                        image 'node:fermium-alpine'
                        args '-u root:root'
                    }           
                 }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        sh 'npm run test'
                        }
                    }
                }
            } // end parallel
        }
        stage('sast') {
            parallel {
                stage('Secrets-Gitleaks') {
                    steps {
                        script {
                            def result = sh label: "Secrets", returnStatus: true,
                                script: """\
                                    ./automation/security.sh secrets
                            """
                            if (result > 0) {
                                unstable(message: "Secrets issues found")
                            }   
                            }
                        }
                    }
            stage('audit') {
                agent {
                    docker {
                        image 'node:fermium-alpine'
                        args '-u root:root'
                    }           
                 }
                    steps {
                        catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                            sh 'npm audit --registry=https://registry.npmjs.org -audit-level=critical --json > report_npmaudit.json'
                            stash name: 'report_npmaudit.json', includes: 'report_npmaudit.json'
                        } 
                    }
                }
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
              withAWS(region: "${TARGET_REGION}",credentials:'aws-roxsross'){
                unstash 'dist'
                sh './automation/aws_amplify.sh uploads3'
              }
            }
        }
                   
    stage('Notifications') {
            steps {
                sh './automation/notification.sh'
            }
        }
    } //end stages
}//end pipeline
