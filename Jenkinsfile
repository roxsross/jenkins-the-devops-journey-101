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
            }
        }     
    } //end stages
}//end pipeline