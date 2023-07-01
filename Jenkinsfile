pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        DOCKER_HUB_LOGIN = credentials('docker-hub')
            }
    stages {
        stage('horusec') {
            agent {
                docker {
                    image 'horuszup/horusec-cli:latest'
                    args '-u root:root'
                }
            }
            steps {
                sh 'horusec start -p ./ --disable-docker="true" -o="json" -O="./report_horusec.json"'
                stash name: 'report_horusec.json', includes: 'report_horusec.json'
            }
        } 
        stage('semgrep') {
            agent {
                docker {
                    image 'returntocorp/semgrep:latest'
                    args '-u root:root'
                }
            }
            steps {
                sh '''
                   semgrep ci --config=auto --json --output=report_semgrep.json
                   cat report_semgrep.json
                  '''
                stash name: 'report_semgrep.json', includes: 'report_semgrep.json'
            }
        } 
        stage('Trivy Scan') {
            steps {
                sh '''
                  IMAGE=trivy
                  docker build -t $IMAGE .
                  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b . v0.42.1
                  ./trivy image --format json --output report_trivy.json $IMAGE
                 docker run --rm -v $(pwd):/devsecops-pipeline -e "HOST=http://52.23.160.18:5985" -e "USERNAME=faraday" -e "PASSWORD=Admin1234" -e "WORKSPACE=devsecops-$BUILD_NUMBER" -e FILES="devsecops-pipeline/report_trivy.json" roxsross12/faraday-uploader:1.0.0  
                  ./script/trivy_scan.sh
                 '''
            }
        }
        // stage ('Upload Faraday') {
        //     agent {
        //         docker {
        //             image 'python:3.9.1'
        //             args '-u root:root -v $WORKSPACE:/reports'
        //         }
        //     }
        //     steps {
        //         dir ("reports"){
        //             unstash 'report_trivy.json'
        //             sh '''
        //                 pip install -q faraday-cli
        //                 faraday-cli auth -f http://52.23.160.18:5985 -u faraday -p "Admin1234"
        //                 faraday-cli workspace create devsecops-$BUILD_NUMBER
        //                 faraday-cli tool report -w devsecops-$BUILD_NUMBER report_trivy.json
        //             '''
        //         }

        //     }
        // }     
    } //end stages
}//end pipeline