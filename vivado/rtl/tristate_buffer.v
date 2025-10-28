// 7-series tri-state IO buffer
// copyright (c) 2025 Fraunhofer IMS, 47057 Duisburg, Germany
// Licensed under the BSD-3-Clause license, see LICENSE for details. 
// SPDX-License-Identifier: BSD-3-Clause
// author: nolting

module tristate_buffer #(
  parameter integer WIDTH = 1 // port with
)(
  input  [WIDTH-1:0] T, // direction (1=input, 0=output)
  input  [WIDTH-1:0] I, // pad input
  output [WIDTH-1:0] O, // pad output
  inout  [WIDTH-1:0] IO // IO pad
);

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin
      IOBUF #(
        .DRIVE        (12),        // output drive strength
        .IBUF_LOW_PWR ("TRUE"),    // low power = "TRUE", high performance = "FALSE"
        .IOSTANDARD   ("DEFAULT"), // I/O Standard
        .SLEW         ("SLOW")     // output slew rate
      ) iobuf_inst (
        .O  (O[i]),  // output from pad
        .IO (IO[i]), // bidirectional pad
        .I  (I[i]),  // input to pad
        .T  (T[i])   // tristate control
      );
    end
  endgenerate

endmodule
