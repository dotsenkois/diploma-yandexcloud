resource "yandex_container_registry" "my-reg" {
  name = "my-registry"
  folder_id = local.workspaces[terraform.workspace].folder_id
  labels = {
    my-label = "my-label-value"
  }
}