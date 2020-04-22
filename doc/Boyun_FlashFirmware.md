# 博云摄像头刷入自定义固件

## 前言  
本文旨在以更详（luo）细（suo）的描述，引导小白入坑。如有错漏，欢迎指出。
#### **操作警告:**  
**为嵌入式设备刷入自定义固件是一个需要细心的事情。您可能会因此损坏您的设备，所以请务必小心操作！使用本指南和相关固件需要您自担风险。固件开发者和[笔者](https://lexsion.com)都不会对您设备可能发生的损坏负责。**  

## 目录：  
* 准备  
* 拆机并连接TTL线  
* 刷入新固件  
* 配置网络  

## 准备：  
1，2.5mm十字（PH0）螺丝刀；  
2，USB转TTL线；  
3，存储卡；  
4，串口工具软件（本人使用PUTTY）  

## 拆机并连接TTL线：
1，使用螺丝刀拆除底壳上的四颗螺钉（保修贴纸下有一颗）。小心打开底壳，注意不要扯断扬声器和Zigbee天线的连接线。在CC2530模块附近找到J3连接器空焊盘（3个排在一起），此处为TTL接口，此接口从方形焊盘处起，依次为GND、TXD、RXD。  
2，设法连接USB转TTL模块，可使用烙铁焊接，亦可使用杜邦线、飞机勾等测试工具做可靠连接。**将摄像头板的TXD连接到USB转串口小板的RXD，摄像头板的RXD连接到USB转串口小板的TXD，摄像头板的GND连接到USB转串口小板的GND。**  
*注：TTL是这样的，TXD意思是发送，RXD意思是接收，GND表示电路中的0V电位处，一般连接到电源的负极，VCC为电源。A和B通过TTL通信，A的发送要连接B的接收；A的接收则连接B的发送；GND作为0电位的参考，直接连接。**需要注意的是：VCC线一般不连接**，因为目标板和TTL小板的电压不一定是相同的；且TTL小板取自电脑USB口的供电，输出能力有限，可能无法提供稳定的供电。**仅当您十分清楚连接VCC后果时连接，否则可能出现损坏设备的危险！***  
3，接线检查无误，USB转TTL小板插入电脑USB口，因其有多种型号，根据不同型号的TTL转接小板，自行安装好驱动程序。笔者建议使用CH340或CP2102小板，不推荐PL2303。  
4，安装好驱动后在电脑上的计算机图标上右击，打开管理，选择设备管理器（Win10可按快捷键Win+X，然后按M键进入设备管理器）；在端口分支下查看自己的USB转TTL小板的串口端口号并记住，留作稍后连接时使用。  

## 刷入新固件  
1，将准备好的存储卡通过读卡器连接到电脑，请确保存储卡中没有重要文件，**接下来的操作将清空存储卡中已有文件**。在Windows资源管理器中右击对应盘符，选择格式化，设置文件系统为FAT32格式，勾选快速格式化，其他保持默认。点击开始，等待其格式化完成。  
*注：如果Windows系统的格式化功能没有FAT32选项，可使用Windows系统自带的Diskpart工具清空存储卡，并创建FAT32分区。按Win+R键打开运行对话框，输入`diskpart`回车，在打开的Diskpart工具窗口中输入`list disk`列出所有磁盘，找到存储卡对应的磁盘编号，输入`select disk 存储卡编号`回车选定要操作的磁盘为存储卡，输入`clean`命令清空存储卡，输入`create partition primary`创建主分区，输入`format fs=fat32 quick`快速格式化刚才创建的主分区为FAT32格式。*  
2，下载最新版本的固件，目前为[firmware-20200420.tar.gz](https://github.com/felix-001/hackboyun/tree/master/firmware)。将压缩包内的文件解压到存储卡中。安全弹出存储卡，将其插入摄像头板的存储卡插槽。  
3，打开串口终端软件，选择串口协议（Serial），端口处选择或填入刚才记下的串口号，设置波特率为115200、数据位8、停止位1、无奇偶校验、无流控。确认设置正确并再次检查接线无误后打开串口，注意关闭中文输入法。  
*笔者使用[PUTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html),下载合适版本安装并打开。在Session页面中的Connection type下选择Serial。在Category中点击进入Serial选项卡，在Select a serial line中输入上文记下的端口号，下面的Speed（baud）中填入115200，Data bits填8，Stop bits填1，Parity和Flow control皆选择None。点击Category中的Session回到Session页面，在Saved Sessions下输入一个好记的名字，点击Save保存以备下次串口意外中断后再次使用。最后检查设置无误后双击你设置的那个好记的名字打开串口，注意关闭中文输入法。*  
4，将摄像头板插电源线上电，随后开始不停按回车键。以中断uboot，不自动启动系统。直到出现类似以下内容停止按回车：  
```
Partition 1: Filesystem: FAT32 "NO NAME    "
reading update.img
read update.img sz -1 hdr 64
update.img not found
Hit any key stop autoboot :  0
hisilicon #
hisilicon #
hisilicon #
```
*注：如果5秒内没有进入这个界面，则可能中断失败了，断开摄像头板电源，使用读卡器连接电脑检查存储卡文件是否被损坏，若有损坏请重做前面操作制作存储卡升级工具。然后重新上电尝试对其中断，依然不可建议检查USB转TTL小板是否可靠连接。*  
5，依次输入以下命令，每输入一行敲回车并等待其执行完毕：  
```
sf probe 0
sf lock 0
fatload mmc 0 0x82000000 u-boot.20200419.bin
sf erase 0x0 0x80000
sf write 0x82000000 0x0 $(filesize)
reset
```

*注：以下正常回显信息供大家参考：*  
```
hisilicon # sf probe 0
16384 KiB hi_fmc at 0:0 is now current device
hisilicon # sf lock 0
unlock all block.
hisilicon # fatload mmc 0 0x82000000 u-boot.20200419.bin
reading u-boot.20200419.bin

273960 bytes read
hisilicon # sf erase 0x0 0x80000
Erasing at 0x80000 -- 100% complete.
hisilicon # sf write 0x82000000 0x0 $(filesize)
Writing at 0x42e28 -- 100% complete.
hisilicon # reset
```
6，随后摄像头板自动重启，重启后会自动开始升级，请观察串口输出，等待其升级完毕后摄像头自动进入OpenWrt。**升级过程中请勿断电,升级完成后请取下存储卡，否则下次启动会自动再次进入升级。**  
**注意：**  
**若您已经刷过之前发布的旧版系统,升级后需要在进入OpenWrt后通过TTL接口执行`firstboot`命令清空配置，然后再继续下文的网络配置，否则会出现问题。**  

*注意:*  
*u-boot,kernel,rootfs这三个文件,是自动升级使用的,不要直接手动刷入分区。*  
*如果需要自己手动将文件刷到分区,请使用以下这三个文件，手动刷入方式不在本文讨论范围内。*  
*u-boot.20200419.bin*  
*openwrt-hi35xx-18ev200-default-uImage*  
*openwrt-hi35xx-18ev200-default-root.squashfs*  

## 配置网络  
1,系统启动后，我们看到串口回显信息停止刷新时按回车键出现类似以下内容即可开始配置网络：  
```
BusyBox v1.23.2 (2020-04-19 13:20:45 CST) built-in shell (ash)


 ___                  _  ___  ___
/   \ ___  ___  _  _ | ||   \/  _|
| | ||   \/ _ \| \| || || | || |
| | || | |  __/| \\ || ||  _/| |_
\___/|  _/\___||_|\_||_||_|  \___|.ORG
     |_|


root@ByunHawkeye:/#
```
2,运行以下命令用vi编辑器打开配置文件：  
```
vi /etc/config/wireless
```
3,按i键进入插入模式（ INSERT Mode），使用上下左右键移动光标到需要编辑的位置后面，使用Backspace键删除原来内容，输入自己的网络配置。以下部分内容中的`option ssid`,`option key`和`option encryption`段需要修改为自己无线路由器的配置：  
```
config wifi-iface
        option device 'wlan0'
        option network 'wan'
        option mode 'sta'
        option ssid 'OpenWrt'
        option key '1234567890'
        option encryption 'psk2'
```
以上`option ssid`是路由器无线网的名字，`option key`是无线网密码，`option encryption`是无线网加密方式。常见加密方式有以下几种：none（开放式无加密）, wep, psk（WPA-PSK）, psk2（WPA2-PSK）。需要根据自己无线路由器使用的加密方式填写。  
4,修改完后确认无误，按ESC键退回到命令模式，输入`wq`，按回车键保存退出。  
*注：若修改过程中失误删除部分内容但并未保存，可按ESC回到命令模式后输入`q!`,按回车键不保存退出，再重新执行`vi /etc/config/wireless`打开即可。若该文件损坏丢失无法恢复其中内容，可尝试运行`firstboot`命令将系统恢复初始状态。*  
5，运行以下命令应用WIFI配置，并自动连接WIFI。  
```
wifi
```
6，通过以上方式完成配网后运行以下命令可以在`wlan0`处看到摄像头的IP地址。  
```
ifconfig
```
这样我们就可以通过浏览器输入摄像头IP访问OpenWrt管理页面，输入IP地址:8080看监控画面。  
7，执行以下命令后连续两次输入新密码，修改root密码以备SSH登陆。  
```
passwd
```
8，现在我们就可以摆脱USB转TTL线，使用SSH工具通过网络连接到摄像头了。  
最后拆除TTL线，将摄像头重新装配。重新装配时，务必记得将天线插好。  
