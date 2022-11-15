`default_nettype none
`timescale 1ns / 1ps
module arrow_tb;

logic clk;
logic rst;
logic [10:0] hcount_in;
logic [9:0] vcount_in;
logic  valid_in;
logic[2:0] speed_in;
logic[1:0] direction_in;
logic inversed_in;

logic[11:0] pixel_out;
logic valid_out;

arrow uut(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.valid_in(valid_in),
	.speed_in(speed_in),
	.direction_in(direction_in),
	.inversed_in(inversed_in),
	.pixel_out(pixel_out),
	.valid_out(valid_out)
);

always begin
        #10;
        clk = !clk;
end

initial begin
        $display("Starting Sim");
        $dumpfile("arrow.vcd");
        $dumpvars(0,arrow_tb);
        rst = 1;
        clk = 0;
        #20;
        rst = 0;
        for(int i = 0;i<30;i++)begin
                hcount_in = 0;
                vcount_in = 0;
		valid_in = 0;
		direction_in = 2'b00;
		inversed_in = 0;
		speed_in = 0;
                #20;
        end
	valid_in <= 1;
        #200;
	valid_in <= 0;
	#1000;
        $display("Finishing Sim");
        $finish;
end



endmodule
`default_nettype wire

