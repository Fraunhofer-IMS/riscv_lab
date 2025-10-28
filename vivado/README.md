## AMD Vivado Project

This folder contains all required sources and scripts for building the pre-configured
[Digilent Nexys A7](https://digilent.com/reference/programmable-logic/nexys-a7/reference-manual)
Vivado FPGA project.

![riscv_soc](../docs/img/soc_top.png)

###### FPGA Resource Utilization

| LUTs              | FFs                | BRAMs          | DSPs         |
|:-----------------:|:------------------:|:--------------:|:------------:|
| 5741 / 63400 (9%) | 5190 / 126800 (4%) | 88 / 135 (65%) | 4 / 240 (2%) |

### Setup on Windows

1. Start Vivado in GUI mode.
2. Click on "TCL Console" at the bottom.
3. In the console use the `cd` command to navigate to _this_ folder.
4. Execute `source project_setup.tcl` to create the Vivado project.
5. After that the generated project is opened automatically.
6. Execute the "run synthesis", "run implementation" and "generate bitstream" steps to generate bitstream data for FPGA configuration.

### Setup on Linux

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
