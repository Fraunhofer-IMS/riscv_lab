# Recreate the RISC-V demo setup for the Nexys A7 FPGA board
# copyright (c) 2025 Fraunhofer IMS, 47057 Duisburg, Germany
# author: nolting
# Licensed under the BSD-3-Clause license, see LICENSE for details. 
# SPDX-License-Identifier: BSD-3-Clause   
# author: nolting

default: help

# recreate Vivado project file from tcl script
project:
	vivado -mode batch -notrace -source project_setup.tcl

# open Vivado project in GUI
gui:
	vivado work/$(PROJ_NAME).xpr

# help menu
help:
	@echo "Digilent Nexys A7 RISC-V Lab Setup"
	@echo ""
	@echo "Targets:"
	@echo "  project - (re-)create Vivado project"
	@echo "  gui     - open Vivado project in GUI mode"
	@echo "  help    - show this menu"
	@echo "  clean   - remove all artifacts"

# remove ALL(!) Vivado artifacts
clean:
	rm -rf work/
	rm -f *.log *.jou *.str
	rm -f *_webtalk.html *_webtalk.xml
	rm -rf sdcard/
