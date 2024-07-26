#!/bin/bash
DIR="$HOME/myfolder"
./script1.sh
# Определяет, как много файлов создано в папке myfolder
count=$(find "$DIR" -type f | wc -l)
echo found "$count" files
#Исправляет права второго файла с 777 на 664
chmod 664 "$DIR"/file2
#Определяет пустые файлы и удаляет их
for file in $(find "$DIR" -type f -empty); do rm "$file"; done
#Удаляет все строки кроме первой в остальных файлах
find $DIR -type f | xargs -I % sed -i '1!d' %
