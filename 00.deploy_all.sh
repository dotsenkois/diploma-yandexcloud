function 00.install_yc(){
    # curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
    # export PATH=$PATH:/home/$USER/yandex-cloud/bin/

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
    if [ ! -f ~/.terraformrc ]; then
    cp .terraformrc ~/.terraformrc
    else
    mv ~/.terraformrc ~/.terraformrc.old
    cp .terraformrc ~/.terraformrc
    fi
}

function 01.tf_cloud_prepare(){
    # Передираем все 
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


    # pwd
    echo "ID каталога для bucket $id"
    echo -n $id> ./02.yc_folders/$service_folder
    sed -i "s/service_folder_id.*/service_folder_id = \"$id\"/" ./01.tf_cloud_prepare/locals.tf 
  done

    for workspace in "${workspaces[@]}" # Перебираем масиив с именами окружений
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

    check_folder=$(yc resource-manager folder get --name=$workspace 2>/dev/null)
    id=${check_folder:4:20}
    fi

    echo "ID каталога для $workspace $id"
    echo -n "$id"> ./02.yc_folders/$workspace
  done

  cd ./01.tf_cloud_prepare && terraform init && terraform apply --auto-approve
}

function 04.tf_infrastructure(){
# k8s=2
# if [[ $k8s == 1 ]]; then
# cd ../04.tf_infrastructure_VM
# else
cd ../04.tf_infrastructure_k8s_managed
# fi
echo "Начинаю развертывание основной инфраструктуры"
pwd

terraform init -reconfigure

for workspace in "${workspaces[@]}"
  do
    check=$(terraform workspace list| grep $workspace)
    if [ "$check" == "" ]; then
      terraform workspace new $workspace
    fi
    check=""
done    

terraform workspace select $(ls ../02.yc_folders/stage* --sort=time |xargs -n 1 basename|head -n 1)

terraform apply --auto-approve

}

function get_my_external_ip(){
  sed -i "s,ignoreip.*,ignoreip = 127.0.0.1/8 192.168.10.0/24 $(curl ipinfo.io/ip)/32," ./05.ansible/templates/fail2ban/default.conf
}
function run_ansible(){
./05.ansible/security.sh
./05.ansible/pg.sh
}

function monitoring(){
  echo ""
  }  



function 03.service(){
cd ../03.service && terraform init -reconfigure && terraform apply --auto-approve
}

function main(){

# настраиваем утилиту yc
yc config set token $YC_TOKEN
yc config set cloud-id $YC_CLOUD_ID

# переменные для создание ресурсов
workspaces=(prod stage) # Название  рабочих пространств и основных каталогов облака
service_folders=(bucket) # каталог для создания s3, в котором будет храниться состояние основной конфигурации terraform

get_my_external_ip
# new_rsa_key
configure_terraform
00.install_yc
01.tf_cloud_prepare
04.tf_infrastructure
run_ansible
}

main