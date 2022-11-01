## Задание 1. Создание статичного сайта с помощью бакета 

resource "yandex_iam_service_account" "bucket-sa-distrib" {
  name      = "dotsenkois1-distrs-storage"
  folder_id = local.folder_id

}

// Назначение роли сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa-distrib.id}"
}

// Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.bucket-sa-distrib.id
  description        = "static access key for bucket-sa object storage"
}

  resource "yandex_kms_symmetric_key" "key-a" {
  name              = "netology-key"
  description       = "Ключ для шифрования бакета"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}


// Создание бакета с использованием ключа
resource "yandex_storage_bucket" "distrs-storage" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bucket-sa-distrib1"
  anonymous_access_flags {
    read = true
    list = true
  }
  }


resource "yandex_storage_object" "terraform" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = yandex_storage_bucket.distrs-storage.id
  key        = "terraform_1.3.3_linux_amd64.zip"
  source     = "~/terraform_1.3.3_linux_amd64.zip"
}


