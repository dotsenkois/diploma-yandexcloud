FROM jenkinsci/blueocean

RUN "wget https://get.helm.sh/helm-v3.10.1-linux-amd64.tar.gz && tar -zxvf helm-v3.0.0-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm"

