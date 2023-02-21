#!/bin/bash
ips=$(hostname -I)
IPS=' ' read -r -a array <<< "$ips"
IP="${array[0]}"
s2='192'
for ip in "${array[@]}"
do
    VAR="${ip:0:3}"
    if [[ "$VAR" == "$s2" ]]
    then
        IP="$ip"
    fi
done
cleaned_text=$(echo "$IP" | sed -e 's/\r//g' -e 's/\n//g')
echo -n $cleaned_text
#echo -e CASH_MANAGER_IP