#!/bin/bash

# Ваша задача написать к этому файлу с логами несколько команд и упаковать их в .sh скрипт, а именно - 

# Подсчитать общее количество запросов.
# Подсчитать количество уникальных IP-адресов. Строго с использованием awk.
# Подсчитать количество запросов по методам (GET, POST и т.д.). Строго с использованием awk.
# Найти самый популярный URL. Строго с использованием awk.
# Создать отчет в виде текстового файла. Название текстового файла - report.txt

# Имя анализируемого файла
file_name="./access.log"

# Имя выходного файла
out_name="report.txt"

# Очишаем файл
> $out_name

# Подсчет общего количетсво запросов на основе строк
echo Общее количество запросов:     $(cat $file_name | wc -l) >> $out_name

# Получение уникальных IP-адресов из файла access.log с использованием awk
unique_ips=$(awk '{print $1}' access.log | sort | uniq | wc -l)

echo Количество уникальных IP-адресов     $unique_ips >> $out_name

echo Количество запросов по методам: >> $out_name

# Подсчет запросов по методам с использованием awk
awk '{ 
            # Извлекаем метод, удаляя начальную и конечную кавычки
            method = substr($6, 2, length($6) - 1) 
            count[method]++ 
            } 
        END { 
        for (method in count) { 
            print "   " count[method], method
        } 
    }' access.log >> $out_name


# Находим самый популярный URL с использованием awk
popular_url=$(awk '{urls[$7]++;} END {
                    for (url in urls) {
                            if (max_count < urls[url]) {
                                max_count = urls[url]; popular_url = url;
                            }
                        } print "  " max_count " - " popular_url
                    }' access.log) 

# Выводим самый популярный URL
echo "Самый популярный URL: $popular_url" >> $out_name

# Сообщение об выполнении
echo "Ответ сохранен в файле $out_name"