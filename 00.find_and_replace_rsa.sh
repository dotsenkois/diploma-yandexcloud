#!/bin/bash
# Скрипт создает проверяет наличие rsa-ключа с опредленным именем
# (по умолчанию netology), создает его в случае отсутствия
# и изменяет его во всех файлах cloud-init.yaml 
function new_rsa_key(){
echo "Проверяю наличе ключа для netology"
if [ ! -f ~/.ssh/netology ]; then 
ssh-keygen -f ~/.ssh/netology -P "";
echo "Ключ netology создан"
else
echo "Ключ netology уже существует"
fi
}

new_rsa_key
rsa=$(cat ~/.ssh/netology.pub)
find . -name *cloud_config.yaml -exec sed -i "s,- ssh-rsa.*,- $rsa,"  {} \;

