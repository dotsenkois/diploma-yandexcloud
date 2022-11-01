#!/bin/bash
function autocomplition(){
alias k=kubectl
source <( kubectl completion bash | sed s/kubectl/k/g )
source <( kubectl completion bash )
if [[ -z $(cat ~/.bashrc | grep 'alias k=kubectl') ]];then echo "alias k=kubectl" >> ~/.bashrc ;fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash | sed s/kubectl/k/g )") ]];then echo "source <( kubectl completion bash | sed s/kubectl/k/g )" >> ~/.bashrc; fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash )") ]];then echo "source <( kubectl completion bash )" >> ~/.bashrc;fi
}

function deploy_monitoring(){
    # Monitoring
# Create namespase
kubectl create namespace monitoring

# Add prometheus-community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update helm repo
helm repo update

# Install prometeus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring


}

function deploy_web-app(){
    kubectl apply -f web-app/01.namespaces.yml 
    kubectl apply -f web-app/ds.backend.yml
    kubectl apply -f web-app/ds.frontend.yaml
}



function main(){
autocomplition
deploy_web-app
deploy_monitoring


}

main