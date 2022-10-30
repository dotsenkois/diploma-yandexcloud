#!/bin/bash
alias k=kubectl
source <( kubectl completion bash | sed s/kubectl/k/g )
source <( kubectl completion bash )
if [[ -z $(cat ~/.bashrc | grep 'alias k=kubectl') ]];then echo "alias k=kubectl" >> ~/.bashrc ;fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash | sed s/kubectl/k/g )") ]];then echo "source <( kubectl completion bash | sed s/kubectl/k/g )" >> ~/.bashrc; fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash )") ]];then echo "source <( kubectl completion bash )" >> ~/.bashrc;fi

kubectl apply -f 01.namespaces.yml



# Monitoring
# Create namespase
kubectl create namespace monitoring

# Add prometheus-community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update helm repo
helm repo update

# Install prometeus
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring

#port-forward
kubectl port-forward --address 0.0.0.0 svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

kubectl port-forward --address 0.0.0.0 svc/prometheus-kube-state-metrics -n monitoring 8080 &
