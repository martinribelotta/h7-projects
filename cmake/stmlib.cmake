if(NOT DEFINED STMLIB_PATH)
    message(FATAL_ERROR "Undefined path for STMLIB_PATH")
endif()

list(APPEND _INCPATH "${STMLIB_PATH}/cmsis_core/Include/")
list(APPEND _INCPATH "${STMLIB_PATH}/cmsis_device_h7/Include/")
list(APPEND _INCPATH "${STMLIB_PATH}/stm32h7xx_hal_driver/Inc/")
list(APPEND _INCPATH "${STMLIB_PATH}/stm32h7xx_hal_driver/Inc/Legacy/")

target_compile_definitions(${PROJECT_NAME} PUBLIC -DUSE_FULL_LL_DRIVER -DUSE_HAL_DRIVER -DSTM32H750xx)

file(GLOB HAL_SRC ${STMLIB_PATH}/stm32h7xx_hal_driver/Src/*.c)

foreach(p ${_INCPATH})
    target_include_directories(${PROJECT_NAME} PUBLIC ${p})
    file(GLOB H_FILES ${p}/*.h)
    list(APPEND HAL_H "${H_FILES}")
endforeach()

list(FILTER HAL_SRC EXCLUDE REGEX ".*_template.c")
set(LINKER_SCRIPT ${STMLIB_PATH}/STM32H750VBTx_QSPI.ld)

target_sources(${PROJECT_NAME} PUBLIC ${HAL_SRC} ${HAL_H})
target_sources(${PROJECT_NAME} PUBLIC ${STMLIB_PATH}/startup_stm32h750xx.s)
set_target_properties(${PROJECT_NAME} PROPERTIES LINK_DEPENDS ${LINKER_SCRIPT})
target_link_options(${PROJECT_NAME} PUBLIC "-T${LINKER_SCRIPT}")
target_link_options(${PROJECT_NAME} PUBLIC "-nostartfiles")
target_compile_features(${PROJECT_NAME} PUBLIC cxx_noexcept)
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_11)
target_compile_features(${PROJECT_NAME} PUBLIC c_std_99)

set(HEX_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CROSS_OBJCOPY} "-Oihex" $<TARGET_FILE:${PROJECT_NAME}> ${HEX_FILE})

add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CROSS_OBJCOPY} "-Obinary" $<TARGET_FILE:${PROJECT_NAME}> ${BIN_FILE})

set(BURN_ADDR 0x00000000)

add_custom_target(burn-${PROJECT_NAME}
                  COMMAND make RESET_AT_END=yes BURN_ADDR=${BURN_ADDR} BURN_FILE=${BIN_FILE} burn
                  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/qspi-loader
                  DEPENDS ${PROJECT_NAME}
                  COMMENT "Burning ${PROJECT_NAME}.bin at ${BURN_ADDR}"
                  USES_TERMINAL)
