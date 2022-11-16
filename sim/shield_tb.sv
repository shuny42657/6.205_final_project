`default_nettype none
`timescale 1ns / 1ps

module shield_tb;
logic[10:0] hcount_in;
logic[9:0] vcount_in;
logic[1:0] rotate_in;

logic[11:0] pixel_out;

shield uut(
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.rotate_in(rotate_in),
	.pixel_out(pixel_out)
);

initial begin
	$display("Starting Sim");
        $dumpfile("shield.vcd");
        $dumpvars(0,shield_tb);

	for(int i = 0;i < 100;i++)begin
		hcount_in = 0;
		vcount_in = 0;
		rotate_in = 2'b00;
		#20;
	end
	$display("Finishing Sim");
        $finish;


end


endmodule
`default_nettype wire

