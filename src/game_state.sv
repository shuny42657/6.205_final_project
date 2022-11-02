`timescale 1ns / 1ps
`default_nettype none

module game_state(
	input wire clk,
	input wire rst,

	input wire [10:0] hcount_in,
	input wire[9:0] vcount_in,

	output logic[15:0] pixel_out
);

logic[3:0] state_out;

assign state_out = 4'b1000;

endmodule
`default_nettype wire
