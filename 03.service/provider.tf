provider "yandex" {
  zone = "ru-central1-c"
  folder_id = local.buket_folder_id

  #Ключи сохранены в переменых среды:
  #YC_TOKEN, YC_CLOUD_ID, YC_FOLDER_ID
}

