resource "yandex_iam_service_account" "jenkins-sa" {
 name        = "jenkins"
 description = "For images pulling and pushing"
}

resource "yandex_resourcemanager_folder_iam_binding" "jenkins-images-pusher" {
 # Сервисному аккаунту назначается роль "editor".
 folder_id = local.workspaces[terraform.workspace].folder_id
 role      = "container-registry.images.pusher"
 members   = [
   "serviceAccount:${yandex_iam_service_account.jenkins-sa.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "jenkins-images-puller" {
 # Сервисному аккаунту назначается роль "container-registry.images.puller".
 folder_id = local.workspaces[terraform.workspace].folder_id
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.jenkins-sa.id}"
 ]
}

