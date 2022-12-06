`timescale 1ns / 1ps
`default_nettype none

`include "iverilog_hack.svh"

module image_sprite #(
  parameter WIDTH=256, HEIGHT=256,IMAGE = "undyne.mem",PALETTE = "undyne_palette.mem") (
  input wire pixel_clk_in,
  input wire rst_in,
  input wire [10:0] x_in, hcount_in,
  input wire [9:0]  y_in, vcount_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);
  // calculate rom address
  logic [7:0] image_pallet_out;
  logic [11:0] pallet_out;
  //instance
  xilinx_single_port_ram_read_first #(8,WIDTH*HEIGHT,"HIGH_PERFORMANCE",/*`FPATH(green_heart.mem)"green_heart.mem"*/IMAGE) image(.addra(image_addr),.dina(0),.clka(pixel_clk_in),.wea(0),.ena(1),.rsta(rst_in),.regcea(1),.douta(image_pallet_out));
  xilinx_single_port_ram_read_first #(12,256,"HIGH_PERFORMANCE",/*`FPATH(green_heart_palette.mem)*/PALETTE) pallet(.addra(image_pallet_out),.dina(0),.clka(pixel_clk_in),.wea(0),.ena(1),.rsta(rst_in),.regcea(1),.douta(pallet_out));
  logic [$clog2(WIDTH*HEIGHT)-1:0] image_addr;
  assign image_addr = (hcount_in - x_in) + ((vcount_in - y_in) * WIDTH);

  logic in_sprite_buffer;
  assign in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + WIDTH)) &&
                      (vcount_in >= y_in && vcount_in < (y_in + HEIGHT)));

  // Modify the line below to use your BRAMs!
  assign pixel_out = in_sprite_buffer ? pallet_out : 0;
  assign in_sprite = in_sprite_buffer;
endmodule

`default_nettype none
