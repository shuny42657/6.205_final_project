`default_nettype none
`timescale 1ns / 1ps

module enemy;

logic clk;
logic rst;

logic [10:0] hcount_in;
logic [9:0] vcount_in;
logic [3:0] state_in;
logic [3:0] turn_in;
logic [1:0] rotate_in;

logic busy_out;
logic finished_out;
logic [11:0] pixel_out;
enemy uut(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_in),
	.turn_in(turn_in),
	.rotate_in(rotate_in),
	.busy_out(busy_out),
	.finished_out(finished_out),
	.pixel_out(pixel_out)
);

always begin
	#10;
       	clk = !clk;
end


endmodule
`default_nettype wire
