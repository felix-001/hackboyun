#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <getopt.h>

#include "hidemo.h"
#include "config/app_config.h"
#include "chipid.h"
#include "night.h"

int main(int argc, char *argv[]) 
{
    chip_id();
    isp_version();

    if (parse_app_config("./minihttp.ini") != CONFIG_OK) {
        dbg("Can't load app config './minihttp.ini'\n");
        return EXIT_FAILURE;
    }
    RtspServer_init();
    if(start_sdk(&state) == EXIT_FAILURE) {
        dbg("start sdk error\n");
    }

    if (app_config.night_mode_enable) 
        start_monitor_light_sensor();
    for (;;)
        sleep(1);

    stop_sdk(&state);
    dbg("Shutdown main thread\n");
    return EXIT_SUCCESS;
}
