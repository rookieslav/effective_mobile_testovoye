# Тестовая таска для мониторинга 

Мониторинг процесса `test` с отправкой HTTP-запроса.

## Возможности
- Проверка процесса `test`
- Проверка доступности `https://test.com/monitoring/test/api`
- Логирование событий
- Запуск через systemd timer
- Установка через `install.sh` или Ansible
- Удаление через `uninstall.sh`

## Быстрый старт

```bash
chmod +x install.sh
sudo ./install.sh
```

## Ansible (более практичная альтернатива)
```bash
ansible-playbook -i inventory ansible-playbook.yml -K
```

## Удаление

```bash
chmod +x uninstall.sh
sudo ./uninstall.sh
```

## Структура
- `monitor_test.sh` — основной скрипт
- `install.sh` — автоматическая установка
- `roles/systemd/` — шаблоны юнита и таймера
- `ansible-playbook.yml` — установка через Ansible
- `uninstall.sh` — автоматическое удаление
