pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
        REGISTRY="roxsross12"
        APPNAME="node-app"
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
                stage('audit') {
                    steps {
                        echo "1"
                    }
                }
            }
        } //end parallel 


    //     stage('Build') {
    //         steps {
    //             sh '''
    //             VERSION=$(jq --raw-output .version package.json)
    //             docker build -t $REGISTRY/$APPNAME:$VERSION .
    //                '''  
    //         }
    //     }  
    //     stage('Push to DockerHub') {
    //         steps {
    //            sh '''
    //            docker login --username=$DOCKER_HUB_LOGIN_USR --password=$DOCKER_HUB_LOGIN_PSW
    //            VERSION=$(jq --raw-output .version package.json)
    //            docker push $REGISTRY/$APPNAME:$VERSION
    //            '''
    //         }
    //     }
     } //end stages
}//end pipeline