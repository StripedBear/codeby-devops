#!/bin/bash

# Папка
DIR="$HOME/myfolder"

# Создает папку myfolder в домашней папке текущего пользователя
if  test -d "$DIR" ; then rm -rf "$DIR";
fi
mkdir "$DIR"

#Создает 5 файлов в папке:
#1 - имеет две строки: 1) приветствие, 2) текущее время и дата
touch "$DIR"/file{1..5}
echo "Hello" >> "$DIR"/file1 && date >> "$DIR"/file1
#2 - пустой файл с правами 777
chmod 777 "$DIR"/file2
#3 - одна строка длиной в 20 случайных символов
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 20 >> "$DIR"/file3
#4-5 пустые файлы
