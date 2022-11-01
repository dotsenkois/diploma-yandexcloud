#!/bin/bash
docker pull dotsenkois/diploma-web-app_backend:0.1.1
docker pull dotsenkois/diploma-web-app_frontend:0.1.1
registry_id=$(cat ./registry_id)
docker tag dotsenkois/diploma-web-app_backend:0.1.1 cr.yandex/$registry_id/diploma-web-app_backend:0.1.1
docker tag dotsenkois/diploma-web-app_frontend:0.1.1 cr.yandex/$registry_id/diploma-web-app_frontend:0.1.1
docker push cr.yandex/$registry_id/diploma-web-app_backend:0.1.1
docker push cr.yandex/$registry_id/diploma-web-app_frontend:0.1.1
sed -i "s,image:.*,image: cr.yandex/$registry_id/diploma-web-app_backend:0.1.1," ../06.k8s/web-app/ds.backend.yaml
sed -i "s,image:.*,image: cr.yandex/$registry_id/diploma-web-app_frontend:0.1.1," ../06.k8s/web-app/ds.frontend.yaml
