### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---------

# 1 ОТВЕТ Создание облачной инфраструктуры

Подготовил Terraform

![изображение](https://github.com/user-attachments/assets/dfeb935e-08c9-46d7-8fc8-482b8cbbb1f0)

Подготовил конфигурацию Terraform [(конфигурация в корне)](https://github.com/Vadim-Nazarov/diplom/tree/main/dip)

Terraform plan

![изображение](https://github.com/user-attachments/assets/b76e5e5e-55d3-436a-9b56-c922fe4b176b)

Terraform apply

![изображение](https://github.com/user-attachments/assets/d17c4f43-dcd4-4ddb-bd97-850e15cbb7d6)

Итог выполнения

Созданы ВМ , сети, сервис аккаунт, ключ, бакет, в бакете стейт

![изображение](https://github.com/user-attachments/assets/071ce669-73d8-40a9-9d11-25c581e947f3)

![изображение](https://github.com/user-attachments/assets/79fd7653-3092-4c35-93e8-a5cf03f82c0d)

Сети

![изображение](https://github.com/user-attachments/assets/25234db6-f542-4842-9740-c3c11e4e7196)

Бакет 

![изображение](https://github.com/user-attachments/assets/50f22acd-1a59-4197-8b2b-569984b3b72e)

-----

### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)


# 2 ОТВЕТ Создание Kubernetes кластера

Выбрал рекомендуемый вариант 

На предыдущем шаге подготовил инфраструктуру для разворачивания kubernetes кластера и файл [hosts.yml](https://github.com/Vadim-Nazarov/diplom/blob/main/dip/ansible/inventory/hosts.yaml)

Клонирую репозиторий:

    git clone https://github.com/kubernetes-sigs/kubespray.git

Запускаю плайбуки в kubespray

    ansible-playbook -i /home/admin1/diplom/dip/ansible/inventory/hosts.yaml cluster.yml -b

Плейбуки отработали

![изображение](https://github.com/user-attachments/assets/ec583b4b-7df8-469c-86e8-1a45e7cbac8f)

Зашел на master и проверил запуск подов

![изображение](https://github.com/user-attachments/assets/d3133784-5100-4155-b158-7af925ed57d3)

------

### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

# 3 ОТВЕТ Создание тестового приложения

Подготовил приложение

[index.html](https://github.com/Vadim-Nazarov/diplom/blob/main/dip/app/index.html)

[Dockerfile](https://github.com/Vadim-Nazarov/diplom/blob/main/dip/app/Dockerfile)

Собрал образ

![изображение](https://github.com/user-attachments/assets/95156190-67f4-470c-9fc9-12f5ff8f4951)

Запустил контейнер

![изображение](https://github.com/user-attachments/assets/1008069d-dccb-43ed-8521-67a3320a9fbf)

![изображение](https://github.com/user-attachments/assets/b092a74c-bc67-462b-b89e-42a36c05e3cc)


Запушил в Dockerhub

![изображение](https://github.com/user-attachments/assets/58c1eb12-549a-4a71-aca5-e02e73b0c696)

![изображение](https://github.com/user-attachments/assets/f9387b08-18d7-41de-b16d-9075de55890f)

-----
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

----

# 4 ОТВЕТ по cистеме мониторинга и деплою приложения

Разворачиваю системо мониторнига с помощью Kube-Prometheus

Для этого зашел на master и клонирую репозиторий репозиторий  https://github.com/prometheus-operator/kube-prometheus.git

    git clone https://github.com/prometheus-operator/kube-prometheus.git

![изображение](https://github.com/user-attachments/assets/60c751c4-a5bb-4901-b6ee-4019a28f5486)

Перейдя в каталог с kube-prometheus и развертываю контейнеры

    sudo kubectl apply --server-side -f manifests/setup 
    sudo kubectl apply -f manifests/

<details>
![изображение](https://github.com/user-attachments/assets/a15b12a2-a216-48e8-9185-9f1259ca9650)

    ubuntu@master:~/kube-prometheus$ sudo kubectl apply -f manifests/
    alertmanager.monitoring.coreos.com/main created
    networkpolicy.networking.k8s.io/alertmanager-main created
    poddisruptionbudget.policy/alertmanager-main created
    prometheusrule.monitoring.coreos.com/alertmanager-main-rules created
    secret/alertmanager-main created
    service/alertmanager-main created
    serviceaccount/alertmanager-main created
    servicemonitor.monitoring.coreos.com/alertmanager-main created
    clusterrole.rbac.authorization.k8s.io/blackbox-exporter created
    clusterrolebinding.rbac.authorization.k8s.io/blackbox-exporter created
    configmap/blackbox-exporter-configuration created
    deployment.apps/blackbox-exporter created
    networkpolicy.networking.k8s.io/blackbox-exporter created
    service/blackbox-exporter created
    serviceaccount/blackbox-exporter created
    servicemonitor.monitoring.coreos.com/blackbox-exporter created
    secret/grafana-config created
    secret/grafana-datasources created
    configmap/grafana-dashboard-alertmanager-overview created
    configmap/grafana-dashboard-apiserver created
    configmap/grafana-dashboard-cluster-total created
    configmap/grafana-dashboard-controller-manager created
    configmap/grafana-dashboard-grafana-overview created
    configmap/grafana-dashboard-k8s-resources-cluster created
    configmap/grafana-dashboard-k8s-resources-multicluster created
    configmap/grafana-dashboard-k8s-resources-namespace created
    configmap/grafana-dashboard-k8s-resources-node created
    configmap/grafana-dashboard-k8s-resources-pod created
    configmap/grafana-dashboard-k8s-resources-workload created
    configmap/grafana-dashboard-k8s-resources-workloads-namespace created
    configmap/grafana-dashboard-kubelet created
    configmap/grafana-dashboard-namespace-by-pod created
    configmap/grafana-dashboard-namespace-by-workload created
    configmap/grafana-dashboard-node-cluster-rsrc-use created
    configmap/grafana-dashboard-node-rsrc-use created
    configmap/grafana-dashboard-nodes-aix created
    configmap/grafana-dashboard-nodes-darwin created
    configmap/grafana-dashboard-nodes created
    configmap/grafana-dashboard-persistentvolumesusage created
    configmap/grafana-dashboard-pod-total created
    configmap/grafana-dashboard-prometheus-remote-write created
    configmap/grafana-dashboard-prometheus created
    configmap/grafana-dashboard-proxy created
    configmap/grafana-dashboard-scheduler created
    configmap/grafana-dashboard-workload-total created
    configmap/grafana-dashboards created
    deployment.apps/grafana created
    networkpolicy.networking.k8s.io/grafana created
    prometheusrule.monitoring.coreos.com/grafana-rules created
    service/grafana created
    serviceaccount/grafana created
    servicemonitor.monitoring.coreos.com/grafana created
    prometheusrule.monitoring.coreos.com/kube-prometheus-rules created
    clusterrole.rbac.authorization.k8s.io/kube-state-metrics created
    clusterrolebinding.rbac.authorization.k8s.io/kube-state-metrics created
    deployment.apps/kube-state-metrics created
    networkpolicy.networking.k8s.io/kube-state-metrics created
    prometheusrule.monitoring.coreos.com/kube-state-metrics-rules created
    service/kube-state-metrics created
    serviceaccount/kube-state-metrics created
    servicemonitor.monitoring.coreos.com/kube-state-metrics created
    prometheusrule.monitoring.coreos.com/kubernetes-monitoring-rules created
    servicemonitor.monitoring.coreos.com/kube-apiserver created
    servicemonitor.monitoring.coreos.com/coredns created
    servicemonitor.monitoring.coreos.com/kube-controller-manager created
    servicemonitor.monitoring.coreos.com/kube-scheduler created
    servicemonitor.monitoring.coreos.com/kubelet created
    clusterrole.rbac.authorization.k8s.io/node-exporter created
    clusterrolebinding.rbac.authorization.k8s.io/node-exporter created
    daemonset.apps/node-exporter created
    networkpolicy.networking.k8s.io/node-exporter created
    prometheusrule.monitoring.coreos.com/node-exporter-rules created
    service/node-exporter created
    serviceaccount/node-exporter created
    servicemonitor.monitoring.coreos.com/node-exporter created
    clusterrole.rbac.authorization.k8s.io/prometheus-k8s created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    networkpolicy.networking.k8s.io/prometheus-k8s created
    poddisruptionbudget.policy/prometheus-k8s created
    prometheus.monitoring.coreos.com/k8s created
    prometheusrule.monitoring.coreos.com/prometheus-k8s-prometheus-rules created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s-config created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    rolebinding.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s-config created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    role.rbac.authorization.k8s.io/prometheus-k8s created
    service/prometheus-k8s created
    serviceaccount/prometheus-k8s created
    servicemonitor.monitoring.coreos.com/prometheus-k8s created
    apiservice.apiregistration.k8s.io/v1beta1.metrics.k8s.io created
    clusterrole.rbac.authorization.k8s.io/prometheus-adapter created
    clusterrole.rbac.authorization.k8s.io/system:aggregated-metrics-reader created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-adapter created
    clusterrolebinding.rbac.authorization.k8s.io/resource-metrics:system:auth-delegator created
    clusterrole.rbac.authorization.k8s.io/resource-metrics-server-resources created
    configmap/adapter-config created
    deployment.apps/prometheus-adapter created
    networkpolicy.networking.k8s.io/prometheus-adapter created
    poddisruptionbudget.policy/prometheus-adapter created
    rolebinding.rbac.authorization.k8s.io/resource-metrics-auth-reader created
    service/prometheus-adapter created
    serviceaccount/prometheus-adapter created
    servicemonitor.monitoring.coreos.com/prometheus-adapter created
    clusterrole.rbac.authorization.k8s.io/prometheus-operator created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus-operator created
    deployment.apps/prometheus-operator created
    networkpolicy.networking.k8s.io/prometheus-operator created
    prometheusrule.monitoring.coreos.com/prometheus-operator-rules created
    service/prometheus-operator created
    serviceaccount/prometheus-operator created
    servicemonitor.monitoring.coreos.com/prometheus-operator created
</details>

    sudo kubectl get po -n monitoring -o wide

![изображение](https://github.com/user-attachments/assets/20a9f4ec-80e5-49f9-bb31-58d6bb22b5bc)

Добавляю сетевою политику [манифест](https://github.com/Vadim-Nazarov/diplom/blob/main/dip/manifests/grafana-s.yml)

![изображение](https://github.com/user-attachments/assets/298a8b8b-3cca-40aa-aa6c-726b158cf6a6)

Теперь зайти в Grafana можно по любому из адресов node1, node2, master по 30001 порту который был указан в сетевой политике, логин/пароль admin

Данные с нод идут

![изображение](https://github.com/user-attachments/assets/fc16bb8b-8d16-448d-8d30-a4c902bfb14b)

Далее разворачиваю приложение в кластере Kubernetes на master ноде с помощью манифеста [depl_nginx.yml](https://github.com/Vadim-Nazarov/diplom/blob/main/dip/app/depl_nginx.yml)

![изображение](https://github.com/user-attachments/assets/05609afc-01ab-40dd-903f-fc2e9d0e902f)

Проверяю статус 

![изображение](https://github.com/user-attachments/assets/2ba3493d-dc39-4800-bb1f-46c16be00da9)

По всем нодам master node1 node2 есть доступ по 30100 порту до приложения 

![изображение](https://github.com/user-attachments/assets/05c5deba-a2e1-4015-9aa7-4ee9d5accd84)

### Установка и настройка CI/CD

Создал отдельный репозиторий на githab

      https://github.com/Vadim-Nazarov/nginx

Для автоматической сборки docker image и деплоя приложения при изменении кода использую Github actions

Создал Personal access token в Dockerhub

![изображение](https://github.com/user-attachments/assets/37bf758c-70a3-4566-a0e1-d66afbe1b205)

Создал секреты github секреты для доступа к DockerHub

![изображение](https://github.com/user-attachments/assets/80601137-d352-4ec6-be0f-1c45a8c93ac7)

      echo /root/.kube/config | base64 - Конфигурация доступа к кластеру

добавляю рабочие процессы GitHub Actions каталоге репозитория nginx  [cicd.yaml](https://github.com/Vadim-Nazarov/nginx/blob/main/.github/workflows/cicd.yaml) 

Вот тут сталиваюсь с ситуацией - образ докера изменяется - собирается отправляется в докер хаб, но при попытке диплоя не могу его задиплоить в кубер, не пойму как решить данную проблему, вижу что нет соединения но почему ...?

Если коммит начинается с v*, то приложение собирается, отправляется в docker hub и ставиться в кластер. [helm](https://github.com/Vadim-Nazarov/nginx/tree/main/nginxci)

![изображение](https://github.com/user-attachments/assets/40838547-bccd-4b4b-ab39-db62779331c8)

![изображение](https://github.com/user-attachments/assets/6abf8c52-ac9b-47bc-9b0d-0f3b39440b58)









































