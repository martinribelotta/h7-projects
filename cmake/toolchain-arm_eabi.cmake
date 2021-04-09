set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER "arm-none-eabi-gcc")
set(CMAKE_CXX_COMPILER "arm-none-eabi-g++")

set(CPU_FLAGS "-mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard")
set(OPT_FLAGS "-Og -Wall")
set(COMMON_FLAGS "-fdata-sections -ffunction-sections")

set(CMAKE_C_FLAGS "${CPU_FLAGS} ${OPT_FLAGS} ${COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS "${CPU_FLAGS} ${OPT_FLAGS} ${COMMON_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "${CPU_FLAGS} --specs=nosys.specs" CACHE INTERNAL "")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
