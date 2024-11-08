# Ansible Playbook for Installing Clickhouse, Vector and Lighthouse

## Описание

Этот Ansible playbook предназначен для установки и настройки Clickhouse и Vector на целевых серверах. 

## Предварительные требования

Перед запуском playbook убедитесь, что выполнены следующие требования:

- Ansible версии 2.9 или выше установлен на контроллере.
- Управляемые узлы настроены и могут быть достигнуты через SSH.
- Имеется доступ к интернету для загрузки пакетов.

## Переменные

- `clickhouse_version`: Версия Clickhouse, которую следует установить. Задается в playbook или в инвентори файле.
- `clickhouse_packages`: Список пакетов Clickhouse для установки. Обычно включает `clickhouse-server`, `clickhouse-client` и `clickhouse-common-static`.

## Инструкции по установке

1. **Cклонируйте репозиторий:**

```shell
   git clone https://github.com/SergueiMoscow/Ansible_03.git
   cd Ansible_03
```

2. **Подготовьте инвентори файл:**

### Docker - для тестирования и развёртывания в контейнерах в локальном окружении
В директории `prepare_hosts_docker` запустить `docker compose up -d`. Будут созданы и запущены 3 контейнера.
Запуск playbook в этом случае из директории playbook - `ansible-playbook -i inventory/containers.yml site.yml`

### Yandex Cloud
#### Подготовить доступ к Yandex Cloud:
- Файл ключей сервисного аккаунта должен находиться в файле ~/.yc_authorized_key.json
- В файле [personal.auto.tfvars](prepare_hosts_yc/personal.auto.tfvars) прописать свои значения переменных
#### Созздать виртуальные машины
- В директории `prepare_hosts_yc` запустить `terraform init`, затем `terraform apply`. Будут созданы 3 виртуалные машины и файл `inventory/prod.yml` в качестве inventory файла для ansible


Проверьте целевые хосты, в файле инвентори, например [`prod.yml`]`inventory/prod.yml`:
```yml
clickhouse:
  hosts:
    clickhouse_yc:
      ansible_host: 62.84.114.84
      ansible_user: vm_user
```


3. **Запуск playbook:**

   Выполните команду для запуска playbook:

```shell
   ansible-playbook -i inventory.ini playbook.yml
```
   
## Роли и задачи

- **Установка Clickhouse:**
  - Скачивает необходимые пакеты.
  - Устанавливает их с помощью `yum`.
  - Создаёт базу данных `logs`.

- **Установка Vector:**
  - Загружает и запускает скрипт для добавления репозитория.
  - Устанавливает Vector из репозитория.
  - Создаёт и активирует systemd сервис для Vector.

- **Установка Lighthouse:**
  - Загружает Lighthouse из репозитория.
  - Устанавливает и настраивает Nginx для доступа к Lighthouse

## Обработка ошибок

В playbook предусмотрены механизмы для обработки ошибок при загрузке пакетов Clickhouse. В случае неудачи с основных зеркал, playbook пытается загрузить резервный пакет.
