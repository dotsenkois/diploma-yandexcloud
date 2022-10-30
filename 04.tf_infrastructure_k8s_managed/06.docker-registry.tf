resource "yandex_container_registry" "my-reg" {
  name = "my-registry"
  folder_id = local.workspaces[terraform.workspace].folder_id
  labels = {
    my-label = "my-label-value"
  }
}
resource "local_file" "registry-name" {
  filename = "../05.docker/registry_name"
  file_permission = "0644"
  content  = <<-EOT
cr.yandex/${yandex_container_registry.my-reg.id}
EOT

  depends_on = [
    yandex_container_registry.my-reg,
  ]
}