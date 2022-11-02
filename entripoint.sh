function 00.install_yc(){
  # Проверка пристутствия утилиты YC и ее установка в случае необходимости
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

function configure_terraform(){
# Настройка зеркала для скачивания провайдеров терраформ
    if [ ! -f ~/.terraformrc ]; then
    cp .terraformrc ~/.terraformrc
    else
    mv ~/.terraformrc ~/.terraformrc.old
    cp .terraformrc ~/.terraformrc
    fi
}

function 01.tf_cloud_prepare(){
# Создание каталога bucket
  for service_folder in "${service_folders[@]}"
  do
    # Настройка YC
    # Создать каталог
    echo "Проверяю наличие каталог для bucket"
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$service_folder 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      echo "создаю бакет"
      yc resource-manager folder create \
      --name=$service_folder \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
    check_folder=$(yc resource-manager folder get --name=$service_folder 2>/dev/null )
    id=${check_folder:4:20}
    fi

    echo "ID каталога для bucket $id"
  # Сохранение id каталога в файл для последующего испоьзования
    echo -n $id> ./02.yc_folders/$service_folder
    sed -i "s/service_folder_id.*/service_folder_id = \"$id\"/" ./01.tf_cloud_prepare/locals.tf 
  done

# Создание каталогов stage & prod
    for workspace in "${workspaces[@]}" # Перебираем масиив с именами окружений
  do
    check_folder=''
    check_folder=$(yc resource-manager folder get --name=$workspace 2>/dev/null)
    id=${check_folder:4:20}
    if [ "$id" == "" ]; then
      yc resource-manager folder create \
      --name=$workspace \
      --description="Каталог для дипломного проекта по теме 'Дипломный практикум в Яндекс.Облако' студента Доценко Илья Сергеевич" 2>/dev/null
    check_folder=$(yc resource-manager folder get --name=$workspace 2>/dev/null)
    id=${check_folder:4:20}
    fi

    echo "ID каталога для $workspace $id"
    # Сохранение id каталога в файл для последующего испоьзования
    echo -n "$id"> ./02.yc_folders/$workspace
  done
# Перейти в катлог с терраформ для создания бакета хранения состояния основной инфрастурктуры
  cd ./01.tf_cloud_prepare && terraform init && terraform apply --auto-approve
}

function 04.tf_infrastructure(){
# Развертывание основной инфрастукруты
cd ../04.tf_infrastructure_k8s_managed
terraform init -reconfigure
# Создание рабочих пространств
for workspace in "${workspaces[@]}"
  do
    check=$(terraform workspace list| grep $workspace)
    if [ "$check" == "" ]; then
      terraform workspace new $workspace
    fi
    check=""
done    
# Выбор пространства stage
terraform workspace select $(ls ../02.yc_folders/*stage* --sort=time |xargs -n 1 basename|head -n 1)
# запуск развертывания
terraform apply --auto-approve
}

# NOT USED # Получение внешнего ip для модификации файла конфигурации fail2ban
function get_my_external_ip(){
  sed -i "s,ignoreip.*,ignoreip = 127.0.0.1/8 192.168.10.0/24 $(curl ipinfo.io/ip)/32," ./05.ansible/templates/fail2ban/default.conf
}


function main(){

# настраиваем утилиту yc
yc config set token $YC_TOKEN
yc config set cloud-id $YC_CLOUD_ID

# переменные для создание ресурсов
workspaces=(dotsenkois-prod dotsenkois-stage) # Название  рабочих пространств и основных каталогов облака
service_folders=(dotsenkois-bucket) # каталог для создания s3, в котором будет храниться состояние основной конфигурации terraform

# Создать rsa ключ и поменять его в файлах cloud-init.yaml
./00.find_and_replace_rsa.sh
# Получить внешний IP 
get_my_external_ip
configure_terraform
00.install_yc

01.tf_cloud_prepare
04.tf_infrastructure

}
# Точка входа
main