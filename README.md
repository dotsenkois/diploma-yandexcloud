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