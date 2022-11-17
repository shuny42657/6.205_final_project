`default_nettype none
`timescale 1ns / 1ps
module game_state_tb;
logic clk;
logic rst;
logic[10:0] hcount_in;
logic[9:0] vcount_in;
logic[1:0] rotate_in;

logic[11:0] pixel_out;

game_state uut(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.rotate_in(rotate_in),
	.pixel_out(pixel_out)
);

always begin
        #10;
        clk = !clk;
end
initial begin
        $display("Starting Sim");
        $dumpfile("game_state.vcd");
        $dumpvars(0,game_state_tb);

        rst = 1;
        clk = 0;
        #20;
        rst = 0;
        for(int i = 0;i<1000;i++)begin
                hcount_in = 0;
                vcount_in = 0;
                rotate_in = 4'b0000;
                #20;
        end

        $display("Finishing Sim");
        $finish;

end

endmodule
`default_nettype wire

