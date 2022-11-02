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


`default_nettype wire
