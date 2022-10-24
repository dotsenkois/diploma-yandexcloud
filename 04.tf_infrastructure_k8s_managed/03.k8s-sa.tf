resource "yandex_iam_service_account" "k8s-sa" {
 name        = "k8s-sa"
 description = "for managing k8s cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = local.workspaces[terraform.workspace].folder_id
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = local.workspaces[terraform.workspace].folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.k8s-sa.id}"
 ]
}

