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

resource "yandex_kms_symmetric_key" "jenkins-key" {
  name              = "jenkins-key"
  description       = "Ключ для шифрования jenkins"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
  }

  resource "yandex_iam_service_account_static_access_key" "jenkins-sa-static-key" {
  service_account_id = yandex_iam_service_account.jenkins-sa.id
  description        = "for as k8s admin"
}
