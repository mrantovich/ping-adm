#!/bin/bash

# НЕОБХОДИМЫЕ ПЕРЕМЕННЫЕ.
# IP-адреса серверов, которые пингуются, добавлять через пробел внутри скобок.
IP_ADDRESSES=("dsk-stolica.ru" "82.146.41.70" "192.168.1.22" "kkkkkkkk.ru") 
# Для команды ping: пинговать один раз.
COUNT=1
# Таймаут задержки между вызовами основной функции. Для цикла.
TIMEOUT=5s
# Массив, хранящий список серверов, которые пингуются с ошибкой.
# Нужен, чтобы слать уведомления по email.
HAS_ERROR=()

###

# Шаблоны для формирования HTML-кода.
TEMPLATE_SERVER_NAME='<div class="servers__item"><div class="servers__name">'
TEMPLATE_SERVER_STATUS_OK='<div class="servers__status">'
TEMPLATE_SERVER_STATUS_DOWN='<div class="servers__status status__down">'

#
OUTPUT=""

###

function server_ping() {
    ping -c $COUNT $1 > /dev/null 2>&1;
    result=$?

    # Если команда ping закончилась с ошибкой (код не ноль),
    # то добавляем IP-адрес в массив HAS_ERROR
    # и отправляем email с предупреждением.
    if [ "$result" -ne 0 ]; then
        OUTPUT+='{"server": "'$1'", "status": "down"},'
        #OUTPUT+=$TEMPLATE_SERVER_NAME$1"</div>"$TEMPLATE_SERVER_STATUS_DOWN"DOWN</div></div>"
        if [[ " ${HAS_ERROR[@]} " =~ $1 ]]; then
            echo "No send mail"
        else
            HAS_ERROR+=($1)
            #echo "Server $1 is DOWN!
#PING command ends with error.
#Please, check your server $1!" | mail -s "PING server error" -r rms@dsk-stolica.ru rms@dsk-stolica.ru
        fi
    # Если команда ping завершилась успешно (код ноль),
    # то проверяем наличие сервера в массиве HAS_ERROR,
    # чтобы отправить email о том, что сервер снова доступен.
    else
        OUTPUT+='{"server": "'$1'", "status": "ok"},'
        #OUTPUT+=$TEMPLATE_SERVER_NAME$1"</div>"$TEMPLATE_SERVER_STATUS_OK"OK</div></div>"
        DELETE=($1)
        if [[ " ${HAS_ERROR[@]}" =~ $1 ]]; then
            HAS_ERROR=(${HAS_ERROR[@]/$DELETE})
            #echo "Server $1 is now AVAILABLE!" | mail -s "PING server is OK" -r rms@dsk-stolica.ru rms@dsk-stolica.ru
        fi
    fi

    # Просто выводит массив HAS_ERROR в консоль.
    # Для проверки. Можно удалить.
    if [[ "$HAS_ERROR" ]]; then
        echo ${HAS_ERROR[@]}
    fi

    #
}

# Цикл, запускающий функцию server_ping.
# Задержка задается в переменной TIMEOUT (см. выше).
while true; do
    for IP in "${IP_ADDRESSES[@]}"; do
        server_ping $IP
    done
    FINOUTPUT=${OUTPUT::-1}
    FINOUTPUT='['$FINOUTPUT']'
    echo $FINOUTPUT > server_status.json
    OUTPUT=""
    sleep $TIMEOUT
done

#echo $OUTPUT > server_status.txt
#OUTPUT=""
