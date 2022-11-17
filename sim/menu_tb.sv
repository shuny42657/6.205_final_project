`default_nettype none
`timescale 1ns / 1ps
module menu_tb;

logic clk;
logic rst;

logic[10:0] hcount_in;
logic[9:0] vcount_in;
logic[1:0] state_in;

logic busy_out;
logic finished_out;
logic[11:0] pixel_out;

menu uut(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_in),
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
        $dumpfile("menu.vcd");
        $dumpvars(0,menu_tb);

	rst = 1;
	clk = 0;
	#20;
	rst = 0;
	for(int i = 0;i<100;i++)begin
		hcount_in = 0;
		vcount_in = 0;
		state_in = 4'b0000;
		#20;
	end

	$display("Finishing Sim");
        $finish;

end


endmodule
`default_nettype wire

