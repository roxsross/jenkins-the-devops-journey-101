pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
            }
    stages {
        stage('init') {
            steps {
                echo "init"
            }
        } 
        stage('test') {
            steps {
                echo "test"
            }
        }
        stage('Trivy Scan') {
            steps {
                sh '''
                  IMAGE=trivy
                  docker build -t $IMAGE .
                  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b . v0.42.1
                  ./trivy image --format json --output report_trivy.json $IMAGE
                 '''
                 stash name: 'report_trivy.json', includes: 'report_trivy.json', useDefaultExcludes: false
            }
        }
        stage ('Upload Faraday') {
            agent {
                docker {
                    image 'python:3.9.1'
                    args '-u root:root -v $WORKSPACE:/reports'
                }
            }
            steps {
                dir ("reports"){
                    unstash 'report_trivy.json'
                    sh '''
                        pip install faraday-cli
                        faraday-cli auth -f http://52.23.160.18:5985 -u faraday -p "Admin1234"
                        faraday-cli workspace create devsecops-$BUILD_NUMBER
                        faraday-cli tool report -w devsecops-$BUILD_NUMBER report_trivy.json
                    '''
                }

            }
        }     
    } //end stages
}//end pipeline