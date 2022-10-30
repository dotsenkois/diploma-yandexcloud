#!/bin/bash
docker pull dotsenkois/diploma-web-app_backend:0.1.1
docker pull dotsenkois/diploma-web-app_frontend:0.1.1
registry_name=$(cat ./registry_name)
docker tag docker dotsenkois/diploma-web-app_backend:0.1.1 $registry_name/diploma-web-app_backend:0.1.1
docker tag docker dotsenkois/diploma-web-app_frontend:0.1.1 $registry_name/diploma-web-app_frontend:0.1.1
docker push
