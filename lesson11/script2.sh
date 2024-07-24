#!/bin/bash
# Директория для работы
DIR="$HOME/myfolder"
# Запускается скрипт чтобы избежать ошибок
./script1.sh
# Определяет, как много файлов создано в папке myfolder
COUNT=$(find "$DIR" -type f | wc -l)
echo found "$COUNT" files
#Исправляет права второго файла с 777 на 664
chmod 664 "$DIR"/file2
#Определяет пустые файлы и удаляет их
find "$DIR" -type f -empty -exec rm {} +
#Удаляет все строки кроме первой в остальных файлах
find "$DIR" -type f -print0 | xargs -I % sed -i '1!d' %
