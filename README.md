# 硬件
## chips
- **CPU:** hi3518EV200
- **WIFI:** 8188
- **ZIGBEE:** cc2530
- **SENSOR:** ov9732

## pins
- 摄像头正面红绿双色指示灯  

| LED_G|L1 | GPIO8_0 |
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
 

# 软件
