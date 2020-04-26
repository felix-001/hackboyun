#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <getopt.h>
#include <time.h>
#include "hidemo.h"
#include "config/app_config.h"
#include "chipid.h"
#include "night.h"
#include "ringfifo.h"
#include "rtspservice.h"
#include "rtputils.h"

int keepRunning = 1;

#define LOGBUF_SIZE 2048
void _log(const char *file, const int line, const char *func, const char * pFmt, ...)
{
    time_t t;
    size_t time_len = 0, log_offset;
    const char* file_name = NULL;
    char log_buf[LOGBUF_SIZE];
    va_list ap;

//    t = time(NULL);
//    time_len = strftime(log_buf, LOGBUF_SIZE, "[%Y-%m-%d %H:%M:%S]", localtime(&t));
    file_name = strrchr(file, '/');
    if (!file_name)
        return;
    log_offset = time_len + snprintf(log_buf + time_len, LOGBUF_SIZE - time_len, "%s:%d(%s)#  ", file_name+1, line, func);
    va_start(ap, pFmt);
    log_offset += vsnprintf(log_buf + log_offset, LOGBUF_SIZE - log_offset, pFmt, ap);
    va_end(ap);
    printf("%s", log_buf);

}

int main(int argc, char *argv[]) 
{
    int s32MainFd;

    chip_id();
    isp_version();

    if (parse_app_config("./minihttp.ini") != CONFIG_OK) {
        dbg("Can't load app config './minihttp.ini'\n");
        return EXIT_FAILURE;
    }
    ringmalloc(1920*720);
    PrefsInit();
    if(start_sdk(&state) == EXIT_FAILURE) {
        dbg("start sdk error\n");
    }
    s32MainFd = tcp_listen(SERVER_RTSP_PORT_DEFAULT);
    if (ScheduleInit() == ERR_FATAL) {
        fprintf(stderr,"Fatal: Can't start scheduler %s, %i \nServer is aborting.\n", __FILE__, __LINE__);
        return 0;
    }
    RTP_port_pool_init(RTP_DEFAULT_PORT);
    if (app_config.night_mode_enable) 
        start_monitor_light_sensor();
    struct timespec ts = { 2, 0 };
    while (keepRunning) {
        nanosleep(&ts, NULL);
        EventLoop(s32MainFd);
    }

    ringfree();
    stop_sdk(&state);
    dbg("Shutdown main thread\n");
    return EXIT_SUCCESS;
}
