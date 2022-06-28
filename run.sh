#!/bin/bash

function terraform_reinit() {
# Удалить старое
# rm -rf ./tf_cloud_prepare/.terraform*
# rm ./tf_cloud_prepare/folder_id ./tf_cloud_prepare/terraform*
echo
}

function check_params() {
  echo $# 
  echo $1
  echo $0
 
  if [ $# -eq 0 ]; then
    main
  else
    if [[ "$@" =~ "--help" || "$@" =~ "-h" ]]; then
    help
    fi
  fi
}
function help() {
  echo "this is help"
}

function check_yc() {
  # проверка наличия утилиты yc
  echo "Проверка установки утилиты yc"
  if [ ! -f /home/$USER/yandex-cloud/bin/yc ]; then
      echo "устанавливаю утилиту YC"
      curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
      export PATH=$PATH:/home/$USER/yandex-cloud/bin/
  else
      echo "Утилита YC уже установлена"
      if [ ! -f /home/$USER/.config/yandex-cloud/config.yaml.bkp ]; then
        yc_config_file="/home/$USER/.config/yandex-cloud/config.yaml"
        cp $yc_config_file $yc_config_file".bkp"
        echo "Бэкап файла конфигурации $yc_config_file выполнен"
      fi
  fi
}

function create_buket_folder() {

  for buket_folder in "${buket_folders[@]}"
  do
    # Настройка YC
    # Создать каталог
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$folder 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      yc resource-manager folder create \
      --name=$folder \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
      check_folder=$(yc resource-manager folder get --name=$folder &>/dev/null)
      id=${check_folder:4:20}
    fi
    echo -n "$id"> ./yc_folders/$folder
  done

}


function create_workspaces_folders() {

  for workspace in "${workspaces[@]}"
  do
    # Настройка YC
    # Создать каталог
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$workspace 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      yc resource-manager folder create \
      --name=$workspace \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
      check_folder=$(yc resource-manager folder get --name=$workspace &>/dev/null)
      id=${check_folder:4:20}
    fi
    echo -n "$id"> ./yc_folders/$workspace
  done

}

function create_workspaces() {
  cd ./tf_cloud_prepare && terraform apply --auto-approve
  cd ../tf_create_infrasturcture && terraform init

  for workspace in "${workspaces[@]}"
  do
    check=$(terraform workspace list| grep $workspace)
    if [ "$check" == "" ]; then
      terraform workspace new $workspace
    fi
    check=""
  done
}
function prepare_kuberspray() {
  if [ ! -f ./kuberspray ]; then
    git clone
  fi
}

function main() {
  check_yc
  create_folders
  create_workspaces
}

# переменные для подключения
token=$YC_TOKEN
cloud_id=$YC_CLOUD_ID

yc config set token $token
yc config set cloud-id $cloud_id

# переменные для создание ресурсов
workspaces=(prod stage)
buket_folders=(bucket)


check_params