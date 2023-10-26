#!/bin/bash

# НЕОБХОДИМЫЕ ПЕРЕМЕННЫЕ.
# IP-адреса серверов, которые пингуются, добавлять через пробел внутри скобок.
IP_ADDRESSES=("https://dsk-stolica.ru" "82.146.41.70" "192.168.1.22" "http://дск-столица.мой-бизнес.рф/index_.php") 
# Для команды ping: пинговать один раз.
COUNT=1
# Таймаут задержки между вызовами основной функции. Для цикла.
TIMEOUT=30s
# Массив, хранящий список серверов, которые пингуются с ошибкой.
# Нужен, чтобы слать уведомления по email.
HAS_ERROR=()

# Для формирования данных, которые пишем в JSON, чтобы отображать в HTML.
OUTPUT=""

###

function server_check() {
    result=`curl -s -o /dev/null -w "%{http_code}" $1`

    # Если команда curl вернула ошибку (код возврата не 200),
    # то добавляем IP-адрес в массив HAS_ERROR
    # и отправляем email с предупреждением.
    if [ "$result" -ne 200 ]; then
        if [ "$result" -ne 401 ]; then
            OUTPUT+='{"server": "'$1'", "status": "down", "req": "'$result'"},'
            if [[ " ${HAS_ERROR[@]} " =~ $1 ]]; then
                echo "No send mail"
            else
                HAS_ERROR+=($1)
                echo "Server $1 is DOWN!
PING command ends with error.
Please, check your server $1!" | mail -s "PING server $1 error" -r rms@dsk-stolica.ru rms@dsk-stolica.ru
            fi
        else
            OUTPUT+='{"server": "'$1'", "status": "ok", "req": "'$result'"},'
        fi
    # Если команда curl завершилась (код ноль),
    # то проверяем наличие сервера в массиве HAS_ERROR,
    # чтобы отправить email о том, что сервер снова доступен.
    else
        OUTPUT+='{"server": "'$1'", "status": "ok", "req": "'$result'"},'
        DELETE=($1)
        if [[ " ${HAS_ERROR[@]}" =~ $1 ]]; then
            HAS_ERROR=(${HAS_ERROR[@]/$DELETE})
            echo "Server $1 is now AVAILABLE!" | mail -s "PING server $1 is OK" -r rms@dsk-stolica.ru rms@dsk-stolica.ru
        fi
    fi

}

# Цикл, запускающий функцию server_check.
# Задержка задается в переменной TIMEOUT (см. выше).
while true; do
    for IP in "${IP_ADDRESSES[@]}"; do
        server_check $IP
    done

    # Приводим сформированные данные к формату JSON.
    # Обрезаем последний символ (запятую) и загоняем данные в квадратные скобки.
    FINOUTPUT=${OUTPUT::-1}
    FINOUTPUT='['$FINOUTPUT']'

    # Пишем данные в файл. Локацию необходимо устанавливать.
    # Доступ к этому файлу должен быть из JS-скрипта, выводящего данные.
    echo $FINOUTPUT > /var/www/ping/server_status.json
    
    # Очистка данных, чтобы писать заново при новом проходе цикла.
    OUTPUT=""

    sleep $TIMEOUT
done

