#!/bin/sh
#
# HI35xx simple pwm monitor

count=0
direction=0

devmem 0x200F00F0 32 0
devmem 0x20030038 32 2
devmem 0x20130040 32 1000

while true
do
    echo $count
	devmem 0x20130044 32 $count
	devmem 0x2013004C 32 0x05
    
    if [ $direction -eq 0 ];then
        let count=count+20
        if [ $count -ge 1000 ];then
            direction=1
        fi
    else
        let count=count-20
        if [ $count -le 0 ];then
            direction=0
        fi
    fi
	usleep 10000
done

