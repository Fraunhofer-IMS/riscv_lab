## Eclipse Demo Project

![eclipse_project](../docs/img/eclipse.png)

This simple demo program initializes the SoC platforms, blinks some LEDs
and prints configuration info via the on-board USB-UART interface (19200-8-N-1 configuration).
Is is wrapped within a pre-configured example project that can be imported into Eclipse:

1. Start Eclipse IDE.
2. Click on **File > Import**, expand **General** and select **"Projects from Folder or Archive"**.
3. Click **Next**.
4. Click on **Directory** and select _this_ folder (`path/to/riscv_lab/eclipse`).
5. Click **Finish**.

> [!NOTE]
> When you start the Eclipse project for the first time you might need to setup the (x-pack) binaries for the
RISC-V GCC toolchain, the build tools (on Windows only) and openOCD. See the NEORV32 User Guide for more information:
[UG: Eclipse IDE](https://stnolting.github.io/neorv32/ug/#_eclipse_ide)

> [!TIP]
> This folder provides a simple hardware abstraction layer (HAL) for the board's basic IO peripherals
in `riscv_soc.h`.

### Compile in the Console

Alternatively, you can also compile the program in the command line.

1. Generate an ELF file `main.elf` that can be uploaded via the JTAG port of the on-chip debugger:

```bash
$ make elf
```

2. Generate an executable `neorv32_exe.bin` that can be uploaded via the default bootloader (using a UART terminal):

```bash
$ make exe
```

3. Alternatively you can rename `neorv32_exe.bin` to `boot.bin` and copy it to the root directory
of an FAT32-formatted micro SD card and let the bootloader boot the program from SD card.

### Example Serial Output

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
