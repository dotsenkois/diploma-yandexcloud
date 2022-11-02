resource "yandex_iam_service_account" "main" {
  name        = "main-robot"
  description = "Са для управления инфраструктурой в облаке"
  folder_id   = local.workspaces[terraform.workspace].folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "compute_admin" {
  folder_id   = local.workspaces[terraform.workspace].folder_id
  role        = "compute.admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.main.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "container-registry_admin" {
  folder_id   = local.workspaces[terraform.workspace].folder_id
  role        = "container-registry.admin"
  members     = [
    "serviceAccount:${yandex_iam_service_account.main.id}",
  ]
}