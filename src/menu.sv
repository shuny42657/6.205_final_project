`default_nettype none
`timescale 1ns / 1ps
module menu(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[3:0] state_in,
	input wire[1:0] key_input_in,
	input wire decide_in,

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

logic[3:0] selected_in;
logic[11:0] attack_button_out;
logic[11:0] act_button_out;
logic[11:0] talk_button_out;
logic[11:0] mercy_button_out;
button_sprite #(126,707) attack_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.selected_in(selected_in[3]),.pixel_out(attack_button_out));
button_sprite #(332,707) act_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.selected_in(selected_in[2]),.pixel_out(act_button_out));
button_sprite #(692,707) talk_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.selected_in(selected_in[1]),.pixel_out(talk_button_out));
button_sprite #(898,707) mercy_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.selected_in(selected_in[0]),.pixel_out(mercy_button_out));
logic busy_out_buffer;
logic[3:0] old_state_in;
logic[1:0] old_key_input_in;
logic old_decide_in;
logic[31:0] timing_count;
always_comb begin
	if(busy_out_buffer == 1)begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + attack_button_out + act_button_out + talk_button_out + mercy_button_out;
	end
	else
		pixel_out = frame_bottom_pixel;
end
always_ff @(posedge clk)begin
	if(rst)begin
		finished_out <= 0;
		busy_out_buffer <= 0;
		old_state_in = 4'b1010;
		selected_in <= 4'b1000;
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
				//finished_out <= 1;
				//busy_out_buffer <= 0;
				//old_state_in = 4'b1010;
			end
			if(old_key_input_in == 2'b00 && old_key_input_in != key_input_in)begin
				if(key_input_in == 2'b01)begin
					selected_in <= {selected_in[0],selected_in[3:1]};
				end
				else if(key_input_in == 2'b10)begin
					selected_in <= {selected_in[2:0],selected_in[3]};
				end
			end
			if(old_decide_in == 0 && decide_in == 1)begin
				if(selected_in == 4'b1000)begin
					finished_out <= 1;
					busy_out_buffer <= 0;
				end
			end
			//old_state_in <= state_in;
		end
		if(finished_out == 1)begin
			finished_out <= 0;
		end
		old_state_in <= state_in;
		old_key_input_in <= key_input_in;
		old_decide_in <= decide_in;
	end
end
assign busy_out = busy_out_buffer;
//assign finished_out = 0;
endmodule
`default_nettype wire

