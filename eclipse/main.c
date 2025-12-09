// ================================================================================ //
// Fraunhofer IMS RISC-V Lab - Simple example program                               //
// Copyright (c) 2025 Fraunhofer IMS. All rights reserved.                          //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

#include <neorv32.h>
#include <stdint.h>
#include <stdio.h>
#include "riscv_soc.h"

int main() {

  // initialize RISC-V SoC platform
  riscv_soc_setup();

  // configure PMOD GPIO ports as inputs
  AXI_GPIO_0->DIR = 0xff;
  AXI_GPIO_1->DIR = 0xff;

  // say hello
  printf("Fraunhofer IMS RISC-V Lab\r\n");
  printf("Hello world! :)\r\n");

  // clear entire gpio_o port clearing the green LEDs
  // and also the 7-segment displays
  neorv32_gpio_port_set(0);

  // turn on one green LED after another
  int i = 0;
  for (i = LED_0; i <= LED_15; i++) {
    neorv32_gpio_pin_set(i, 1);
    wait_ms(40); // wait ~40ms
  }
  // turn off one green LED after another
  for (i = LED_0; i <= LED_15; i++) {
    neorv32_gpio_pin_set(i, 0);
    wait_ms(40); // wait ~40ms
  }

  // print NEORV32 hardware configuration
  neorv32_aux_print_hw_config();

  return 0;
}
