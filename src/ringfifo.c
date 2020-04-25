/*ringbuf .c*/

#include<stdio.h>
#include<ctype.h>
#include <stdlib.h>
#include <string.h>
#include "ringfifo.h"
#include "config/app_config.h"

#define NMAX 32

int iput = 0; /* 环形缓冲区的当前放入位置 */
int iget = 0; /* 缓冲区的当前取出位置 */
int n = 0; /* 环形缓冲区中的元素总数量 */
int g_max_buf_size = 0;

struct ringbuf ringfifo[NMAX];
extern int UpdateSpsOrPps(unsigned char *data,int frame_type,int len);
/* 环形缓冲区的地址编号计算函数，如果到达唤醒缓冲区的尾部，将绕回到头部。
环形缓冲区的有效地址编号为：0到(NMAX-1)
*/
//分配环形缓冲区，总共32个，每个大小为size
void ringmalloc(int size)
{
    int i;

    g_max_buf_size = size;
    for(i =0; i<NMAX; i++)
    {
        ringfifo[i].buffer = malloc(size);
        ringfifo[i].size = 0;
        ringfifo[i].frame_type = 0;
    }
    iput = 0; /* 环形缓冲区的当前放入位置 */
    iget = 0; /* 缓冲区的当前取出位置 */
    n = 0; /* 环形缓冲区中的元素总数量 */
}
/**************************************************************************************************
**
**
**
**************************************************************************************************/
void ringreset()
{
    iput = 0; /* 环形缓冲区的当前放入位置 */
    iget = 0; /* 缓冲区的当前取出位置 */
    n = 0; /* 环形缓冲区中的元素总数量 */
}
/**************************************************************************************************
**
**
**
**************************************************************************************************/
void ringfree(void)
{
    int i;

    dbg("begin free mem\n");
    for(i =0; i<NMAX; i++)
    {
        free(ringfifo[i].buffer);
        ringfifo[i].size = 0;
    }
}
/**************************************************************************************************
**
**
**
**************************************************************************************************/
int addring(int i)
{
    return (i+1) == NMAX ? 0 : i+1;
}

/* 从环形缓冲区中取一个元素 */

int ringget(struct ringbuf *getinfo)
{
    int Pos;

    if (n > 0) {
        Pos = iget;
        iget = addring(iget);
        n--;
        getinfo->buffer = (ringfifo[Pos].buffer);
        getinfo->frame_type = ringfifo[Pos].frame_type;
        getinfo->size = ringfifo[Pos].size;
        return ringfifo[Pos].size;
    } else {
        return 0;
    }
}
/* 向环形缓冲区中放入一个元素*/
void ringput(unsigned char *buffer,int size,int encode_type)
{

    if(n<NMAX)
    {
        memcpy(ringfifo[iput].buffer,buffer,size);
        ringfifo[iput].size= size;
        ringfifo[iput].frame_type = encode_type;
        //dbg("Put FIFO INFO:idx:%d,len:%d,ptr:%x,type:%d\n",iput,ringfifo[iput].size,(int)(ringfifo[iput].buffer),ringfifo[iput].frame_type);
        iput = addring(iput);
        n++;
    }
    else
    {
        //  dbg("Buffer is full\n");
    }
}

/**************************************************************************************************
**将H264流数据放到ringfifo[iput].buffer里以便schedule_do线程从ringfifo[iput].buffer里取出数据发送出去
**同是在DESCRIBE步骤中会对SPS,PPS编码发送给客户端，后面好像就只编码但没有发送出去
**
**************************************************************************************************/
HI_S32 push_h264(VENC_STREAM_S *pstStream)
{
	HI_S32 i;
	HI_S32 off = 0, packlen = 0;

    if(n < NMAX) {
		for (i = 0; i < pstStream->u32PackCount; i++) {
            VENC_PACK_S *pack = &pstStream->pstPack[i];

            if (off >= g_max_buf_size) {
                dbg("check buf size error, off:%d\n", off);
                return -1;
            }
            packlen = pack->u32Len - pack->u32Offset;
			memcpy(ringfifo[iput].buffer + off, pack->pu8Addr + pack->u32Offset, packlen);
            off += packlen;
		}

        ringfifo[iput].size = off;
        iput = addring(iput);
        n++;
    }

	 return 0;
}
