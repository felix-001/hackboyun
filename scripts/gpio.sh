#!/bin/sh
#
# ZFT Lab. 2018 | https://zftlab.org/pages/2018020900.html
# HI35xx simple GPIO monitor


cmd="$1"
per="$2"
ctl="/sys/class/gpio/gpio"

devmem 0x200F00F0 32 0x01

basic(){
  clear
  hardware=$(awk -F ': ' '/Hardware/ {print $2} 'cat /proc/cpuinfo)
  if [[ "${hardware}" == 'hi3518' ]]; then
    ircut1="1"
    ircut2="1"
    key="2"
    irsensor="62"
    gled="60"
    irled="63"
    rled="64"
    maxgpio="95"
  elif [[ "${hardware}" == 'hi3518ev200' ]]; then
    ircut1="1"
    ircut2="1"
    key="2"
    irsensor="62"
    gled="60"
    irled="63"
    rled="64"
    maxgpio="71"
  fi
}

help() {
  echo -e "\nYou SoC on board - ${hardware}\n"
  echo -e "MaxGPIO: ${maxgpio} | IRCUT: ${ircut1} | IR_LED: ${irled} | GREEN_LED: ${gled} | RED_LED: ${rled}| KEY: ${key}| IR_SENSOR: ${irsensor}\n"
  echo -e "Please select command:\n"
  echo " gpio ircut_on"
  echo " gpio ircut_off"
  echo " gpio ir_on"
  echo " gpio ir_off"
  echo " gpio green_on"
  echo " gpio green_off"
  echo " gpio red_on"
  echo " gpio red_off"
  echo " gpio key"
  echo " gpio irsensor"
  echo " gpio info"
  echo " gpio debug"
  echo " gpio search"
  echo ""
}

debug() {
  echo "Mount DEBUGFS and get info about all GPIO"
  [ -f /sys/kernel/debug/gpio ] || mount -t debugfs none /sys/kernel/debug >/dev/null 2>&1
  [ -f /sys/kernel/debug/gpio ] && watch -n2 "cat /sys/kernel/debug/gpio"
}

info() {
  echo "Mount DEBUGFS and get info about all GPIO"
  [ -f /sys/kernel/debug/gpio ] || mount -t debugfs none /sys/kernel/debug >/dev/null 2>&1
  [ -f /sys/kernel/debug/gpio ] && awk '/gpio-/ {print $1,$4,$5}' /sys/kernel/debug/gpio
}

ircut_on() {
  echo "Probe set IRCUT to ON"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${ircut1} ] && echo ${ircut1} >/sys/class/gpio/export
  [ -f ${ctl}${ircut1}/direction ] && echo out > ${ctl}${ircut1}/direction && \
    (echo 0 >${ctl}${ircut1}/value ; usleep 250 ; echo 1 >${ctl}${ircut1}/value)
}

ircut_off() {
  echo "Probe set IRCUT to OFF"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${ircut2} ] && echo ${ircut2} >/sys/class/gpio/export
  [ -f ${ctl}${ircut2}/direction ] && echo out > ${ctl}${ircut2}/direction && \
    (echo 0 >${ctl}${ircut2}/value ; usleep 250 ; echo 0 >${ctl}${ircut2}/value)
}

ir_on() {
  echo "Probe set IR_LED to ON"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${irled} ] && echo ${irled} >/sys/class/gpio/export
  [ -f ${ctl}${irled}/direction ] && echo out > ${ctl}${irled}/direction && \
    (echo 0 >${ctl}${irled}/value ; usleep 250 ; echo 1 >${ctl}${irled}/value)
}

ir_off() {
  echo "Probe set IR_LED to OFF"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${irled} ] && echo ${irled} >/sys/class/gpio/export
  [ -f ${ctl}${irled}/direction ] && echo out > ${ctl}${irled}/direction && \
    (echo 0 >${ctl}${irled}/value ; usleep 250 ; echo 0 >${ctl}${irled}/value)
}

green_on() {
  echo "Probe set GREEN_LED to ON"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${gled} ] && echo ${gled} >/sys/class/gpio/export
  [ -f ${ctl}${gled}/direction ] && echo out > ${ctl}${gled}/direction && \
    (echo 0 >${ctl}${gled}/value ; usleep 250 ; echo 0 >${ctl}${gled}/value)
}

green_off() {
  echo "Probe set GREEN_LED to OFF"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${gled} ] && echo ${gled} >/sys/class/gpio/export
  [ -f ${ctl}${gled}/direction ] && echo out > ${ctl}${gled}/direction && \
    (echo 0 >${ctl}${gled}/value ; usleep 250 ; echo 1 >${ctl}${gled}/value)
}

red_on() {
  echo "Probe set REF_LED to ON"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${rled} ] && echo ${rled} >/sys/class/gpio/export 
  [ -f ${ctl}${rled}/direction ] && echo out > ${ctl}${rled}/direction && \
    (echo 0 >${ctl}${rled}/value ; usleep 250 ; echo 0 >${ctl}${rled}/value)
}

red_off() {
  echo "Probe set REF_LED to OFF"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${rled} ] && echo ${rled} >/sys/class/gpio/export
  [ -f ${ctl}${rled}/direction ] && echo out > ${ctl}${rled}/direction && \
    (echo 0 >${ctl}${rled}/value ; usleep 250 ; echo 1 >${ctl}${rled}/value)
}

key() {
  echo "Probe get KEY value"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${key} ] && echo ${key} >/sys/class/gpio/export
  [ -f ${ctl}${key}/direction ] && echo in > ${ctl}${key}/direction && \
    (cat ${ctl}${key}/value)
}

irsensor() {
  echo "Probe get IRSENSOR value"
  [ ! -f /sys/class/gpio/export ] && exit
  [ ! -d ${ctl}${irsensor} ] && echo ${irsensor} >/sys/class/gpio/export
  [ -f ${ctl}${irsensor}/direction ] && echo in > ${ctl}${irsensor}/direction && \
    (cat ${ctl}${irsensor}/value)
}

search() {
  echo "Start blink (output) on all gpio"
  echo ""
  for pin in $(seq 0 ${maxgpio}); do
    echo "================================="
    [ ! -f /sys/class/gpio/export ] && exit
    [ ! -d ${ctl}${pin} ] && echo ${pin} >/sys/class/gpio/export && echo "Activate in system GPIO-${pin}"
    [ -f ${ctl}${pin}/direction ] && echo out >${ctl}${pin}/direction && echo "  Set GPIO-${pin} to OUTPUT mode"
    [ -f ${ctl}${pin}/value ] && echo 0 >${ctl}${pin}/value && echo "    Set GPIO-${pin} to LO level" ; sleep 1
    [ -f ${ctl}${pin}/value ] && echo 1 >${ctl}${pin}/value && echo "    Set GPIO-${pin} to HI level" ; sleep 1
    [ -f ${ctl}${pin}/direction ] && echo in >${ctl}${pin}/direction && echo "  Set GPIO-${pin} to INPUT mode"
    #[ -d ${ctl}${pin} ] && echo ${pin} >/sys/class/gpio/unexport && echo "Remove from system GPIO-${pin}"
  done
}

blink() {
  echo "Start blink (output) on selected gpio"
  [ ! -f /sys/class/gpio/export ] && exit
  while [ true ]; do
    echo "================================="
    [ ! -d ${ctl}${per} ] && echo ${per} >/sys/class/gpio/export && echo "Activate in system GPIO-${per}"
    [ -f ${ctl}${per}/direction ] && echo out >${ctl}${per}/direction && echo "  Set GPIO-${per} to OUTPUT mode"
    [ -f ${ctl}${per}/value ] && echo 0 >${ctl}${per}/value && echo "    Set GPIO-${per} to LO level" ; sleep 1
    [ -f ${ctl}${per}/value ] && echo 1 >${ctl}${per}/value && echo "    Set GPIO-${per} to HI level" ; sleep 1
    [ -f ${ctl}${per}/direction ] && echo in >${ctl}${per}/direction && echo "  Set GPIO-${per} to INPUT mode"
    [ -d ${ctl}${per} ] && echo ${per} >/sys/class/gpio/unexport && echo "Remove from system GPIO-${per}"
  done
}


basic
if [ $# -ge 1 ]; then
  ${cmd}
else
  help
fi

