TARGET = test1
VERBOSE = n
DEBUG = 1
OPT = -Og
BUILD_DIR := build
LIBS :=
LIBDIR :=
SPECS := nano nosys
C_DEFS :=
C_STD := c99
CXX_STD := c++11

# from https://stackoverflow.com/a/18258352
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

C_INCLUDES := $(sort $(dir $(call rwildcard, app,*.h)))
C_SOURCES := $(call rwildcard, app,*.c)
CXX_INCLUDES += $(sort $(dir $(call rwildcard, app,*.hh)))
CXX_INCLUDES += $(sort $(dir $(call rwildcard, app,*.hpp)))
CXX_SOURCES := $(call rwildcard, app,*.cpp)
ASM_SOURCES := $(call rwildcard, app,*.s)

include libstm32h7/stmlib.mk

COMMON_FLAGS := $(MCU) $(OPT) -Wall -fdata-sections -ffunction-sections

SPECS_FLAGS := $(addsuffix .specs,$(addprefix -specs=,$(SPECS)))

ASFLAGS := $(COMMON_FLAGS)

CFLAGS := $(COMMON_FLAGS)
CFLAGS += $(addprefix -D, $(C_DEFS))
CFLAGS += $(addprefix -I, $(C_INCLUDES))
CFLAGS += $(SPECS_FLAGS)

CXXFLAGS := $(CFLAGS)
CXXFLAGS := $(CFLAGS)
CXXFLAGS := $(CFLAGS)
CXXFLAGS += -fno-rtti -fno-exceptions
CFLAGS += $(addprefix -I, $(CXX_INCLUDES))
CXXFLAGS += -std=$(CXX_STD)

CFLAGS += -std=$(C_STD)

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information (not use :=, require delayed eval)
DEP_FLAGS = -MMD -MP -MF"$(@:%.o=%.d)"
LIST_FLAGS = -Wa,-a,-ad,-alms=$(BUILD_DIR)/o/$(notdir $(<:.c=.lst))

LDFLAGS := $(MCU)
LDFLAGS += $(SPECS_FLAGS)
LDFLAGS += $(addprefix -T, $(LDSCRIPTS))
LDFLAGS += $(addprefix -L, $(LIBDIR))
LDFLAGS += $(addprefix -l, $(LIBS))
LDFLAGS += -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref
LDFLAGS += -Wl,--gc-sections
LDFLAGS += -Wl,--print-memory-usage
LDFLAGS += -nostartfiles

SECTIONS := $(sort $(shell grep -oE '\.\S+\s*\:' $(LDSCRIPTS) | tr -d ':'))

LSTFLAGS := -xdS $(addprefix -j, $(SECTIONS))

TARGET_ELF:=$(BUILD_DIR)/$(TARGET).elf
TARGET_HEX:=$(BUILD_DIR)/$(TARGET).hex
TARGET_BIN:=$(BUILD_DIR)/$(TARGET).bin
TARGET_LST:=$(BUILD_DIR)/$(TARGET).lst

PREFIX := arm-none-eabi-
CC := $(PREFIX)gcc
CXX := $(PREFIX)g++
ifeq ($(strip $(CXX_SOURCES)),)
LD := $(CC)
else
LD := $(CXX)
endif
AS := $(PREFIX)gcc -x assembler-with-cpp
CP := $(PREFIX)objcopy
SZ := $(PREFIX)size
HEX := $(CP) -O ihex
BIN := $(CP) -O binary -S
LST := $(PREFIX)objdump

all: $(TARGET_ELF) $(TARGET_HEX) $(TARGET_BIN) $(TARGET_LST)

OBJECTS := $(addprefix $(BUILD_DIR)/o/,$(notdir $(CXX_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CXX_SOURCES)))

OBJECTS += $(addprefix $(BUILD_DIR)/o/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

OBJECTS += $(addprefix $(BUILD_DIR)/o/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

ifeq ($(strip $(VERBOSE)),y)
Q=
else
Q=@
endif

# MKFILE:=Makefile
MKFILE:=

$(BUILD_DIR)/o/%.o: %.c $(MKFILE) | $(BUILD_DIR)
	@echo CC $<
	$(Q)$(CC) $(DEP_FLAGS) -c $(CFLAGS) $(LIST_FLAGS) $< -o $@

$(BUILD_DIR)/o/%.o: %.cpp $(MKFILE) | $(BUILD_DIR)
	@echo CXX $<
	$(Q)$(CXX) $(DEP_FLAGS) -c $(CXXFLAGS) $(LIST_FLAGS) $< -o $@

$(BUILD_DIR)/o/%.o: %.s $(MKFILE) | $(BUILD_DIR)
	@echo AS $<
	$(Q)$(AS) $(DEP_FLAGS) -c $(CFLAGS) $< -o $@

$(TARGET_ELF): $(OBJECTS) Makefile
	@echo LD $@
	$(Q)$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(Q)$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo HEX $@
	$(Q)$(HEX) $< $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo BIN $@
	$(Q)$(BIN) $< $@	

$(BUILD_DIR)/%.lst: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	@echo LST $@
	$(Q)$(LST) $(LSTFLAGS) $< > $@

$(BUILD_DIR):
	$(Q)mkdir -p $@/o

clean:
	@echo CLEAN $(BUILD_DIR)
	$(Q)-rm -fR $(BUILD_DIR)

-include $(wildcard $(BUILD_DIR)/o/*.d)

PHONY_TARGETS:=$(filter-out .%, $(shell grep -E '^.PHONY:' Makefile | cut -f 2 -d ':'))
-include vscode-integration.mk

.PHONY: all clean burn

.format:
	@echo CLANG FORMAT
	@clang-format --verbose -i $(wildcard app/*/*.c) $(wildcard app/*/*.h)

.print-%:
	@echo "$($*)"

BURN_ADDR?=0x00000000
BURN_FILE?=$(TARGET_BIN)

burn: $(BURN_FILE)
	@echo BURN...
	$(Q)$(MAKE) -C qspi-loader RESET_AT_END=yes BURN_ADDR=$(BURN_ADDR) BURN_FILE=$(shell realpath $(BURN_FILE)) burn

mkfile_dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

define json_entry
{
"directory": "$(mkfile_dir)",
"command": "$(CC) -c $(CFLAGS) $(strip $1) -o $(patsubst %.c, %.o, $(strip $(addprefix $(BUILD_DIR)/o/,$(notdir $1))))",
"file": "$(strip $1)"
}
endef

json_entry_sepi:=$(_MK_CBRACK)$(_MK_SPACE)$(_MK_SPACE)$(_MK_OBRACK)
json_entry_sepo:=$(_MK_CBRACK)$(_MK_COMMA)$(_MK_NEWLINE)$(_MK_OBRACK)

define cc_json
[
$(subst $(json_entry_sepi),$(json_entry_sepo), $(foreach f, $(C_SOURCES), $(call json_entry, $f)))
]
endef
export cc_json

.create-ccjson: $(BUILD_DIR)/compile_commands.json

$(BUILD_DIR)/compile_commands.json: Makefile
	@echo -n "$$cc_json" > $@
