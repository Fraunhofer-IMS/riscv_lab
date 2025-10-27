## Minimal Demo Program

A simple example program is provided in `main.c`. You can compile is with the default Eclipse IDE
setup or you can use the command line for that. It initializes the SoC platforms, blinks some LEDs
and prints configuration info via the on-board USB-UART interface (19200-8-N-1 configuration):

### Compile in the Console

1. Generate an ELF file `main.elf` that can be uploaded via the JTAG port of the on.chip debugger:

```bash
make elf
```

2. Generate an executable `neorv32_exe.bin` that can be uploaded via the default bootloader (using a UART terminal):

```bash
make exe
```

3. Alternatively you can rename `neorv32_exe.bin` to `boot.bin` and copy it to the root directory
of an FAT32-formatted micro SD card and let the bootloader boot the program from SD card.

> [!TIP]
> This folder provides a simple hardware abstraction layer (HAL) for the board's basic IO peripherals
in `riscv_soc.h`. You can copy/include this file to your software project for easy IO access.

### Example Output


```
Fraunhofer IMS RISC-V Lab
Hello world! :)


<< NEORV32 Processor Configuration >>

Is simulation:       no
CPU cores (harts):   1
Clock speed:         100000000 Hz
On-chip debugger:    enabled, 4 HW trigger(s)
Hart ID:             0x00000000
Architecture ID:     0x00000013
Implementation ID:   0x01120307 (v1.12.3.7)
Architecture:        rv32-little
ISA extensions:      A C I M U X Sdext Sdtrig Smpmp Zaamo Zalrsc Zca Zicntr Zicsr Zifencei Zihpm Zkt
Tuning options:      trace fast_mul fast_shift
Phys. Memory Prot.:  4 region(s), 16384 bytes granularity, modes = OFF TOR NAPOT
HPM counters:        4 counter(s), 40 bit(s) wide
Boot configuration:  boot via bootloader (0)
Internal IMEM:       262144 bytes
Internal DMEM:       65536 bytes
CPU I-cache:         2048 bytes (32x64), bursts enabled
CPU D-cache:         1024 bytes (16x64), bursts enabled
Ext. bus interface:  enabled, bursts enabled
Bus timeout (int):   2048 cycles
Bus timeout (ext):   2048 cycles
Peripherals:         CLINT DMA GPIO GPTMR PWM SPI SYSINFO TRACER TRNG TWI UART0 WDT
```
