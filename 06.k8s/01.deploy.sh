#!/bin/bash
function helm_init(){
  if [ ! -f /usr/local/bin/helm ]; then curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash; fi

}
function autocomplition(){
alias k=kubectl
source <( kubectl completion bash | sed s/kubectl/k/g )
source <( kubectl completion bash )
if [[ -z $(cat ~/.bashrc | grep 'alias k=kubectl') ]];then echo "alias k=kubectl" >> ~/.bashrc ;fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash | sed s/kubectl/k/g )") ]];then echo "source <( kubectl completion bash | sed s/kubectl/k/g )" >> ~/.bashrc; fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash )") ]];then echo "source <( kubectl completion bash )" >> ~/.bashrc;fi
}

function deploy_monitoring(){

if [[ -z $(kubectl get ns |grep monitoring) ]];then 
# Monitoring
# Create namespase
kubectl create namespace monitoring

# Add prometheus-community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add jenkins https://charts.jenkins.io


# Update helm repo
helm repo update

# Install prometeus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
fi

kubectl delete -f monitoring/grafana-service_modified.yaml
kubectl apply -f monitoring/grafana-service_modified.yaml

}

function deploy_web-app(){
    kubectl apply -f web-app/01.namespaces.yaml 
    kubectl apply -f web-app/ds.backend.yaml
    kubectl apply -f web-app/ds.frontend.yaml
}
function jenkins(){
# kubectl create ns jenkins
# helm install --name jenkins --namespace jenkins -f jenkins/demo-values.yaml stable/jenkins
}

function main(){
autocomplition
deploy_web-app
deploy_monitoring
# jenkins
}

main