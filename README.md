# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:

### В начале

ВСЕ СКРИПТЫ ВЫПОЛНЯЛИСЬ НА ДИСТРИБУТИВЕ UBUNTU 20.04. РАБОТОСПОСОБНОСТЬ В ДРУГИХ ВЕРСИЯ НЕ ГАРАНТИРОВАНА.

При не желаении изменять среду совей системы возможно предверительное создание [ВМ](00.service) в отлельном каталоге ЯО

### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).
***
Подготовлена облачная инфрастукрута в ЯО при помощи Terrafrom и YC:
- Иденификатор облака указан в переменной YC_CLOUD_ID
- Токен аутентификации указан в переменной YC_TOKEN
- При запуске [entripoint.sh](./entripoint.sh):
  - создается пара ключей c именем ~/.ssh/netology и пустым паролем используемая для подключения ко всем ВМ.
  - Настраивается зеркало для скачивания провайдеров терраформ
  - запускается утилита yc, которая создает три каталога: bucket, stage, prod. Их ID сохраняются в директорию [02.yc_folders](./02.yc_folders)
    - bucket - каталог для хранения состояния terrafrom основной инфраструктуры в s3-хранилище.
    - stage - каталог для предпродуктивной инфрастурктуры. По умолчанию развертывание происходит именно в нём.
    - prod - каталог для продуктивной инфраструктуры. По умолчанию пуст.
  - В директории [01.tf_cloud_prepare](./01.tf_cloud_prepare) запускается terrafrom, создающий бакет и файл 04.tf_infrastructure_k8s_managed/backend.tf
  - Инициализируется terrafrom в директории с файлами основной инфрастуктуры [04.tf_infrastructure_k8s_managed](./04.tf_infrastructure_k8s_managed), создаются рабочие пространства, и запускается развертывание.
  - Создается кластер k8s, Jenkins-инстанс и инстанс с БД для подключения тестового приложения
***

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
- Следует использовать последнюю стабильную версию [Terraform](https://www.terraform.io/).

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
***
[04.tf_infrastructure_k8s_managed/03.k8s-sa.tf](./04.tf_infrastructure_k8s_managed/03.k8s-sa.tf)

[04.tf_infrastructure_k8s_managed/10.jenkins-sa.tf](./04.tf_infrastructure_k8s_managed/10.jenkins-sa.tf)
***
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: [Terraform Cloud](https://app.terraform.io/)  
   б. Альтернативный вариант: S3 bucket в созданном ЯО аккаунте
   ***
   [01.tf_cloud_prepare/cloud_prepare.tf](./01.tf_cloud_prepare/cloud_prepare.tf)
   ***
3. Настройте [workspaces](https://www.terraform.io/docs/language/state/workspaces.html)  
   а. Рекомендуемый вариант: создайте два workspace: *stage* и *prod*. В случае выбора этого варианта все последующие шаги должны учитывать факт существования нескольких workspace.  
   ***
   [entripoint.sh](./entripoint.sh) function 04.tf_infrastructure()
   ***
   б. Альтернативный вариант: используйте один workspace, назвав его *stage*. Пожалуйста, не используйте workspace, создаваемый Terraform-ом по-умолчанию (*default*).
4. Создайте VPC с подсетями в разных зонах доступности.
***
   [04.tf_infrastructure_k8s_managed/00.ipcalc.txt](./04.tf_infrastructure_k8s_managed/00.ipcalc.txt)

   [04.tf_infrastructure_k8s_managed/00.network.tf](./04.tf_infrastructure_k8s_managed/00.network.tf)

   [04.tf_infrastructure_k8s_managed/03.k8s-subnets.tf](./04.tf_infrastructure_k8s_managed/03.k8s-subnets.tf)
   
   [04.tf_infrastructure_k8s_managed/02.db-subnet.tf](./04.tf_infrastructure_k8s_managed/02.db-subnet.tf)
   
   [04.tf_infrastructure_k8s_managed/10.CICD-subnet.tf](./04.tf_infrastructure_k8s_managed/10.CICD-subnet.tf)

***
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать региональный мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  ***
   [04.tf_infrastructure_k8s_managed/03.k8s-subnets.tf](./04.tf_infrastructure_k8s_managed/03.k8s-subnets.tf)

   [04.tf_infrastructure_k8s_managed/03.k8s-cluster.tf](./04.tf_infrastructure_k8s_managed/03.k8s-cluster.tf)

   [04.tf_infrastructure_k8s_managed/03.k8s-config.tf](./04.tf_infrastructure_k8s_managed/03.k8s-config.tf)

   [04.tf_infrastructure_k8s_managed/03.k8s-key.tf](./04.tf_infrastructure_k8s_managed/03.k8s-key.tf)
   
   [04.tf_infrastructure_k8s_managed/03.k8s-node-group.tf](./04.tf_infrastructure_k8s_managed/03.k8s-node-group.tf)

   [04.tf_infrastructure_k8s_managed/03.k8s-sa.tf](./04.tf_infrastructure_k8s_managed/03.k8s-sa.tf)

  ***
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
***
[.kuber]([./.kuber)
***
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.
***
[04.tf_infrastructure_k8s_managed/03.k8s-config.tf](./04.tf_infrastructure_k8s_managed/03.k8s-config.tf)

[.kuber/get-staticconfig.sh](./.kuber/get-staticconfig.sh)
***

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
   ***
   [diploma-web-app](https://github.com/dotsenkois/diploma-web-app)
   ***
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
***
[diploma-web-app](https://github.com/dotsenkois/diploma-web-app)
***
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.
***
[registry.png](./99.images/registry.png)

[06.docker-registry.tf](./04.tf_infrastructure_k8s_managed/06.docker-registry.tf)

[registry.png](./99.images/jenkins-pipeline.png)

***

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.
***
[dotsenkois.ru](http://dotsenkois.ru)
***
Рекомендуемый способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте в кластер [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры.

Альтернативный вариант:
1. Для организации конфигурации можно использовать [helm charts](https://helm.sh/)

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
***
[06.k8s](./06.k8s)
***
2. Http доступ к web интерфейсу grafana.
***
[grafana.dotsenkois.ru](http://grafana.dotsenkois.ru/login)
***
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
***
[99.images/grafana-dasboards.png](./99.images/grafana-dasboards.png)
***

4. Http доступ к тестовому приложению.
***
[dotsenkois.ru](http://dotsenkois.ru/)
***

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
***
[webhook](./99.images/webhook.png)
***
2. Автоматический деплой нового docker образа.
***

***

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
***
[jenkins](http://jenkins.dotsenkois.ru/login?from=%2F)
***
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
***
***
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
***
[04.tf_infrastructure_k8s_managed](./04.tf_infrastructure_k8s_managed)
***
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud.
***
Не испоьзуется
***
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
***
Испольуется Managed Kubernetes kluster
***
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
***
[diploma-web-app](https://github.com/dotsenkois/diploma-web-app)

[diploma-web-app_backend](https://hub.docker.com/repository/docker/dotsenkois/diploma-web-app_backend)

[diploma-web-app_frontend](https://hub.docker.com/repository/docker/dotsenkois/diploma-web-app_frontend)

***
5. Репозиторий с конфигурацией Kubernetes кластера.
***
[06.k8s](./06.k8s)
***
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
***
[Приложение](http://dotsenkois.ru/)

[grafana](http://grafana.dotsenkois.ru/login)

***
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)
***
[diploma-web-app](https://github.com/dotsenkois/diploma-web-app)

[diploma-yandexcloud](https://github.com/dotsenkois/diploma-yandexcloud)
***

---
## Как правильно задавать вопросы дипломному руководителю?

Что поможет решить большинство частых проблем:

1. Попробовать найти ответ сначала самостоятельно в интернете или в 
  материалах курса и ДЗ и только после этого спрашивать у дипломного 
  руководителя. Скилл поиска ответов пригодится вам в профессиональной 
  деятельности.
2. Если вопросов больше одного, то присылайте их в виде нумерованного 
  списка. Так дипломному руководителю будет проще отвечать на каждый из 
  них.
3. При необходимости прикрепите к вопросу скриншоты и стрелочкой 
  покажите, где не получается.

Что может стать источником проблем:

1. Вопросы вида «Ничего не работает. Не запускается. Всё сломалось». 
  Дипломный руководитель не сможет ответить на такой вопрос без 
  дополнительных уточнений. Цените своё время и время других.
2. Откладывание выполнения курсового проекта на последний момент.
3. Ожидание моментального ответа на свой вопрос. Дипломные руководители работающие разработчики, которые занимаются, кроме преподавания, 
  своими проектами. Их время ограничено, поэтому постарайтесь задавать правильные вопросы, чтобы получать быстрые ответы :)