# Получите уникальный идентификатор кластера Kubernetes
# yc managed-kubernetes cluster list
# Запишите уникальный идентификатор кластера Kubernetes в переменную

CLUSTER_ID=$(cat cluster_id)
yc managed-kubernetes cluster get --id $CLUSTER_ID --format json |  \
jq -r .master.master_auth.cluster_ca_certificate | \
awk '{gsub(/\\n/,"\n")}1' > ca.pem

# Создайте объект ServiceAccount sa.yaml

kubectl apply -f sa.yaml

SA_TOKEN=$(kubectl -n kube-system get secret $(kubectl -n kube-system get secret | \
grep admin-user | \
awk '{print $1}') -o json | \
jq -r .data.token | \
base64 --d)

# Получите IP-адрес кластера Kubernetes

MASTER_ENDPOINT=$(yc managed-kubernetes cluster get --id $CLUSTER_ID \
--format json | \
jq -r .master.endpoints.external_v4_endpoint)

# Создайте и заполните файл конфигурации

kubectl config set-cluster sa-test2 \
  --certificate-authority=ca.pem \
  --server=$MASTER_ENDPOINT \
  --kubeconfig=test.kubeconfig

kubectl config set-credentials admin-user \
--token=$SA_TOKEN \
--kubeconfig=test.kubeconfig


kubectl config set-context default \
  --cluster=sa-test2 \
  --user=admin-user \
  --kubeconfig=test.kubeconfig

kubectl config use-context default \
--kubeconfig=test.kubeconfig

# Проверьте резульатат

kubectl get namespace --kubeconfig=test.kubeconfig