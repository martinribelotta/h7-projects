stmlib_base := $(notdir $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))

IGNORED_SRC:=%_template.c
IGNORED_SRC+=$(stmlib_base)/cmsis_core/Core%
IGNORED_SRC+=$(stmlib_base)/cmsis_core/NN/%
IGNORED_SRC+=$(stmlib_base)/cmsis_core/DSP/%
IGNORED_SRC+=$(stmlib_base)/cmsis_core/RTOS%
IGNORED_SRC+=$(stmlib_base)/cmsis_core/Device/ST/STM32H7xx/Source/%
IGNORED_SRC+=$(stmlib_base)/cmsis_device_h7/Source/Templates/%

IGNORED_INC:=$(stmlib_base)/cmsis_core/Core%
IGNORED_INC+=$(stmlib_base)/cmsis_core/NN/%
IGNORED_INC+=$(stmlib_base)/cmsis_core/DSP/%
IGNORED_INC+=$(stmlib_base)/cmsis_core/RTOS%

C_INCLUDES += $(filter-out $(IGNORED_INC), $(sort $(dir $(call rwildcard, $(stmlib_base), *.h))))
C_SOURCES += $(filter-out $(IGNORED_SRC), $(call rwildcard, $(stmlib_base), *.c))
ASM_SOURCES += $(filter-out $(IGNORED_SRC), $(call rwildcard, $(stmlib_base), *.s))

LDSCRIPTS := $(stmlib_base)/STM32H750VBTx_QSPI.ld

MCU := -mcpu=cortex-m7 -mthumb -mfpu=fpv5-d16 -mfloat-abi=hard

C_DEFS += USE_FULL_LL_DRIVER USE_HAL_DRIVER STM32H750xx
