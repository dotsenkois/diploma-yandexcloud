#!/bin/bash
set -x
function terraform_reinit() {
  terraform init
}

# Проверяем ключи, с котрым запущен скрипт
function check_params() {
  echo $# 
  echo $1
  echo $0
 
#  Если ключей нет, то выполняем функцию "main"
  if [ $# -eq 0 ]; then
    main
    # Иначе проверяем наличе ключа "help"
  else 
    if [[ "$@" =~ "--help" || "$@" =~ "-h" ]]; then
    help
    fi
  fi
}
# Функция справки. Не написано
function help() {
  echo "this is help"
}

# Проверка наличия утилиты yc
function check_yc() {

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

# Создание каталога в облаке для объектного хранилища 
function create_buket_folder() {
  # Передираем все 
  for buket_folder in "${buket_folders[@]}"
  do
    # Настройка YC
    # Создать каталог
    echo "Проверяю наличие каталог для bucket"
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$buket_folder 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      yc resource-manager folder create \
      --name=$buket_folder \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
      check_folder=$(yc resource-manager folder get --name=$buket_folder &>/dev/null )
      id=${check_folder:4:20}
    fi
    pwd
    echo "ID каталога для bucket $id"
    touch ./yc_folders/$buket_folder
    echo -n "$id"> ./yc_folders/$buket_folder
    sed -i "s/buket_folder_id.*/buket_folder_id = \"$id\"/" ./tf_cloud_prepare/locals.tf 
  done

}

# создание terrafrom workspaces и каталогов в облаке для указанных окружений
function create_workspaces_folders() {
# Перебираем масиив с именами окружений
  for workspace in "${workspaces[@]}"
  do
    # Настройка YC
    # Создать каталог
    
    check_folder='' # ЧТО ЭТО, БЛЯДЬ?
    check_folder=$(yc resource-manager folder get --name=$workspace 2>/dev/null)
    #
    id=${check_folder:4:20}
    # echo $id
    if [ "$id" == "" ]; then
      yc resource-manager folder create \
      --name=$workspace \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
      check_folder=$(yc resource-manager folder get --name=$workspace &>/dev/null)
      id=${check_folder:4:20}
    fi
    echo "ID каталога для $workspace $id"
    touch ./yc_folders/$workspace
    echo -n "$id"> ./yc_folders/$workspace
  done

}

function create_workspaces() {
  cd ./tf_cloud_prepare && terraform init && terraform apply --auto-approve
  cd ../tf_create_infrasturcture && terraform init
  

  for workspace in "${workspaces[@]}"
  do
    check=$(terraform workspace list| grep $workspace)
    if [ "$check" == "" ]; then
      terraform workspace new $workspace
    fi
    check=""
  done

  start_main_terrafrom
}


function prepare_kuberspray() {
  if [ ! -f ./kuberspray ]; then
    git clone
  fi
}

function start_main_terrafrom() {
  sleep 30
  rm terraform.tfstate*
  terraform workspace select $(ls ../yc_folders/stage* --sort=time |xargs -n 1 basename|head -n 1)
  terraform apply --auto-approve

}

function main() {
  check_yc
  create_buket_folder
  create_workspaces_folders
  create_workspaces
  
}

# настраиваем утилиту yc
yc config set token $YC_TOKEN
yc config set cloud-id $YC_CLOUD_ID

# переменные для создание ресурсов
workspaces=(prod stage) # Название  рабочих пространств и основных каталогов облака
buket_folders=(bucket) # каталог для создания s3, в котором будет храниться состояние основной конфигурации terraform


check_params