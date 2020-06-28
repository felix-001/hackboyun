<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [相关资源](#%E7%9B%B8%E5%85%B3%E8%B5%84%E6%BA%90)
    - [蓝奏云](#%E8%93%9D%E5%A5%8F%E4%BA%91)
    - [百度云：](#%E7%99%BE%E5%BA%A6%E4%BA%91)
    - [腾讯微云](#%E8%85%BE%E8%AE%AF%E5%BE%AE%E4%BA%91)
    - [minihttp源码地址](#minihttp%E6%BA%90%E7%A0%81%E5%9C%B0%E5%9D%80)
    - [针对ipc场景的各个soc的sdk下载地址](#%E9%92%88%E5%AF%B9ipc%E5%9C%BA%E6%99%AF%E7%9A%84%E5%90%84%E4%B8%AAsoc%E7%9A%84sdk%E4%B8%8B%E8%BD%BD%E5%9C%B0%E5%9D%80)
- [硬件](#%E7%A1%AC%E4%BB%B6)
  - [chips](#chips)
  - [pins](#pins)
  - [UART接口定义](#uart%E6%8E%A5%E5%8F%A3%E5%AE%9A%E4%B9%89)
- [软件](#%E8%BD%AF%E4%BB%B6)
  - [PC串口工具](#pc%E4%B8%B2%E5%8F%A3%E5%B7%A5%E5%85%B7)
  - [串口设置](#%E4%B8%B2%E5%8F%A3%E8%AE%BE%E7%BD%AE)
  - [刷固件](#%E5%88%B7%E5%9B%BA%E4%BB%B6)
    - [uboot被破坏的解决办法](#uboot%E8%A2%AB%E7%A0%B4%E5%9D%8F%E7%9A%84%E8%A7%A3%E5%86%B3%E5%8A%9E%E6%B3%95)
  - [配网](#%E9%85%8D%E7%BD%91)
  - [访问openwrt页面](#%E8%AE%BF%E9%97%AEopenwrt%E9%A1%B5%E9%9D%A2)
  - [查看摄像头实时流](#%E6%9F%A5%E7%9C%8B%E6%91%84%E5%83%8F%E5%A4%B4%E5%AE%9E%E6%97%B6%E6%B5%81)
- [开发](#%E5%BC%80%E5%8F%91)
  - [开发环境搭建](#%E5%BC%80%E5%8F%91%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA)
  - [编译](#%E7%BC%96%E8%AF%91)
  - [FTP](#ftp)
  - [远程登录](#%E8%BF%9C%E7%A8%8B%E7%99%BB%E5%BD%95)
  - [运行](#%E8%BF%90%E8%A1%8C)
  - [文档](#%E6%96%87%E6%A1%A3)
  - [控制灯](#%E6%8E%A7%E5%88%B6%E7%81%AF)
  - [ADC](#adc)
  - [GPIO](#gpio)
  - [PWM](#pwm)
  - [WATCHDOG](#watchdog)
  - [CC2530刷固件](#cc2530%E5%88%B7%E5%9B%BA%E4%BB%B6)
- [about author](#about-author)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# 相关资源
### 蓝奏云
链接：https://jasonxy.lanzous.com/b015dy82j
密码:53r2
### 百度云：
链接：https://pan.baidu.com/s/1MHCT43-UjTineSUwziBUIA
提取码：37s2 
### 腾讯微云
链接：https://share.weiyun.com/5A5d1Tv
密码：7h47ib

### minihttp源码地址
[minihttp](https://github.com/chertov/hi_minihttp.git)

### 针对ipc场景的各个soc的sdk下载地址
[soc-sdks](https://dl.openipc.org/SDK/)
 
# 硬件
## chips
- **CPU:** Hi3518EV200
- **WIFI:** RTL8188ETV
- **ZIGBEE:** CC2530 + 2401C射频前端
- **SENSOR:** OV9732

## pins
- 摄像头正面红绿双色指示灯  

LED_G|L1 | GPIO8_0 |
--- | --- | ----
LED_R | F2 | GPIO7_4

- 红外灯

| IR_EN|K2 | SAR_ADC_CH1/GPIO7_7 |
--- | --- | ----

- 灯板7P排针

| pin1|RS1 | -引脚  | K1 | SAR_ADC_CH0/GPIO7_6 | 红外接收 |
--- | --- | ---- | --- | ---| ---
| pin2|RS1 | +引脚  | 3.3V | 电源 |  |
| pin3|双色LED公共端 | |  |  |  |
| pin4|LED_G | |  |  |  |
| pin5|LED_R | |  |  |  |
| pin6|IR_LED- | |  |  |  |
| pin7|IR_LED+ | |  |  |  |

- IR_CUT

红线 | 接LDO | 2.8V |
--- | ---| ---
黑线 | AE1511 | 4脚 |
 | AE1511 | 3脚 | J1 | GPIO0_1


- ZIGBEE排针

| pin1 | | VCC | | |
---|---|---|---|---
| pin2 | nc | | CC2530 | P2_2
| pin3 |  |GND | | |
| pin4 |  | GND| | |
| pin5 | d14 |  UART1_RXD | CC2530 | P0_3| 
| pin6 | nc | | CC2530 | P2_1
| pin7 | e14 | UART1_TXD | CC2530 | P0_2
| pin8 | f1 | GPIO7_5 | CC2530_RST | | 

- 按键

| KEY|N3 | GPIO0_2 |
--- | --- | ----

## UART接口定义
![uart](./images/boyun-uart.png)

# 软件
## PC串口工具

平台 | 工具
---|---
linux | minicom
Mac | screen/minicom
Windows | [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) 

## 串口设置
- **波特率**： 115200
- **bits**： 8
- **奇偶校验**： none
- **停止位**： 1
- **流控**： none



## 刷固件
1. 下载固件包[firmware-20200420.tar.gz](https://github.com/felix-001/hackboyun/raw/master/firmware/firmware-20200420.tar.gz)
2. sd卡格式化为`fat32`
3. 解压，拷贝到sd卡根目录
  ```
  tar zxvf firmware-20200420.tar.gz
  ```
4. sd卡插到摄像头,上电时按回车键中断进入uboot
5. 烧写uboot
  ```
  sf probe 0
  sf lock 0
  fatload mmc 0 0x82000000 u-boot.20200419.bin
  sf erase 0x0 0x80000
  sf write 0x82000000 0x0 $(filesize)
  reset
  ```
6. reset后,等待新uboot启动,并自动烧写`kernel`和`rootfs`
7. 烧写完毕后需要拔下sd卡，以免下次上电再次烧写

- [Lexsion的罗嗦版刷固件教程](./doc/Boyun_FlashFirmware.md)

### uboot被破坏的解决办法
- 使用`hitool`烧写uboot，详细使用手册见[hitool使用手册](./doc/tools)
- 参考[博云救砖教程](./doc/tools/博云救砖教程.docx)

## 配网
- 设置ssid和passwd
```
vi /etc/config/wireless
```
将`OpenWrt`和`1234567890`替换成自己的
- 【option hwmode '11g'】改为【option hwmode '11ng'】，实测速度由400KB升至3M左右
- 联网
```
wifi
```

## 访问openwrt页面
浏览器访问`http://your-camera-ip`

## 查看摄像头实时流
- 通过mjpeg的方式  
浏览器访问`http://your-camera-ip:8080/mjpeg`
- 通过rtsp的方式
  - 电脑或手机安装vlc
  - 启动vlc，选择open network...
  - 输入如下地址：`rtsp://your-camera-ip:554/test.264`
- 通过mp4的方式  
浏览器访问`http://your-camera-ip:8080/video.mp4`

# 开发

## 开发环境搭建
- 下载交叉编译工具链`arm-openwrt-linux-gcc.tar.gz`,并安装
```
tar zxvf arm-openwrt-linux-gcc.tar.gz -C /opt
```
- 设置环境变量
```
echo "export PATH=$PATH:/opt/arm-openwrt-linux-gcc/bin" >> ~/.bashrc
source ~/.bashrc
```

## 编译
```
mkdir build
cd build
cmake ..
make
```

目前kernel没有使能NFS，但是fs带了`curl`， 目前比较快的调试办法是PC搭一个http server，程序编译好后，使用curl去下载可执行文件.后面有介绍使用`scp`拷贝可执行文件到开发板的教程，要比curl的方式更方便一些。
- curl下载
```
curl http://your-pc-ip:/your-exe > your-exe
```
- 快速搭建http server
```
python -m SimpleHTTPServer 
```
## FTP
摄像头开启ftp:
```
tcpsvd -vE 0.0.0.0 21 ftpd /your/ftp/path
```
用户名:`root` 密码: none

## 远程登录
- 首先进入如下界面
```
your-camera-ip/cgi-bin/luci/;stok=d603577edf02305cce224e5c51442078/admin/system/admin
```
-  进行如下设置
   - **interface**选择`LAN`
   - 勾选`Password authentication`
   - 勾选`Allow root logins with password`
- 查看本机的ssh public key
```
cat ~/.ssh/id_rsa.pub
```
- 将`id_rsa.pub`的内容拷贝到`SSH-Keys`
- 点击`Save&Apply`
- 在pc终端执行:
```
ssh root@your-camera-ip
```
- scp拷贝
```
scp your-file root@your-camera-ip:~/
```

## 运行
- 拷贝`app`到摄像头
```
scp app root@your-camera-ip:~
```

- 运行
```
killall minihttp
cd ~
./app &
```

## 文档  
- [OV9732](./doc/sensor)
- [CC2530](./doc/zigbee)
- [救砖教程](./doc/tools/博云救砖教程.docx)

## 控制灯
/sys/devices/dev:gpio7/gpio/gpio62

## ADC
adc相关操作写成了shell脚本:`scripts/adc.sh`

## GPIO
gpio相关操作:`scripts/gpio.sh`

## PWM
pwm相关操作: `scripts/pwm.sh`

## WATCHDOG
关闭看门狗： `scripts/close_watchdog.sh`

## CC2530刷固件
- https://github.com/wavesoft/CCLib

# about author
treeswayinwind@gmail.com
