#!/bin/bash
sleep 10
a=`pidof conky`
j=0
if [ -z "$a" ];then
    conky
else
    for i in $a; do
        ((j++))
        if [ "$j" -gt 1 ]; then
            kill $i
            echo "Killed extra conky process: $i"
        fi
    done
fi
