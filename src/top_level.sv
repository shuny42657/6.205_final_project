`timescale 1ns / 1ps
`default_nettype none

module top_level(
	input wire clk_100mhz,
	input wire btnc, btnu, btnl, btnr, btnd,

	output logic [3:0] vga_r,vga_g,vga_b,
	output logic vga_hs,vga_vs
)
endmodule

logic clk_65mhz;

clk_wiz clk_gen(
	clk_in1(clk_100mhz),
	clk_out1(clk_65mhz)
);

logic [10:0] hcount;    // pixel on current line
logic [9:0] vcount;     // line number
logic hsync, vsync, blank; //control signals for vga
vga vga_gen(
	.pixel_clk_in(clk_65mhz),
	.hcount_out(hcount),
    	.vcount_out(vcount),
    	.hsync_out(hsync),
    	.vsync_out(vsync),
    	.blank_out(blank));

logic[11:0] color;
game_state gm(
	.clk(clk_65mha),
	.rst(btnc),
	.hcount_in(hcount),
	.vcount_in(vcount),
	.pixel_out(color));

assign vga_r = ~blank ? color[11:8]: 0;
assign vga_g = ~blank ? color[7:4] : 0;
assign vga_b = ~blank ? color[3:0] : 0;

assign vga_hs = ~hsync;
assign vga_vs = ~vsync;

`default_nettype wire
