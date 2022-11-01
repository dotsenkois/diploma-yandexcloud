function 00.install_yc(){
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

function 00.service(){
    # Передираем все 
  for service_folder in "${service_folders[@]}"
  do
    # Настройка YC
    # Создать каталог
    echo "Проверяю наличие каталога $service_folder"
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$service_folder 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      echo "создаю каталог $service_folder"
      yc resource-manager folder create \
      --name=$service_folder \
      --description="Каталог для сервисных нужд" 2>/dev/null
    check_folder=$(yc resource-manager folder get --name=$service_folder 2>/dev/null )
    id=${check_folder:4:20}
    fi
    # pwd
    echo "ID каталога $id"
    echo -n $id> ./02.yc_folders/$service_folder
    sed -i "s/folder_id =.*/folder_id = \"$id\"/" ./00.service/00.locals.tf 
  done
  cd ./00.service
  terraform init -reconfigure && terraform apply --auto-approve
}

function main(){

# настраиваем утилиту yc
yc config set token $YC_TOKEN
yc config set cloud-id $YC_CLOUD_ID

# переменные для создание ресурсов
service_folders=(dotsenkois-service)
./00.find_and_replace_rsa.sh

00.install_yc
00.service
# run_ansible


}

main