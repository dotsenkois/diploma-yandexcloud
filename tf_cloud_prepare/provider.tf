
provider "yandex" {
  zone = "ru-central1-c"
  folder_id = file("../yc_folders/bucket")

  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

