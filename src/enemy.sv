`default_nettype none
`timescale 1ns / 1ps

module enemy(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in, //hcount
	input wire[9:0] vcount_in, //vcount
	input wire[3:0] state_in, //used to check if this module is busy
	input wire[3:0] turn_in, //to determine which pattern to adapt
	input wire[1:0] rotate_in, //input from camera interaction

	output logic busy_out, //busy while this is high
	output logic finished_out, //asserted high for one clk cycle when the module exits busy state
	output logic pixel_out //pixel output
);

//patterns


//24 arrows



always_ff @(posedge clk)begin
	if(rst)begin
		busy_out <= 0;
		finished_out <= 0;
		pixel_out <= 0
	end

	//output the pixel value from 24 arrows, heart, etc. 
	//alpha blending
	//interval control
end
endmodule
`default_nettype wire

