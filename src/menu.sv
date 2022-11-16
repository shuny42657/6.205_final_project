`default_nettype none
`timescale 1ns / 1ps
module menu(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[3:0] state_in,

	output logic busy_out,
	output logic finished_out,
	output logic[11:0] pixel_out
);

logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
block_sprite #(768,8,128,384,12'hFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(8,192,128,384,12'hFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(8,192,888,384,12'hFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(768,8,128,568,12'hFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));

logic busy_out_buffer;
logic[3:0] old_state_in;
logic[31:0] timing_count;
always_comb begin
	if(busy_out_buffer == 1)begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel;
	end
end
always_ff @(posedge clk)begin
	if(rst)begin
		finished_out <= 0;
		busy_out_buffer <= 0;
		old_state_in = 4'b1010;
	end
	else begin
		if(old_state_in != state_in && state_in == 4'b0000)begin
			busy_out_buffer <= 1;
			timing_count <= 0;
		end
		if(busy_out_buffer == 1)begin
			timing_count <= timing_count + 1;
			if(timing_count == 5*6500000)begin
				timing_count <= 0;
				finished_out <= 1;
				busy_out_buffer <= 0;
			end
		end
		if(finished_out == 1)
			finished_out <= 0;
		old_state_in <= state_in;
	end
end
assign busy_out = busy_out_buffer;
//assign finished_out = 0;
endmodule
`default_nettype wire

