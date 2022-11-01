resource "yandex_container_registry" "my-reg" {
  name = "my-registry"
  folder_id = local.workspaces[terraform.workspace].folder_id
  labels = {
    my-label = "my-label-value"
  }
}
resource "local_file" "registry-name" {
  filename = "../05.docker/registry_id"
  file_permission = "0644"
  content  = <<-EOT
${yandex_container_registry.my-reg.id}
EOT

  depends_on = [
    yandex_container_registry.my-reg,
  ]
}

resource "null_resource" "configure-depoyment" {
  provisioner "local-exec" {
    command = "cd ../05.docker && ./01.docker_registry.sh"
  }
depends_on = [
  local_file.registry-name
]
  }