`default_nettype none
`timescale 1ns / 1ps

module enemy_tb;

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

initial begin
	$display("Starting Sim");
	$dumpfile("enemy.vcd");
	$dumpvars(0,enemy_tb);
	rst = 1;
	clk = 0;
	#20;
	rst = 0;
	for(int i = 0;i<30;i++)begin
		hcount_in = 0;
		vcount_in = 0;
		state_in = 4'b1000;
		turn_in = 0;
		rotate_in = 2'b0;
		#20;
	end
	#100;
	$display("Finishing Sim");
	$finish;
end


endmodule
`default_nettype wire
