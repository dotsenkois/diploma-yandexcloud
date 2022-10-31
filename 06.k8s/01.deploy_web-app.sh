#!/bin/bash
alias k=kubectl
source <( kubectl completion bash | sed s/kubectl/k/g )
source <( kubectl completion bash )
if [[ -z $(cat ~/.bashrc | grep 'alias k=kubectl') ]];then echo "alias k=kubectl" >> ~/.bashrc ;fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash | sed s/kubectl/k/g )") ]];then echo "source <( kubectl completion bash | sed s/kubectl/k/g )" >> ~/.bashrc; fi
if [[ -z $(cat ~/.bashrc | grep "source <( kubectl completion bash )") ]];then echo "source <( kubectl completion bash )" >> ~/.bashrc;fi

kubectl apply -f 01.namespaces.yml

# ingress 

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
# Установите менеджер сертификатов
kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.6.1/cert-manager.yaml
