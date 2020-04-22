#!/bin/sh
#
# HI35xx simple ADC monitor

devmem 0x200F00f8 32 0
devmem 0x200b0000 32 0xff0201ff
devmem 0x200b0010 32 0x00
while true
do
    devmem 0x200b001c 32 0xf
    devmem 0x200b000c
    sleep 1
done
