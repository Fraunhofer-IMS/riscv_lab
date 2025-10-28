# Recreate the RISC-V demo setup for the Nexys A7 FPGA board
# copyright (c) 2025 Fraunhofer IMS, 47057 Duisburg, Germany
# author: nolting
# Licensed under the BSD-3-Clause license, see LICENSE for details.
# SPDX-License-Identifier: BSD-3-Clause
# author: nolting

# Project configuration
set part "xc7a100tcsg324-1"
set prj riscv_lab_nexys_a7
set outputdir work
set script_path [ file dirname [ file normalize [ info script ] ] ]
set home_path [ file dirname $script_path ]

# Create and clear output/work directory
file mkdir $outputdir
set files [glob -nocomplain "$outputdir/*"]
if {[llength $files] != 0} {
  puts "deleting contents of $outputdir"
  file delete -force {*}[glob -directory $outputdir *];
} else {
  puts "$outputdir is clean"
}

# Create new Vivado project
puts "Recreating Fraunhofer IMS RISC-V Lab Vivado Project"
create_project -part $part $prj $outputdir
set_property PART ${part} [current_project]

# Add constraints files
set fileset_constraints [glob constr/*.xdc]
add_files -fileset constrs_1 $fileset_constraints

# Add local rtl files
add_files -norecurse [glob rtl/*.v]

# Build NEORV32 IP block and add to project's IP repository
puts "Building NEORV32 IP module..."
cd ../extern/neorv32/rtl/system_integration/
source neorv32_vivado_ip.tcl
cd ../../../../vivado/
set_property ip_repo_paths {../extern/neorv32/rtl/system_integration/neorv32_vivado_ip_work/packaged_ip} [current_project]
update_ip_catalog -rebuild -scan_changes

# Create block design and let Vivado manage the HDL wrapper; use that wrapper as top
create_bd_design "riscv_lab"
update_compile_order -fileset sources_1
make_wrapper -files [get_files $home_path/vivado/work/${prj}.srcs/sources_1/bd/riscv_lab/riscv_lab.bd] -top
add_files -norecurse $home_path/vivado/work/${prj}.gen/sources_1/bd/riscv_lab/hdl/riscv_lab_wrapper.v
set_property top riscv_lab_wrapper [current_fileset]

# Enable generation of BIN bitstream file for configuration memory programming
set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

# -------------------------------------------------------------
# Clock and reset
# -------------------------------------------------------------

create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list \
  CONFIG.RESET_PORT {resetn} \
  CONFIG.RESET_TYPE {ACTIVE_LOW} \
  CONFIG.CLKIN1_JITTER_PS {100.0} \
  CONFIG.CLKOUT1_JITTER {130.958} \
  CONFIG.CLKOUT1_PHASE_ERROR {98.575} \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
  CONFIG.MMCM_CLKFBOUT_MULT_F {10.000} \
  CONFIG.MMCM_CLKIN1_PERIOD {10.000} \
  CONFIG.MMCM_CLKOUT0_DIVIDE_F {10.000} \
  CONFIG.PRIM_IN_FREQ {100.000} \
] [get_bd_cells clk_wiz_0]

create_bd_port -dir I -type clk -freq_hz 100000000 CLK100
create_bd_port -dir I -type rst CPU_RESETN
connect_bd_net [get_bd_ports CLK100] [get_bd_pins clk_wiz_0/clk_in1]
connect_bd_net [get_bd_ports CPU_RESETN] [get_bd_pins clk_wiz_0/resetn]

# -------------------------------------------------------------
# Processor core complex
# -------------------------------------------------------------

create_bd_cell -type ip -vlnv NEORV32:user:neorv32_vivado_ip:1.0 neorv32_vivado_ip_0
set_property -dict [list \
  CONFIG.CLOCK_FREQUENCY 100000000 \
  CONFIG.CPU_FAST_MUL_EN {true} \
  CONFIG.CPU_FAST_SHIFT_EN {true} \
  CONFIG.DCACHE_EN {true} \
  CONFIG.DCACHE_NUM_BLOCKS {16} \
  CONFIG.ICACHE_EN {true} \
  CONFIG.ICACHE_NUM_BLOCKS {32} \
  CONFIG.CACHE_BLOCK_SIZE {64} \
  CONFIG.DMEM_EN {true} \
  CONFIG.DMEM_OUTREG_EN {true} \
  CONFIG.DMEM_SIZE {65536} \
  CONFIG.IMEM_EN {true} \
  CONFIG.IMEM_OUTREG_EN {true} \
  CONFIG.IMEM_SIZE {262144} \
  CONFIG.HPM_NUM_CNTS {4} \
  CONFIG.HPM_CNT_WIDTH {64} \
  CONFIG.IO_CLINT_EN {true} \
  CONFIG.IO_GPIO_EN {true} \
  CONFIG.IO_GPIO_IN_NUM {23} \
  CONFIG.IO_GPIO_OUT_NUM {32} \
  CONFIG.IO_GPTMR_EN {true} \
  CONFIG.IO_PWM_EN {true} \
  CONFIG.IO_PWM_NUM_CH {7} \
  CONFIG.IO_SPI_EN {true} \
  CONFIG.IO_SPI_FIFO {16} \
  CONFIG.IO_TRACER_BUFFER {64} \
  CONFIG.IO_TRACER_EN {true} \
  CONFIG.IO_TRNG_EN {true} \
  CONFIG.IO_TRNG_FIFO {16} \
  CONFIG.IO_UART0_EN {true} \
  CONFIG.IO_UART0_RX_FIFO {64} \
  CONFIG.IO_UART0_TX_FIFO {64} \
  CONFIG.IO_WDT_EN {true} \
  CONFIG.IO_TWI_EN {true} \
  CONFIG.IO_TWI_FIFO {16} \
  CONFIG.OCD_EN {true} \
  CONFIG.OCD_JEDEC_ID {"11101000010"} \
  CONFIG.OCD_NUM_HW_TRIGGERS {4} \
  CONFIG.PMP_MIN_GRANULARITY {4096} \
  CONFIG.PMP_NAP_MODE_EN {true} \
  CONFIG.PMP_NUM_REGIONS {4} \
  CONFIG.PMP_TOR_MODE_EN {true} \
  CONFIG.RISCV_ISA_C {true} \
  CONFIG.RISCV_ISA_M {true} \
  CONFIG.RISCV_ISA_U {true} \
  CONFIG.RISCV_ISA_Zaamo {true} \
  CONFIG.RISCV_ISA_Zalrsc {true} \
  CONFIG.RISCV_ISA_Zicntr {true} \
  CONFIG.RISCV_ISA_Zihpm {true} \
  CONFIG.XBUS_EN {true} \
  CONFIG.XBUS_REGSTAGE_EN {true} \
] [get_bd_cells neorv32_vivado_ip_0]

connect_bd_net [get_bd_pins neorv32_vivado_ip_0/clk] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/resetn] [get_bd_pins clk_wiz_0/locked]

# -------------------------------------------------------------
# On-board buttons and switches
# -------------------------------------------------------------

create_bd_port -dir I -from 15 -to 0 SW
create_bd_port -dir I -from 4 -to 0 BTN

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconcat:1.0 ilconcat_0
set_property -dict [list CONFIG.IN0_WIDTH.VALUE_SRC USER CONFIG.IN1_WIDTH.VALUE_SRC USER] [get_bd_cells ilconcat_0]
set_property -dict [list \
  CONFIG.NUM_PORTS {4} \
  CONFIG.IN0_WIDTH {16} \
  CONFIG.IN1_WIDTH {5} \
  CONFIG.IN2_WIDTH {1} \
  CONFIG.IN3_WIDTH {1} \
] [get_bd_cells ilconcat_0]

connect_bd_net [get_bd_ports SW] [get_bd_pins ilconcat_0/In0]
connect_bd_net [get_bd_ports BTN] [get_bd_pins ilconcat_0/In1]
connect_bd_net [get_bd_pins ilconcat_0/dout] [get_bd_pins neorv32_vivado_ip_0/gpio_i]

# -------------------------------------------------------------
# On-board LEDs
# -------------------------------------------------------------

# *****************************
# green LEDs
# *****************************

create_bd_port -dir O -from 15 -to 0 LED
create_bd_port -dir O -from 2 -to 0 RGB0
create_bd_port -dir O -from 2 -to 0 RGB1

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_2
set_property -dict [list \
  CONFIG.DIN_WIDTH {32} \
  CONFIG.DIN_FROM {15} \
  CONFIG.DIN_TO {0} \
] [get_bd_cells ilslice_2]
connect_bd_net [get_bd_pins ilslice_2/Din] [get_bd_pins neorv32_vivado_ip_0/gpio_o]
connect_bd_net [get_bd_ports LED] [get_bd_pins ilslice_2/Dout]

# *****************************
# 7-segment displays
# *****************************

create_bd_port -dir O -from 7 -to 0 SEG
create_bd_port -dir O -from 7 -to 0 AN

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_4
set_property -dict [list \
  CONFIG.DIN_WIDTH {32} \
  CONFIG.DIN_FROM {23} \
  CONFIG.DIN_TO {16} \
] [get_bd_cells ilslice_4]
connect_bd_net [get_bd_pins ilslice_4/Din] [get_bd_pins neorv32_vivado_ip_0/gpio_o]

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic:1.0 ilvector_logic_1
set_property -dict [list \
  CONFIG.C_OPERATION {not} \
  CONFIG.C_SIZE {8} \
] [get_bd_cells ilvector_logic_1]
connect_bd_net [get_bd_pins ilslice_4/Dout] [get_bd_pins ilvector_logic_1/Op1]
connect_bd_net [get_bd_ports SEG] [get_bd_pins ilvector_logic_1/Res]

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_5
set_property -dict [list \
  CONFIG.DIN_FROM {31} \
  CONFIG.DIN_TO {24} \
] [get_bd_cells ilslice_5]
connect_bd_net [get_bd_pins ilslice_5/Din] [get_bd_pins neorv32_vivado_ip_0/gpio_o]

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilvector_logic:1.0 ilvector_logic_0
set_property -dict [list \
  CONFIG.C_OPERATION {not} \
  CONFIG.C_SIZE {8} \
] [get_bd_cells ilvector_logic_0]
connect_bd_net [get_bd_ports AN] [get_bd_pins ilvector_logic_0/Res]
connect_bd_net [get_bd_pins ilvector_logic_0/Op1] [get_bd_pins ilslice_5/Dout]

# *****************************
# tri-color LEDs
# *****************************

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_0
set_property -dict [list \
  CONFIG.DIN_WIDTH {7} \
  CONFIG.DIN_FROM {2} \
  CONFIG.DIN_TO {0} \
] [get_bd_cells ilslice_0]

connect_bd_net [get_bd_ports RGB0] [get_bd_pins ilslice_0/Dout]
connect_bd_net [get_bd_pins ilslice_0/Din] [get_bd_pins neorv32_vivado_ip_0/pwm_o]

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_1
set_property -dict [list \
  CONFIG.DIN_WIDTH {7} \
  CONFIG.DIN_FROM {5} \
  CONFIG.DIN_TO {3} \
] [get_bd_cells ilslice_1]

connect_bd_net [get_bd_ports RGB1] [get_bd_pins ilslice_1/Dout]
connect_bd_net [get_bd_pins ilslice_1/Din] [get_bd_pins neorv32_vivado_ip_0/pwm_o]

# -------------------------------------------------------------
# On-board USB-UART bridge
# -------------------------------------------------------------

create_bd_port -dir I UART_TXD_IN
create_bd_port -dir O UART_RXD_OUT
create_bd_port -dir O UART_CTS
create_bd_port -dir I UART_RTS

connect_bd_net [get_bd_ports UART_TXD_IN] [get_bd_pins neorv32_vivado_ip_0/uart0_rxd_i]
connect_bd_net [get_bd_ports UART_RXD_OUT] [get_bd_pins neorv32_vivado_ip_0/uart0_txd_o]
connect_bd_net [get_bd_ports UART_CTS] [get_bd_pins neorv32_vivado_ip_0/uart0_rtsn_o]
connect_bd_net [get_bd_ports UART_RTS] [get_bd_pins neorv32_vivado_ip_0/uart0_ctsn_i]

# -------------------------------------------------------------
# JTAG interface (PMOD JD)
# -------------------------------------------------------------

create_bd_port -dir I JTAG_TCK
create_bd_port -dir I JTAG_TMS
create_bd_port -dir I JTAG_TDI
create_bd_port -dir O JTAG_TDO

connect_bd_net [get_bd_ports JTAG_TCK] [get_bd_pins neorv32_vivado_ip_0/jtag_tck_i]
connect_bd_net [get_bd_ports JTAG_TMS] [get_bd_pins neorv32_vivado_ip_0/jtag_tms_i]
connect_bd_net [get_bd_ports JTAG_TDI] [get_bd_pins neorv32_vivado_ip_0/jtag_tdi_i]
connect_bd_net [get_bd_ports JTAG_TDO] [get_bd_pins neorv32_vivado_ip_0/jtag_tdo_o]

# -------------------------------------------------------------
# On-board I2C temperature sensor
# -------------------------------------------------------------

create_bd_cell -type module -reference tristate_buffer tristate_buffer_2
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/twi_sda_o] [get_bd_pins tristate_buffer_2/T]
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/twi_sda_o] [get_bd_pins tristate_buffer_2/I]
connect_bd_net [get_bd_pins tristate_buffer_2/O] [get_bd_pins neorv32_vivado_ip_0/twi_sda_i]
create_bd_port -dir IO TMP_SDA
connect_bd_net [get_bd_ports TMP_SDA] [get_bd_pins tristate_buffer_2/IO]

create_bd_cell -type module -reference tristate_buffer tristate_buffer_3
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/twi_scl_o] [get_bd_pins tristate_buffer_3/T]
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/twi_scl_o] [get_bd_pins tristate_buffer_3/I]
connect_bd_net [get_bd_pins tristate_buffer_3/O] [get_bd_pins neorv32_vivado_ip_0/twi_scl_i]
create_bd_port -dir IO TMP_SCL
connect_bd_net [get_bd_ports TMP_SCL] [get_bd_pins tristate_buffer_3/IO]

# -------------------------------------------------------------
# On-board mono PWM audio
# -------------------------------------------------------------

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_6
set_property -dict [list \
  CONFIG.DIN_WIDTH {7} \
  CONFIG.DIN_FROM {6} \
  CONFIG.DIN_TO {6} \
] [get_bd_cells ilslice_6]

connect_bd_net [get_bd_pins ilslice_6/Din] [get_bd_pins neorv32_vivado_ip_0/pwm_o]

create_bd_cell -type module -reference tristate_buffer tristate_buffer_4
create_bd_port -dir IO AUD_PWM
connect_bd_net [get_bd_ports AUD_PWM] [get_bd_pins tristate_buffer_4/IO]
connect_bd_net [get_bd_pins ilslice_6/Dout] [get_bd_pins tristate_buffer_4/T]
connect_bd_net [get_bd_pins ilslice_6/Dout] [get_bd_pins tristate_buffer_4/I]

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilconstant:1.0 ilconstant_0
set_property -dict [list \
  CONFIG.CONST_VAL {1} \
  CONFIG.CONST_WIDTH {1} \
] [get_bd_cells ilconstant_0]

create_bd_port -dir O AUD_SD
connect_bd_net [get_bd_ports AUD_SD] [get_bd_pins ilconstant_0/dout]

# -------------------------------------------------------------
# On-board SPI flash & SD-card
# -------------------------------------------------------------

create_bd_port -dir O SD_RST
create_bd_port -dir O SD_CSN
create_bd_port -dir O SD_SCK
create_bd_port -dir O SD_SDI
create_bd_port -dir I SD_SDO

create_bd_port -dir O FLASH_CSN
create_bd_port -dir O FLASH_SDI
create_bd_port -dir I FLASH_SDO

create_bd_cell -type module -reference spi_connect spi_connect_0

create_bd_cell -type inline_hdl -vlnv xilinx.com:inline_hdl:ilslice:1.0 ilslice_3
set_property -dict [list \
  CONFIG.DIN_WIDTH {8} \
  CONFIG.DIN_FROM {1} \
  CONFIG.DIN_TO {0} \
] [get_bd_cells ilslice_3]
connect_bd_net [get_bd_pins neorv32_vivado_ip_0/spi_csn_o] [get_bd_pins ilslice_3/Din]
connect_bd_net [get_bd_pins ilslice_3/Dout] [get_bd_pins spi_connect_0/spi_csn_i]

connect_bd_net [get_bd_pins spi_connect_0/spi_sdo_o] [get_bd_pins neorv32_vivado_ip_0/spi_dat_i]
connect_bd_net [get_bd_pins spi_connect_0/spi_clk_i] [get_bd_pins neorv32_vivado_ip_0/spi_clk_o]
connect_bd_net [get_bd_pins spi_connect_0/spi_sdi_i] [get_bd_pins neorv32_vivado_ip_0/spi_dat_o]

connect_bd_net [get_bd_ports SD_RST] [get_bd_pins spi_connect_0/card_rst_o]
connect_bd_net [get_bd_ports SD_CSN] [get_bd_pins spi_connect_0/card_csn_o]
connect_bd_net [get_bd_ports SD_SCK] [get_bd_pins spi_connect_0/card_clk_o]
connect_bd_net [get_bd_ports SD_SDI] [get_bd_pins spi_connect_0/card_sdo_o]
connect_bd_net [get_bd_ports SD_SDO] [get_bd_pins spi_connect_0/card_sdi_i]

connect_bd_net [get_bd_ports FLASH_CSN] [get_bd_pins spi_connect_0/flash_csn_o]
connect_bd_net [get_bd_ports FLASH_SDI] [get_bd_pins spi_connect_0/flash_sdo_o]
connect_bd_net [get_bd_ports FLASH_SDO] [get_bd_pins spi_connect_0/flash_sdi_i]

# -------------------------------------------------------------
# AXI Subsystem
# -------------------------------------------------------------

# *****************************
# Interconnect
# *****************************

create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0
set_property -dict [list \
  CONFIG.NUM_MI {2} \
  CONFIG.NUM_SI {1} \
] [get_bd_cells smartconnect_0]
connect_bd_intf_net [get_bd_intf_pins smartconnect_0/S00_AXI] [get_bd_intf_pins neorv32_vivado_ip_0/m_axi]
connect_bd_net [get_bd_pins smartconnect_0/aclk] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins smartconnect_0/aresetn] [get_bd_pins clk_wiz_0/locked]

# *****************************
# GPIO controller 0
# *****************************

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0
set_property -dict [list \
  CONFIG.C_GPIO_WIDTH {8} \
  CONFIG.C_INTERRUPT_PRESENT {1} \
] [get_bd_cells axi_gpio_0]

connect_bd_net [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins clk_wiz_0/locked]
connect_bd_intf_net [get_bd_intf_pins axi_gpio_0/S_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI]

create_bd_cell -type module -reference tristate_buffer tristate_buffer_0
set_property CONFIG.WIDTH {8} [get_bd_cells tristate_buffer_0]

connect_bd_net [get_bd_pins tristate_buffer_0/T] [get_bd_pins axi_gpio_0/gpio_io_t]
connect_bd_net [get_bd_pins tristate_buffer_0/I] [get_bd_pins axi_gpio_0/gpio_io_o]
connect_bd_net [get_bd_pins axi_gpio_0/gpio_io_i] [get_bd_pins tristate_buffer_0/O]

create_bd_port -dir IO -from 7 -to 0 JB
connect_bd_net [get_bd_ports JB] [get_bd_pins tristate_buffer_0/IO]

connect_bd_net [get_bd_pins axi_gpio_0/ip2intc_irpt] [get_bd_pins ilconcat_0/In2]

# *****************************
# GPIO controller 1
# *****************************

create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_1
set_property location {4 1257 309} [get_bd_cells axi_gpio_1]
set_property -dict [list \
  CONFIG.C_GPIO_WIDTH {8} \
  CONFIG.C_INTERRUPT_PRESENT {1} \
] [get_bd_cells axi_gpio_1]

connect_bd_net [get_bd_pins axi_gpio_1/s_axi_aclk] [get_bd_pins clk_wiz_0/clk_out1]
connect_bd_net [get_bd_pins axi_gpio_1/s_axi_aresetn] [get_bd_pins clk_wiz_0/locked]
connect_bd_intf_net [get_bd_intf_pins axi_gpio_1/S_AXI] [get_bd_intf_pins smartconnect_0/M01_AXI]

create_bd_cell -type module -reference tristate_buffer tristate_buffer_1
set_property CONFIG.WIDTH {8} [get_bd_cells tristate_buffer_1]

connect_bd_net [get_bd_pins axi_gpio_1/gpio_io_i] [get_bd_pins tristate_buffer_1/O]
connect_bd_net [get_bd_pins tristate_buffer_1/T] [get_bd_pins axi_gpio_1/gpio_io_t]
connect_bd_net [get_bd_pins tristate_buffer_1/I] [get_bd_pins axi_gpio_1/gpio_io_o]

create_bd_port -dir IO -from 7 -to 0 JC
connect_bd_net [get_bd_ports JC] [get_bd_pins tristate_buffer_1/IO]

connect_bd_net [get_bd_pins axi_gpio_1/ip2intc_irpt] [get_bd_pins ilconcat_0/In3]

# *****************************
# Address map
# *****************************

assign_bd_address -target_address_space /neorv32_vivado_ip_0/m_axi [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
set_property offset 0xF0000000 [get_bd_addr_segs {neorv32_vivado_ip_0/m_axi/SEG_axi_gpio_0_Reg}]

assign_bd_address -target_address_space /neorv32_vivado_ip_0/m_axi [get_bd_addr_segs axi_gpio_1/S_AXI/Reg] -force
set_property offset 0xF0010000 [get_bd_addr_segs {neorv32_vivado_ip_0/m_axi/SEG_axi_gpio_1_Reg}]

# -------------------------------------------------------------
# Finalize block design
# -------------------------------------------------------------

regenerate_bd_layout
regenerate_bd_layout -routing
validate_bd_design
save_bd_design
