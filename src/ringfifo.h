#pragma once
#include <hi_comm_venc.h>

struct ringbuf {
    unsigned char *buffer;
	int frame_type;
    int size;
};
enum H264_FRAME_TYPE {FRAME_TYPE_I, FRAME_TYPE_P, FRAME_TYPE_B};
int addring (int i);
int ringget(struct ringbuf *getinfo);
void ringput(unsigned char *buffer,int size,int encode_type);
void ringfree();
void ringmalloc(int size);
void ringreset();

HI_S32 push_h264(VENC_STREAM_S *pstStream);

