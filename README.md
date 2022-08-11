# Описание дипломного проекта

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