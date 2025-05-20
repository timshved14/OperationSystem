#!/bin/bash

# Проверка наличия аргументов
if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <исходная_директория> <резервная_директория>"
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"
LOG_FILE="image_backup.log"

# Поддерживаемые форматы изображений
IMAGE_EXTS=("jpg" "jpeg" "png" "gif" "bmp" "tiff" "svg")

# Создаем резервную директорию, если её нет
mkdir -p "$BACKUP_DIR"

# Очищаем старый лог-файл
> "$LOG_FILE"

echo "Начало резервного копирования изображений: $(date)" | tee -a "$LOG_FILE"
echo "Источник: $SOURCE_DIR" | tee -a "$LOG_FILE"
echo "Резервная копия: $BACKUP_DIR" | tee -a "$LOG_FILE"

# Счетчики
TOTAL_FOUND=0
COPIED=0
SKIPPED=0

# Поиск и копирование изображений
for ext in "${IMAGE_EXTS[@]}"; do
    while IFS= read -r -d $'\0' file; do
        ((TOTAL_FOUND++))
        filename=$(basename "$file")
        dest="$BACKUP_DIR/$filename"
        
        if [ -f "$dest" ]; then
            echo "Файл уже существует, пропускаем: $filename" | tee -a "$LOG_FILE"
            ((SKIPPED++))
        else
            cp "$file" "$dest"
            echo "Скопировано: $filename" | tee -a "$LOG_FILE"
            ((COPIED++))
        fi
    done < <(find "$SOURCE_DIR" -type f -iname "*.$ext" -print0)
done

echo "Резервное копирование завершено: $(date)" | tee -a "$LOG_FILE"
echo "Всего найдено изображений: $TOTAL_FOUND" | tee -a "$LOG_FILE"
echo "Скопировано новых: $COPIED" | tee -a "$LOG_FILE"
echo "Пропущено (уже существует): $SKIPPED" | tee -a "$LOG_FILE"