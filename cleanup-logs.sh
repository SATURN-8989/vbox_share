#!/bin/bash

# Каталог для поиска логов по ТЗ 2.2.2 и 2.5.1
LOG_DIR="/var/log/billing"

# Флаг для удаления
APPLY_MODE=false

if [ "$1" == "--apply" ]; then
    APPLY_MODE=true
fi

echo "=== Анализ каталога $LOG_DIR ==="

# Проверяем, существует ли каталог
if [ ! -d "$LOG_DIR" ]; then
    echo "Ошибка: Каталог $LOG_DIR не найден. Запустите стенд!"
    exit 1
fi

# Находим логи старше 7 дней и дампы core.*
FILES=$(find "$LOG_DIR" -type f \( -mtime +7 -name "*.log" -o -name "core.*" \) ! -name "*export*" ! -path "*export*" 2>/dev/null)

if [ -z "$FILES" ]; then
    echo "Старых логов и аварийных дампов не найдено."
else
    if [ "$APPLY_MODE" = true ]; then
        echo "Режим применения (--apply). Удаление файлов:"
        echo "$FILES"
        find "$LOG_DIR" -type f \( -mtime +7 -name "*.log" -o -name "core.*" \) ! -name "*export*" ! -path "*export*" -delete 2>/dev/null
        echo "Очистка успешно завершена."
    else
        echo "Режим просмотра (без удаления). Найденные файлы:"
        echo "$FILES"
        echo "Чтобы удалить эти файлы, запустите скрипт с ключом: sudo bash cleanup-logs.sh --apply"
    fi
fi
