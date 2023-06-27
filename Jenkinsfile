pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        REGISTRY="roxsross12"
        APPNAME="node-app"
        FARADAY_PASS = credentials('FARADAY_PASS')
            }
    stages {
        // stage('Init') {
        //     agent {
        //         docker {
        //             image 'node:erbium-alpine'
        //             args '-u root:root'
        //         }
        //     }
        //     steps {
        //         sh 'npm install'
        //     }
        // } 
        // stage('test') {
        //     agent {
        //         docker {
        //             image 'node:erbium-alpine'
        //             args '-u root:root'
        //         }
        //     }
        //     steps {
        //         sh 'npm run test'
        //     }
        // }

        stage('Security Sast') {
            parallel {
                stage('Horusec-Secret') {
                    steps {
                       script {
                            docker.image('horuszup/horusec-cli:latest').inside("--entrypoint=''"){
                                try {
                                    sh '''
                                        horusec start -p ./ --disable-docker="true" -o="json" -O="./horusec.json"
                                    '''

                                } catch (err){
                                    throw err
                                }
                            }
                       }
                    }
                }
                stage('Npm Audit') {
                    steps {
                        script {
                            docker.image('node:erbium-alpine').inside("--entrypoint=''"){
                                try {
                                    sh '''
                                        npm audit --registry=https://registry.npmjs.org -audit-level=moderate --json > report_npmaudit.json
                                    '''

                                } catch (err){
                                    throw err
                                }
                            }
                       }
                    }
                }
            }
        } //end parallel 

        stage('Security Container') {
            parallel {
                stage('Hadolint') {
                    steps {
                        sh 'docker run --rm -i hadolint/hadolint < Dockerfile'
                    }
                }
                stage('Trivy Scan') {
                    steps {
                        sh '''
                            
                            docker build -t $APPNAME .
                            curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b . v0.42.1
                            ./trivy image --format json --output trivy-report.json $APPNAME
                            echo ${WORKSPACE}
                            ls -lrt
                            echo ${pwd}
                            docker run --rm -v $(pwd):/pipeline-devsecops -e "HOST=https://faraday.295devops.com" -e "USERNAME=faraday" -e "PASSWORD=$FARADAY_PASS" -e "WORKSPACE=devsecops-$BUILD_NUMBER" -e "FILES=pipeline-devsecops/trivy-report.json" roxsross12/faraday-uploader:1.0.0 
                        '''
                    }
                }
            }
        } //end parallel 

        stage('Build') {
            steps {
                sh '''
                VERSION=$(jq --raw-output .version package.json)
                docker build -t $REGISTRY/$APPNAME:$VERSION .
                   '''  
            }
        }  
        stage('Push to DockerHub') {
            steps {
               sh '''
               docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
               VERSION=$(jq --raw-output .version package.json)
               docker push $REGISTRY/$APPNAME:$VERSION
               '''
            }
        }

        stage('DEPLOY') {
            steps {
               echo "hola"
            }
        }

        stage('DAST') {
            agent {
                docker {
                    image "owasp/zap2docker-weekly"
                    args "--volume ${WORKSPACE}:/zap/wrk"        
                    }
            }
            steps {
                script {
                    def result = sh label: "OWASP ZAP", returnStatus: true,
                        script: """\
                            mkdir -p reports &>/dev/null
                            zap-api-scan.py \
                            -t "https://petstore3.swagger.io/api/v3/openapi.json" \
                            -m 1 \
                            -d \
                            -f openapi \
                            -I \
                            -r reports/testreport.html \
                            -x reports/testreport.xml 
                    """
                    if (result > 0) {
                        unstable(message: "OWASP ZAP issues found")
                    }   
                }
            }
        }


     } //end stages
}//end pipeline