provider "yandex" {
  zone = "ru-central1-a"
  folder_id = local.folder_id

  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

