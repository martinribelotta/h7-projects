if(NOT DEFINED STMLIB_PATH)
    message(FATAL_ERROR "Undefined path for STMLIB_PATH")
endif()

target_compile_definitions(${PROJECT_NAME} PUBLIC -DUSE_FULL_LL_DRIVER -DUSE_HAL_DRIVER -DSTM32H750xx)
target_include_directories(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/cmsis_core/Include/)
target_include_directories(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/cmsis_device_h7/Include/)
target_include_directories(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/stm32h7xx_hal_driver/Inc/)
target_include_directories(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/stm32h7xx_hal_driver/Inc/Legacy/)

file(GLOB HAL_SRC ${STMLIB_PATH}/stm32h7xx_hal_driver/Src/*.c)
list(FILTER HAL_SRC EXCLUDE REGEX ".*_template.c")

set(LINKER_SCRIPT ${STMLIB_PATH}/STM32H750VBTx_QSPI.ld)

target_sources(${PROJECT_NAME} PUBLIC ${HAL_SRC})
target_sources(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/startup_stm32h750xx.s)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT})
target_link_options(${PROJECT_NAME} PUBLIC "-T${LINKER_SCRIPT}")
target_link_options(${PROJECT_NAME} PUBLIC "-Wl,--gc-sections")
target_link_options(${PROJECT_NAME} PUBLIC "-Wl,--print-memory-usage")
target_link_options(${PROJECT_NAME} PUBLIC "-nostartfiles")
