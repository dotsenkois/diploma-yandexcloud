# Описание дипломного проекта

Для развертывания представленной инфраструктуры выполните комманду: 
```sh
wget https:// | sh
```

## В проекте реализовано

С помощью файла производится 
- скачивание необходимых репозиториев
- запуск следующего скрипта
Скрипт 00.deploy_all.sh обеспечивает предварительную подготовку облака:
1. Создаются необходимые каталоги: bucket, stage, prod
2. В каталоге bucket зарзворачивается s3 храниличе для хранения состояния terrafrom основой инфраструктуры
3. Произвадится развертываение [основной инфрастурктуры](04.tf_infrastructure_k8s_managed) 
   1. Кластер kubernetes (Managed service)
   2. Кластер postgres (VM + ansible)
   3. nat-instance
   4. Сервисный инстанс
   5. Инстанс jenkins
4. Подключение к кластеру kubernetes и создание экспортируемого файла конфигурации
5. развертываение средств мониторинга в кластере kubernetes



Запусти [run.sh](./run.sh)

Алгоритм работы скрипта:

Задать утилите yc параметры подключения: OAuth-токен и ID облака

Указать названия создаваемыx каталогов в облаке и рабочих пространств для terrafrom
Имена workspaces и рабочих каталогов совпадают.
Так же создается отдельный кталог, в котором будет находиться бакет для хранения состояния остновнйо конифгурации terrafrom





# Пометки
https://cloud.yandex.ru/docs/managed-gitlab/quickstart
https://cloud.yandex.ru/docs/managed-kubernetes/operations/connect/create-static-conf

Docker удалить всё
docker rm -vf $(docker ps -aq)
docker rmi -f $(docker images -aq)

В данном репозитории представлен вариант равзертываения инфраструктуры благодаря облачному провайдеру яндес.облако.


Релизовать 2 окружения stage и prod в разных папках облака.
Агенты filebeat для ELK запущены в качестве deamonset.
взаимодействие между подом полезной нагрузки и filebeat реализовано через k8s PV

ansible-galaxy roles for configure nsf server and client
https://galaxy.ansible.com/mrlesmithjr/nfs-server
https://galaxy.ansible.com/mrlesmithjr/nfs-client
devops-netology/13-kubernetes-config-02-mounts/ansible/roles

Необходима настройка defaults в этих ролях.

Необходма установка helm через kuberspray. Уточнить.

установка helm на этапе развертывания кластера
inventory/sample/group_vars/k8s_cluster/addons.yml
helm_enabled: false

Helm Completion Bash
source <(helm completion bash)
helm completion bash > /etc/bash_completion.d/helm

Error while proxying request: x509: certificate is valid for 10.233.0.1, 10.130.0.20, 127.0.0.1, not 51.250.44.19
https://programmersought.com/article/10445722801/

настройка хранилища NFS
https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner

```console
$ helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/
$ helm install nfs-subdir-external-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
    --set nfs.server=x.x.x.x \
    --set nfs.path=/exported/path
``


# stage
бд запускается в кластере кубер. Состояние хранится на отделной машине. 
Реализован PVC c с использованием CephFS или nfs.

# prod

БД должна находиться на отдельной машине.

Стараться не использовать PVC. Использовать для хранения s3. Или nfs
Использовать для бд отделюную машину
НА всеъ ВМ линукс отключить своп и возможность записи дампа ядра

Кластеризация бесплатной версии vault чепез COnsul 
https://gitlab.com/k11s-os/k8s-lessons

Для использованиея nfs профвайдеров необходимо установить пакет apt-get install -y nfs-common


alias k=kubectl
source <( kubectl completion bash | sed s/kubectl/k/g )
alias ksc="kubectl config set-context --current --namespace "****