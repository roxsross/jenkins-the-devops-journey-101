#!/bin/bash
# get variables form gitlab-ci or locals
source ./automation/docker_getenv.sh

hadolint () {
    if [ -f Dockerfile ] ; then 
        docker run --rm -i hadolint/hadolint < Dockerfile
    else 
        echo "No se encontró el Dockerfile" 
        exit 1 
    fi
}

secrets () {
    docker run --rm -v $PWD:/src  ghcr.io/zricethezav/gitleaks:latest  detect --source=/src/ -r /src/gitleaks.json --no-git -v
}

horusec () {
    curl -fsSL https://raw.githubusercontent.com/ZupIT/horusec/master/deployments/scripts/install.sh | bash -s latest
    ./horusec start -p ./ --disable-docker="true" -o="json" -O="./report_horusec.json"
}

trivy () {
    IMAGE=$REPOSITORY
    docker build -t $IMAGE .
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b . v0.42.1
    ./trivy image --format json --output report_trivy.json $IMAGE

}

case "$1" in

  'hadolint')
    hadolint ;;

  'horusec')
    horusec
    ;;

  'secrets')
    secrets
    ;;
  'trivy')
    trivy
    ;;

    *)
      echo "error: unknown option $1"
      exit 1
      ;;
  esac