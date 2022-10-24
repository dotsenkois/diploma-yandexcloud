
resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = "yc managed-kubernetes cluster  get-credentials ${yandex_kubernetes_cluster.k8s-netology.id} --external --force"
    
  }

  depends_on = [
    yandex_kubernetes_cluster.k8s-netology,
    yandex_kubernetes_node_group.k8s-netology-node-group
  ]
}

# resource "null_resource" "kube-staticonfig" {
#   provisioner "local-exec" {
#     command = "cd ../.kuber && echo -n '${yandex_kubernetes_cluster.k8s-netology.id}' > cluster_id && ./get-staticconfig.sh"
    
#   }

#   depends_on = [
#     yandex_kubernetes_cluster.k8s-netology,
#     yandex_kubernetes_node_group.k8s-netology-node-group
#   ]
# }
