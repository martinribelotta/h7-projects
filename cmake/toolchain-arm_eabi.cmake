set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CROSS_PREFIX "arm-none-eabi-")
set(CROSS_CC "${CROSS_PREFIX}gcc")
set(CROSS_CXX "${CROSS_PREFIX}g++")
set(CROSS_OBJDUMP "${CROSS_PREFIX}objdump")
set(CROSS_OBJCOPY "${CROSS_PREFIX}objcopy")

set(CMAKE_C_COMPILER ${CROSS_CC})
set(CMAKE_CXX_COMPILER ${CROSS_CXX})

set(CPU_FLAGS "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard")

set(COMMON_FLAGS "-Wall -fdata-sections -ffunction-sections")

set(FLAGS_DEBUG "-Og -g3")
set(FLAGS_RELEASE "-O3")
set(FLAGS_SIZE "-Os")

set(CMAKE_C_FLAGS "${CPU_FLAGS} ${OPT_FLAGS} ${COMMON_FLAGS}")
set(CMAKE_C_FLAGS_DEBUG ${FLAGS_DEBUG})
set(CMAKE_C_FLAGS_RELEASE ${FLAGS_RELEASE})
set(CMAKE_C_FLAGS_MINSIZEREL ${FLAGS_SIZE})
set(CMAKE_CXX_FLAGS "${CPU_FLAGS} ${OPT_FLAGS} ${COMMON_FLAGS} -fno-rtti -fno-exceptions")
set(CMAKE_CXX_FLAGS_DEBUG ${FLAGS_DEBUG})
set(CMAKE_CXX_FLAGS_RELEASE ${FLAGS_RELEASE})
set(CMAKE_CXX_FLAGS_MINSIZEREL ${FLAGS_SIZE})

set(LD_FLAGS "-Wl,--gc-sections -Wl,--print-memory-usage")

set(CMAKE_EXE_LINKER_FLAGS "${CPU_FLAGS} --specs=nosys.specs ${LD_FLAGS}" CACHE INTERNAL "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
