// SPI interface wiring
// copyright (c) 2025 Fraunhofer IMS, 47057 Duisburg, Germany
// Licensed under the BSD-3-Clause license, see LICENSE for details.
// SPDX-License-Identifier: BSD-3-Clause
// author: nolting

module spi_connect (
  // host
  input        spi_clk_i,
  input        spi_sdi_i,
  output       spi_sdo_o,
  input  [1:0] spi_csn_i,
  // SD card
  output       card_rst_o,
  output       card_csn_o,
  output       card_clk_o,
  input        card_sdi_i,
  output       card_sdo_o,
  // SPI flash
  output       flash_csn_o,
  input        flash_sdi_i,
  output       flash_sdo_o
);

  // this primitive is required to get access to the clock
  // pin of the FPGA configuration memory from user logic
  STARTUPE2 #(
    .PROG_USR      ("FALSE"),
    .SIM_CCLK_FREQ (0.0)
  ) STARTUPE2_inst (
    .CFGCLK    (),
    .CFGMCLK   (),
    .EOS       (),
    .PREQ      (),
    .CLK       (1'b0),
    .GSR       (1'b0),
    .GTS       (1'b0),
    .KEYCLEARB (1'b0),
    .PACK      (1'b0),
    .USRCCLKO  (spi_clk_i),
    .USRCCLKTS (1'b0),
    .USRDONEO  (1'b1),
    .USRDONETS (1'b1)
  );

  // SPI flash
  assign flash_csn_o = spi_csn_i[0];
  assign flash_sdo_o = spi_sdi_i;

  // SPI SD-card
  assign card_rst_o = 1'b0;
  assign card_csn_o = spi_csn_i[1];
  assign card_clk_o = spi_clk_i;
  assign card_sdo_o = spi_sdi_i;

  // SPI serial data feedback
  assign spi_sdo_o = (spi_csn_i[0] == 1'b0) ? flash_sdi_i : card_sdi_i;

endmodule
