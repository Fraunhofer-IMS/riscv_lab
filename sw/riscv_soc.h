// ================================================================================ //
// Fraunhofer IMS RISC-V Lab - Basic SoC IO Hardware Abstraction Layer              //
// Copyright (c) 2025 Fraunhofer IMS. All rights reserved.                          //
// Licensed under the BSD-3-Clause license, see LICENSE for details.                //
// SPDX-License-Identifier: BSD-3-Clause                                            //
// ================================================================================ //

#ifndef RISCV_SOC_H
#define RISCV_SOC_H

#include <stdint.h>

/**************************************************************************
 * On-board green LEDs; high-active
 * Connected NEORV32.GPIO.gpio_o
 **************************************************************************/
#define LED_0  (0) // right-most LED
#define LED_1  (1)
#define LED_2  (2)
#define LED_3  (3)
#define LED_4  (4)
#define LED_5  (5)
#define LED_6  (6)
#define LED_7  (7)
#define LED_8  (8)
#define LED_9  (9)
#define LED_10 (10)
#define LED_11 (11)
#define LED_12 (12)
#define LED_13 (13)
#define LED_14 (14)
#define LED_15 (15) // left-most LED


/**************************************************************************
 * On-board seven-segment display; high-active
 * Connected NEORV32.GPIO.gpio_o
 **************************************************************************/
#define DIGIT_7 (1<<31) // digit 7 (left-most display)
#define DIGIT_6 (1<<30) // digit 6
#define DIGIT_5 (1<<29) // digit 5
#define DIGIT_4 (1<<28) // digit 4
#define DIGIT_3 (1<<27) // digit 3
#define DIGIT_2 (1<<26) // digit 2
#define DIGIT_1 (1<<25) // digit 1
#define DIGIT_0 (1<<24) // digit 0 (right-most display)
#define SEG_A   (1<<16) // segment A
#define SEG_B   (1<<17) // segment B
#define SEG_C   (1<<18) // segment C
#define SEG_D   (1<<19) // segment D
#define SEG_E   (1<<20) // segment E
#define SEG_F   (1<<21) // segment F
#define SEG_G   (1<<22) // segment G
#define SEG_DP  (1<<23) // segment DP


/**************************************************************************
 * On-board RGB LEDs; high-active
 * Connected to NEORV32.PWM.pwm_o
 **************************************************************************/
#define RGB0_RED   (0) // RGB0 = LED16
#define RGB0_GREEN (1)
#define RGB0_BLUE  (2)
#define RGB1_RED   (3) // RGB1 = LED17
#define RGB1_GREEN (4)
#define RGB1_BLUE  (5)


/**************************************************************************
 * On-board switches; high-active
 * Connected to NEORV32.GPIO.gpio_i
 **************************************************************************/
#define SW_0  (0) // right-most switch
#define SW_1  (1)
#define SW_2  (2)
#define SW_3  (3)
#define SW_4  (4)
#define SW_5  (5)
#define SW_6  (6)
#define SW_7  (7)
#define SW_8  (8)
#define SW_9  (9)
#define SW_10 (10)
#define SW_11 (11)
#define SW_12 (12)
#define SW_13 (13)
#define SW_14 (14)
#define SW_15 (15) // left-most switch


/**************************************************************************
 * On-board buttons; high-active
 * Connected to NEORV32.GPIO.gpio_i
 **************************************************************************/
#define BTNC (16) // center
#define BTNU (17) // up
#define BTNL (18) // left
#define BTNR (19) // right
#define BTND (20) // down


/**************************************************************************
 * On-board audio jacket
 * Connected to NEORV32.PWM.pwm_o
 **************************************************************************/
#define AUDIO_PWM (6)


/**************************************************************************
 * On-board I2C temperature sensor
 * Connected to NEORV32.TWI
 **************************************************************************/
#define I2C_TEMP_SENSE_WADDR (0x96) // write address
#define I2C_TEMP_SENSE_RADDR (0x97) // read address


/**********************************************************************//**
 * AMD Vivado AXI GPIO controller
 * Connected to NEORV32.XBUS
 **************************************************************************/
// register layout
typedef volatile struct __attribute__((packed,aligned(4))) {
  uint32_t PORT;            // port input/output data
  uint32_t DIR;             // direction control, 0=output, 1=input
  const uint32_t _res0[69]; // unused
  uint32_t GIE;             // global interrupt enable (single bit at position 31)
  uint32_t IS;              // interrupt status (single bit at position 0)
  const uint32_t _res1[1];  // unused
  uint32_t IE;              // interrupt enable (single bit at position 0)
} axi_gpio_t;

// AXI GPIO controller hardware handles
#define AXI_GPIO_0 ((axi_gpio_t*) (0xF0000000U))
#define AXI_GPIO_1 ((axi_gpio_t*) (0xF0010000U))

// pin-change interrupts (high-active) routed to NEORV32.GPIO.gpio_in
#define AXI_GPIO_0_IRQ (21)
#define AXI_GPIO_1_IRQ (22)


/**********************************************************************//**
 * Helper function for minimal SoC setup
 **************************************************************************/
void riscv_soc_setup(void) {
  neorv32_rte_setup();           // initialize NENORV32 runtime environment
  neorv32_uart0_setup(19200, 0); // setup UART at default baud rate, no interrupts
}


/**********************************************************************//**
 * Helper function for busy wait
 **************************************************************************/
void wait_ms(int ms) {
  neorv32_aux_delay_ms(neorv32_sysinfo_get_clk(), ms);
}


#endif // RISCV_SOC_H
