
// Create SA
resource "yandex_iam_service_account" "sa-bucket" {
  folder_id = local.buket_folder_id
  name      = "sa-for-bucket-dotsenkois"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.buket_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
  description        = "diploma-dotsenkois. static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "dotsenkois-diploma" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "bucket-diploma-dotsenkois"
}

resource "local_file" "backend-1" {
  filename = "../04.tf_infrastructure_k8s_managed/backend.tf"
  content  = <<-EOT
terraform {
  backend "s3" {
  endpoint   = "storage.yandexcloud.net"
  bucket     = "${yandex_storage_bucket.dotsenkois-diploma.bucket}"
  region     = "ru-central1"
  key        = "tf/dotsenkois-diploma-v2.tfstate"
  access_key = "${yandex_iam_service_account_static_access_key.sa-static-key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.sa-static-key.secret_key}"
  skip_region_validation      = true
  skip_credentials_validation = true
  }
}
EOT
}

