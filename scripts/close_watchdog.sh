#!/bin/sh

killall -9 watchdog bycam smarthome
devmem 0x20040c00 32 0x1ACCE551
devmem 0x20040008 32 0
