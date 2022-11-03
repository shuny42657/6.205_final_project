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
	output logic[11:0] pixel_out //pixel output
);
logic busy_out_buffer;

//patterns
//pattern pattern1#(72'hFFFF_FFFF_FFFF_FFFF_FF,72'h249_249_249_249_249_249,48'h)

//24 arrows

logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
block_sprite #(128,16,256,256,12'hFFFFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(16,128,256,256,12'hFFFFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(16,128,368,256,12'hFFFFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(128,16,256,368,12'hFFFFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));

always_comb begin
	if(busy_out_buffer)begin
		/*if(frame_top_out)
                	pixel_out = frame_top_pixel;
        	if(frame_bottom_out)
                	pixel_out = frame_bottom_pixel;
        	if(frame_right_out)
                	pixel_out = frame_right_pixel;
        	if(frame_left_out)
                	pixel_out = frame_left_pixel;*/
		pixel_out =frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel;
	end
end



always_ff @(posedge clk)begin
	if(rst)begin
		busy_out_buffer <= 0;
		finished_out <= 0;
		//pixel_out <= 0;
	end else begin
		if(state_in == 4'b1000)begin
			busy_out_buffer <= 1;
		end
	end

	//output the pixel value from 24 arrows, heart, etc. 
	//alpha blending
	//interval control
end

assign busy_out = busy_out_buffer;
endmodule
`default_nettype wire

