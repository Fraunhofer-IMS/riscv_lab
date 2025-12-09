# AMD Vivado Project

This folder contains all required sources and scripts for building the pre-configured
[Digilent Nexys A7](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
Vivado FPGA project. Additionally, the mapping of the on-board peripherals to the different
modules of the RISC-V SoC is illustrated.

##### RISC-V SoC Block Diagram

![riscv_soc](../docs/img/soc_top.png)


## RISC-V SoC

The SoC implemented on the FPGA is based on the free and open-source
[NEORV32 project](https://github.com/stnolting/neorv32). It implements a
RISC-V-compatible CPU together with on-chip memory and peripherals,
forming a customizable, microcontroller-like setup.

The specific configuration of the SoC can be determined by software by querying dedicated information registers
(e.g., memory sizes, cache layout, UART FIFO depths, etc.). The demo program provided in the [`eclipse`](../eclipse)
older, for example, prints the exact hardware configuration via UART. The demo program also includes a simple
**hardware abstraction layer (HAL)** for easy access to the basic on-board peripherals.

📚 Detailed RISC-V SoC information such as technical specifications, tutorials, and software references
can be found at the following links:

* [data sheet](https://stnolting.github.io/neorv32)
* [user guide](https://stnolting.github.io/neorv32/ug)
* [API reference](https://stnolting.github.io/neorv32/sw/files.html)
* [example programs](https://github.com/stnolting/neorv32/tree/main/sw/example)

> [!IMPORTANT]
> The NEORV32 online documentation always shows the current status of the upstream repository.
However, due to updates and fixes, this may no longer match the NEORV32 version used in this lab.
In the `docs` folder, you will therefore find a copy of the data sheet and user guide specifically
for the version used here.

See the official [RISC-V ISA specification](https://github.com/riscv/riscv-isa-manual/releases)
for more information regarding the instruction set architecture.


## On-Board Peripherals

The Nexys A7 FPGA board offers a wide range of on-board peripherals and interfaces.
We recommend that you familiarize yourself with the
[Nexy A7 reference manual](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
before working with the board. Most of the basic peripherals are connected to the RISC-V SoC and
can be accessed by the application program.

> [!TIP]
> You can find a simple hardware abstraction layer (HAL) / board support package (BSP) for the basic SoC peripherals
in [`eclipse/riscv_soc.`](https://github.com/Fraunhofer-IMS/riscv_lab/blob/main/eclipse/riscv_soc.h).

### Clock & Reset

The FPGA is clocked by an on-board 100MHz quartz oscillator. This clock signal is used for the RISC-V core and all
peripherals. There is a red button labeled "CPU RESET" on the board which can be used to reset the entire SoC at
any time.

| Module | FPGA pin | Top port     | NEORV32 port |
|:-------|:--------:|:------------:|:------------:|
| Clock  | E3       | `CLK100`     | `clk_i`      |
| Reset  | C12      | `CPU_RESETN` | `rstn_i`     |

There is a second red button labeled "PROG". When this button is pressed, the FPGA is reconfigured with the default
bitstream stored in the on-board SPI flash. The configuration is complete when the "DONE" LED lights up.

### USB-UART Bridge

The USB port, which is also used for power supply and for configuring the FPGA, additionally provides a
virtual COM port that can be used for serial communication via UART. It is connected to the SoC's
[primary UART](https://stnolting.github.io/neorv32/#_primary_universal_asynchronous_receiver_and_transmitter_uart0).
Note that this UART interface is used as standard console for IO functions like `printf()`.
Optional hardware flow control signals (RTS & CTS) are provided. However, these signals are
disabled by default by the software.

| Module             | FPGA pin | Top port       | NEORV32 port   |
|:-------------------|:--------:|:--------------:|:--------------:|
| UART receive data  | C4       | `UART_TXD_IN`  | `uart0_txd_o`  |
| UART transmit data | D4       | `UART_RXD_OUT` | `uart0_rxd_i`  |
| UART clear to send | D3       | `UART_CTS`     | `uart0_rtsn_o` |
| UART ready to send | E5       | `UART_RTS`     | `uart0_ctsn_i` |

By default, a "`19200-8-N-1`" configuration is used. However, application software can change the Baud rate to
increase UART communication speed.

* Baud rate: 19200
* Data bits: 8
* Parity: none
* Stop bits: 1

> [!TIP]
> If you don't have a JTAG adapter available, you can also use the USB-UART bridge to load
programs onto the SoC using the [bootloader](https://stnolting.github.io/neorv32/#_bootloader).

### Green LEDs

The 16 green LEDs (_LED0_ to _LED15_) are driven by the lowest 16 bits of the
SoC's [GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio).
output port. All LEDs are high-active.

| Module | FPGA pin | Top port | NEORV32 port |
|:-------|:--------:|:--------:|:------------:|
| LED0   | H17      |`LED[0]`  | `gpio_o(0)`  |
| LED1   | K15      |`LED[1]`  | `gpio_o(1)`  |
| LED2   | J13      |`LED[2]`  | `gpio_o(2)`  |
| LED3   | N14      |`LED[3]`  | `gpio_o(3)`  |
| LED4   | R18      |`LED[4]`  | `gpio_o(4)`  |
| LED5   | V17      |`LED[5]`  | `gpio_o(5)`  |
| LED6   | U17      |`LED[6]`  | `gpio_o(6)`  |
| LED7   | U16      |`LED[7]`  | `gpio_o(7)`  |
| LED8   | V16      |`LED[8]`  | `gpio_o(8)`  |
| LED9   | T15      |`LED[9]`  | `gpio_o(9)`  |
| LED10  | U14      |`LED[10]` | `gpio_o(10)` |
| LED11  | T16      |`LED[11]` | `gpio_o(11)` |
| LED12  | V15      |`LED[12]` | `gpio_o(12)` |
| LED13  | V14      |`LED[13]` | `gpio_o(13)` |
| LED14  | V12      |`LED[14]` | `gpio_o(14)` |
| LED15  | V11      |`LED[15]` | `gpio_o(15)` |

### Seven-Segment Displays

The 8 seven-segment displays are controlled by upper-most 16 bits of the
SoC's [GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio).
output port. Note that all output ports are inverted internally by the SoC. Hence, the individual anode of
each display as well as the global segment signals are high-active for the RISC-V.

The segment control lines of the 8 individual digits are controlled in parallel. In order to display different
symbols on all digits, the display must be operated in time multiplex mode. To do this, the common anodes of the
individual digits must be activated individually and set together with the segment control. The digits are
enumerated from right to left where the right-most digit used anode 0 and the left-mode display uses anode 7.

| Module        | FPGA pin | Top port | NEORV32 port |
|:--------------|:--------:|:--------:|:------------:|
| Segment A     | T10      |`SEG[0]`  | `gpio_o(16)` |
| Segment B     | R10      |`SEG[1]`  | `gpio_o(17)` |
| Segment C     | K16      |`SEG[2]`  | `gpio_o(18)` |
| Segment D     | K13      |`SEG[3]`  | `gpio_o(19)` |
| Segment E     | P15      |`SEG[4]`  | `gpio_o(20)` |
| Segment F     | T11      |`SEG[5]`  | `gpio_o(21)` |
| Segment G     | L18      |`SEG[6]`  | `gpio_o(22)` |
| Segment DP    | H15      |`SEG[7]`  | `gpio_o(23)` |
| Anode digit 0 | J17      |`AN[0]`   | `gpio_o(24)` |
| Anode digit 1 | J18      |`AN[1]`   | `gpio_o(25)` |
| Anode digit 2 | T9       |`AN[2]`   | `gpio_o(26)` |
| Anode digit 3 | J14      |`AN[3]`   | `gpio_o(27)` |
| Anode digit 4 | P14      |`AN[4]`   | `gpio_o(28)` |
| Anode digit 5 | T14      |`AN[5]`   | `gpio_o(29)` |
| Anode digit 6 | K2       |`AN[6]`   | `gpio_o(30)` |
| Anode digit 7 | U13      |`AN[7]`   | `gpio_o(31)` |

### RGB LEDs

The individual LEDs of each RGB LED are driven by the SoC's
[PWM controller](https://stnolting.github.io/neorv32/#_pulse_width_modulation_controller_pwm).
By adjusting the brightness (= PWM duty cycle) of the three color channels, virtually any color can be created.

| Module      | FPGA pin | Top port  | NEORV32 port |
|:------------|:--------:|:---------:|:------------:|
| LED16.red   | N15      | `RGB0[0]` | `pwm_o(0)`   |
| LED16.green | M16      | `RGB0[1]` | `pwm_o(1)`   |
| LED16.blue  | R12      | `RGB0[2]` | `pwm_o(2)`   |
| LED17.red   | N16      | `RGB1[0]` | `pwm_o(3)`   |
| LED17.green | R11      | `RGB1[1]` | `pwm_o(4)`   |
| LED17.blue  | G14      | `RGB1[2]` | `pwm_o(5)`   |

### Switches

The 16 switches are directly connected to the input port of the SoC's
[GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio).
Note that the switches do not provide any de-bouncing circuitry.

| Module | FPGA pin | Top port | NEORV32 port |
|:-------|:--------:|:--------:|:------------:|
| SW0    | J15      | `SW[0]`  | `gpio_i(0)`  |
| SW1    | L16      | `SW[1]`  | `gpio_i(1)`  |
| SW2    | M13      | `SW[2]`  | `gpio_i(2)`  |
| SW3    | R15      | `SW[3]`  | `gpio_i(3)`  |
| SW4    | R17      | `SW[4]`  | `gpio_i(4)`  |
| SW5    | T18      | `SW[5]`  | `gpio_i(5)`  |
| SW6    | U18      | `SW[6]`  | `gpio_i(6)`  |
| SW7    | R13      | `SW[7]`  | `gpio_i(7)`  |
| SW8    | T8       | `SW[8]`  | `gpio_i(8)`  |
| SW9    | U8       | `SW[9]`  | `gpio_i(9)`  |
| SW10   | R16      | `SW[10]` | `gpio_i(10)` |
| SW11   | T13      | `SW[11]` | `gpio_i(11)` |
| SW12   | H6       | `SW[12]` | `gpio_i(12)` |
| SW13   | U12      | `SW[13]` | `gpio_i(13)` |
| SW14   | U11      | `SW[14]` | `gpio_i(14)` |
| SW15   | V10      | `SW[15]` | `gpio_i(15)` |

### Buttons

The 5 directional buttons are also directly connected to the input port of the SoC's
[GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio).
The buttons are high-active and provide pull-down resistors. However, they do not provide
any de-bouncing circuitry.

| Module        | FPGA pin | Top port  | NEORV32 port |
|:--------------|:--------:|:---------:|:------------:|
| BTNC (center) | N17      | `BTN[0]`  | `gpio_i(16)` |
| BTNU (up)     | M18      | `BTN[1]`  | `gpio_i(17)` |
| BTNL (left)   | P17      | `BTN[2]`  | `gpio_i(18)` |
| BTNR (right)  | M17      | `BTN[3]`  | `gpio_i(19)` |
| BTND (down)   | P18      | `BTN[4]`  | `gpio_i(20)` |

### Audio Jack

The on-board audio output is driven by another channel of the SoC's
[PWM controller](https://stnolting.github.io/neorv32/#_pulse_width_modulation_controller_pwm).
The amplifier is always enabled (`AUD_SD` is always high).

| Module     | FPGA pin | Top port  | NEORV32 port |
|:-----------|:--------:|:---------:|:------------:|
| Mono audio | A11      | `AUD_PWM` | `pwm_o(6)`   |
| Amp enable | D12      | `AUD_SD`  | -            |

### I2C Temperature Sensor

The on-board I²C/TWI temperature sensor is connected to the SoC's
[TWI controller](https://stnolting.github.io/neorv32/#_two_wire_serial_interface_controller_twi).

The temperature sensor is accessible via the 8-bit I²C address `0x96` (7-bit + zero = write address).
The FPGA setup already provides the required pull-up resistors.

| Module       | FPGA pin | Top port  | NEORV32 port             |
|:-------------|:--------:|:---------:|:------------------------:|
| Serial clock | C14      | `TMP_SCL` | `twi_scl_i`, `twi_scl_o` |
| Serial data  | C15      | `TMP_SDA` | `twi_sda_i`, `twi_sda_o` |

### SPI Flash

The on-board SPI flash is actually used to store the configuration/bitstream of the FPGA in order to
load it directly after power-up. However, the FPGA's bitstream (~4MB) does not occupy the entire flash,
the upper part (starting at address `0x00400000`) can also be used for custom applications.

> [!TIP]
> The SPI flash can be used by the default [bootloader](https://stnolting.github.io/neorv32/#_bootloader)
for non-volatile application program storage.

The flash is connected to the SoC's
[SPI controller](https://stnolting.github.io/neorv32/#_serial_peripheral_interface_controller_spi).
SPI flash and micro SD card use the same SPI interface but have individual chip-select lines.
The SPI flash is connected to SPI chip select 0.

| Module            | FPGA pin | Top port    | NEORV32 port   |
|:------------------|:--------:|:-----------:|:--------------:|
| Flash clock       | E9       | -           | `spi_clk_o`    |
| Flash data out    | K17      | `FLASH_SDI` | `spi_dat_i`    |
| Flash data in     | K18      | `FLASH_SDO` | `spi_dat_o`    |
| Flash chip-select | L13      | `FLASH_CSN` | `spi_csn_o(0)` |

### Micro SD Card Slot

The SD card is used in native SPI mode and is connected to the SoC's
[SPI controller](https://stnolting.github.io/neorv32/#_serial_peripheral_interface_controller_spi).
SPI flash and micro SD card use the same SPI interface but have individual chip-select lines.
The SD card is connected to SPI chip select 1. The SD card is always enabled (`SD_RST` is always high).

| Module              | FPGA pin | Top port | NEORV32 port   |
|:--------------------|:--------:|:--------:|:--------------:|
| SD card reset       | E2       | `SD_RST` | -              |
| SD card clock       | B1       | `SD_SCK` | `spi_clk_o`    |
| SD card data out    | C1       | `SD_SDI` | `spi_dat_i`    |
| SD card data in     | C2       | `SD_SDO` | `spi_dat_o`    |
| SD card chip-select | D2       | `SD_CSN` | `spi_csn_o(1)` |

> [!TIP]
> An FAT32-formatted SD card can be used by the default [bootloader](https://stnolting.github.io/neorv32/#_bootloader)
to boot an executable right from the card.

## PMOD Connectors

The Nexys A7 boards provides four digital PMOD connectors (JA, JB, JC, JD) that can be used
to attach custom peripheral boards and interfaces. The IOs of each PMOD have series resistors
to prevent short circuits caused by reverse polarity or incorrectly connected modules.

Each PMOD provides 12 pins: 8 digital IOs, 2 pins for ground ("GND"), and 2 pins for a 3.3 Volt supply
output ("3V3"). The total current consumption of all PMODs should not exceed 500mA.

```
     ________________________
    /                       /|
   +---+---+---+---+---+---+ |
   |3V3|GND| 4 | 3 | 2 | 1 | |
   +---+---+---+---+---+---+ |
   |3V3|GND| 10| 9 | 8 | 7 |/
---+---+---+---+---+---+---+---
PMOD connector pinout (front-view)
```

### PMOD JA & PMOD JXADC

These PMOD connector are not used yet. Do not connect anything to them.

### PMOD JB - AXI-GPIO-0

This PMOD provides a configurable general-purpose 8-bit bi-directional GPIO port. Note that this
port is **not** controlled directly by the RISC-V core; instead, it is controlled by an
[AMD AXI-GPIO](https://docs.amd.com/v/u/en-US/pg144-axi-gpio) controller that is connected to the
[external bus interface](https://stnolting.github.io/neorv32/#_processor_external_bus_interface_xbus)
of the RISC-V core.

The base address of this AXI-GPIO controller is `0xF0000000`. All PMDO GPIO pins provide FPGA-internal
weak pull-up resistors. The AXI-GPIO-0 provides an input pin-change interrupt (high-active) that is routed to the
[GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio)
at `gpio_i(21)`.

| PMOD Pin | Function         | FPGA pin | Top port | NEORV32 port |
|:---------|:-----------------|:--------:|:--------:|:------------:|
| 1        | AXI-GPIO-0 pin 0 | D14      | `JB[0]`  | -            |
| 2        | AXI-GPIO-0 pin 1 | F16      | `JB[1]`  | -            |
| 3        | AXI-GPIO-0 pin 2 | G16      | `JB[2]`  | -            |
| 4        | AXI-GPIO-0 pin 3 | H14      | `JB[3]`  | -            |
| 5        | Ground (GND)     | -        | -        | -            |
| 6        | +3.3V            | -        | -        | -            |
| 7        | AXI-GPIO-0 pin 4 | E16      | `JB[4]`  | -            |
| 8        | AXI-GPIO-0 pin 5 | F13      | `JB[5]`  | -            |
| 9        | AXI-GPIO-0 pin 6 | G13      | `JB[6]`  | -            |
| 10       | AXI-GPIO-0 pin 7 | H16      | `JB[7]`  | -            |
| 11       | Ground (GND)     | -        | -        | -            |
| 12       | +3.3V            | -        | -        | -            |

### PMOD JC - AXI-GPIO-1 & PWM

The function of this PMOD is split. The **upper row of PMDO pins** provides a configurable general-purpose 4-bit
bi-directional GPIO port. Note that this port is **not** controlled directly by the RISC-V core; instead, it is
controlled by an [AMD AXI-GPIO](https://docs.amd.com/v/u/en-US/pg144-axi-gpio) controller that is connected to
the [external bus interface](https://stnolting.github.io/neorv32/#_processor_external_bus_interface_xbus)
of the RISC-V core.

The base address of this AXI-GPIO controller is `0xF0010000`. All PMDO GPIO pins provide FPGA-internal
weak pull-up resistors. The AXI-GPIO-1 also provides an input pin-change interrupt (high-active) that is routed to the
[GPIO controller](https://stnolting.github.io/neorv32/#_general_purpose_input_and_output_port_gpio)
at `gpio_i(22)`.

The **lower row of PMOD pins** is driven by the SoC's
[PWM controller](https://stnolting.github.io/neorv32/#_pulse_width_modulation_controller_pwm).

| PMOD Pin | Function         | FPGA pin | Top port   | NEORV32 port |
|:---------|:-----------------|:--------:|:----------:|:------------:|
| 1        | AXI-GPIO-1 pin 0 | K1       | `JC_lo[0]` | -            |
| 2        | AXI-GPIO-1 pin 1 | F6       | `JC_lo[1]` | -            |
| 3        | AXI-GPIO-1 pin 2 | J2       | `JC_lo[2]` | -            |
| 4        | AXI-GPIO-1 pin 3 | G6       | `JC_lo[3]` | -            |
| 5        | Ground (GND)     | -        | -          | -            |
| 6        | +3.3V            | -        | -          | -            |
| 7        | PWM              | E7       | `JC_hi[0]` | `pwm_o(7)`   |
| 8        | PWM              | J3       | `JC_hi[1]` | `pwm_o(8)`   |
| 9        | PWM              | J4       | `JC_hi[2]` | `pwm_o(9)`   |
| 10       | PWM              | E6       | `JC_hi[3]` | `pwm_o(10)`  |
| 11       | Ground (GND)     | -        | -          | -            |
| 12       | +3.3V            | -        | -          | -            |

### PMOD JD - RISC-V JTAG

This PMOD port provides access to the RISC-V
[On-Chip Debugger](https://stnolting.github.io/neorv32/#_on_chip_debugger_ocd) via a standard JTAG port.
Four signal wires and one ground wire are required to connect the PMOD pins to the according ESP-prog pins.

> [!IMPORTANT]
> Do not connect any 3.3V PMOD pin to the ESP-prog board!

| PMOD Pin | Function | FPGA pin | Top port   | NEORV32 port |
|:---------|:---------|:--------:|:----------:|:------------:|
| 1        | TDI      | H4       | `JTAG_TDI` | `jtag_tdi_i` |
| 2        | TDO      | H1       | `JTAG_TDO` | `jtag_tdo_o` |
| 3        | TCK      | G1       | `JTAG_TCK` | `jtag_tck_i` |
| 4        | TMS      | G3       | `JTAG_TMS` | `jtag_tms_i` |
| 5        | GND      | -        | -          | -            |


## Vivado Setup

Optionally, the SoC design of the FPGA can be re-build, modified and synthesized.
However, this step is not required yet as the lab staff will hand out pre-configured FPGA board.
If you want to modify or rebuild the SoC design, a free version of AMD Vivado is required.

> [!IMPORTANT]
> Use Vivado 2024.2 or higher. If you just want to configure the FPGA using a pre-build bitstream,
the "Vivado Lab Solutions" are sufficient.

> [!TIP]
> Pre-compiled bitstreams will be made available as release assets.

### Windows

1. Start Vivado in GUI mode.
2. Click on "TCL Console" at the bottom.
3. In the console use the `cd` command to navigate to _this_ folder.
4. Execute `source project_setup.tcl` to create the Vivado project.
5. After that the generated project is opened automatically.
6. Execute the "run synthesis", "run implementation" and "generate bitstream" steps to generate bitstream data for FPGA configuration.

### Linux

1. Open a bash console and use `cd` to navigate to _this_ folder.
2. A makefile is provided for automatic Vivado project management. Run `make help` to see all available commands.
3. Generate the Vivado project (in an auto-generated folder named `work`): `make project`
4. Open the generated project in GUI mode: `make gui`
5. Execute the "run synthesis", "run implementation" and "generate bitstream" steps to generate bitstream data for FPGA configuration.

### Flashing The Configuration Memory

The FPGA's internal configuration memory is based on SRAM cells and is therefore volatile - after
a power cycle, the FPGA is empty again and must be reconfigured via USB. Most FPGAs can configure
themselves automatically after power-up using a bitstream from an SPI flash.
This non-volatile configuration memory can also be programmed with Vivado.

1. **If you already have a bitstream (with `.bin` ending!) you can skip this first step.** Generate the bitstream by expanding
"PROGRAM AND DEBUG" in the left side panel of Vivado. Click on "Generate Bitstream" and wait until generation is complete.
2. Open the hardware manager by clicking "Open Hardware Manager" in the left side Vivado panel.
3. In the hardware manager window click "Open Target" in the upper green bar and select "Auto Connect".
4. When the target is connected, right-click on the FPGA instance "xc7a100t_0" in the hardware window "Add Configuration Memory Device".
5. A window opens. Type `s25fl128` into the search bar and select `s25fl128sxxxxxx0-spi-x1-x2-x4` from the list below. Click OK.
6. A prompt should open asking "Do you want to program the configuration memory device now?". Click OK.
7. A new window opens. In the "Configuration File" line click the three dots on the right.
8. A file explorer window opens. Navigate to _this_ folder (`fpga`) and then navigate to
`work/riscv_lab_nexys_a7.runs/impl_1` and select the `riscv_lab_wrapper.bin` file. Click OK.
9. Back in the configuration memory device window also click OK. SPI flash programming is in progress now and will take some time.
10. After programming is completed you can power-cycle the FPGA board or push the red "PROG" button to trigger self-configuration from the SPI flash.
11. Self-configuration requires about 20 seconds. After that the green "DONE" LED should light up and the FPGA with the RISC-V SoC is operational.

### FPGA Resource Utilization

The current RISC-V SoC consumes only a small fraction of the available FPGA resources - so
there is still plenty of space to implement your own circuits!

| LUTs              | FFs                | BRAMs          | DSPs         |
|:-----------------:|:------------------:|:--------------:|:------------:|
| 5721 / 63400 (9%) | 5221 / 126800 (4%) | 87 / 135 (64%) | 4 / 240 (2%) |
