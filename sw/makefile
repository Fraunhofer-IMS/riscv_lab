# Application makefile.
# Use this makefile to configure all relevant CPU / compiler options.

# Override the default CPU ISA
MARCH = rv32i_zicsr_zifencei

# Override the default RISC-V GCC prefix
RISCV_PREFIX ?= riscv-none-elf-

# Override default optimization goal
EFFORT = -Os

# Add extended debug symbols
USER_FLAGS += -ggdb -gdwarf-3

# Adjust default memory size
USER_FLAGS += -Wl,--defsym,__neorv32_rom_size=256k
USER_FLAGS += -Wl,--defsym,__neorv32_ram_size=64k

# Adjust maximum heap size
USER_FLAGS += -Wl,--defsym,__neorv32_heap_size=16k

# Set path to NEORV32 root directory
NEORV32_HOME ?= ../extern/neorv32

# Include the main NEORV32 makefile
include $(NEORV32_HOME)/sw/common/common.mk
