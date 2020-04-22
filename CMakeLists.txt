cmake_minimum_required (VERSION 2.8)

set( APPNAME app )

set(CROSS_COMPILE arm-hisiv300-linux-uclibcgnueabi)
set(CMAKE_C_COMPILER ${CROSS_COMPILE}-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_COMPILE}-g++)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

project( ${APPNAME} )

add_definitions(-DCHIP_ID=0x3518E200)
add_definitions(-Dhi3518ev200)
add_definitions(-DSENSOR_TYPE=OMNIVISION_OV9732_DC_720P_30FPS)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/src/rtsp/common)
link_directories(${CMAKE_CURRENT_SOURCE_DIR}/libs/sensor ${CMAKE_CURRENT_SOURCE_DIR}/libs/mpi ${CMAKE_CURRENT_SOURCE_DIR}/libs/audio)

aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src/rtsp DIR_SRCS)
aux_source_directory(${CMAKE_CURRENT_SOURCE_DIR}/src/rtsp/common DIR_SRCS)
add_executable(${APPNAME} ${DIR_SRCS})
set (HISI_SENSOR_LIBS 
    _cmoscfg
    _hiae
    _hiaf
    _hiawb  
    _iniparser  
    isp  
    _hidefog  
    sns_ov9732  
    )

set (HISI_MPI_LIBS ive md mpi)
set (HISI_AUDIO_LIBS upvqe dnvqe VoiceEngine)
target_link_libraries(${APPNAME} ${HISI_MPI_LIBS} ${HISI_SENSOR_LIBS}  ${HISI_AUDIO_LIBS} pthread m dl)

