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

//shield
logic[11:0] shield_out;
shield player_shield(.hcount_in(hcount_in),.vcount_in(vcount_in),.rotate_in(2'b00),.pixel_out(shield_out));

logic[9:0] timings[71:0];
logic[9:0] speeds[71:0];
logic[9:0] directions[47:0];
logic[9:0] inverseds[23:0];
//patterns
pattern #(72'h249_249_249_249_249_249,72'h249_249_249_249_249_249,48'h0,24'h0,0) pattern1(.turn_in(turn_in),.valid_out(1),.timing(timings[0]),.speed(speeds[0]),.direction(directions[0]),.inversed(inverseds[0]));


//logic[23:0] arrow_on;
//24 arrows
logic[23:0] arrow_valid_in;
logic[23:0] arrow_out[11:0];
logic[23:0] arrow_valid_out;
arrow #(8,32) arrow1(.clk(clk),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[0]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.pixel_out(arrow_out[0]),.valid_out(arrow_valid_out[0]));
arrow #(8,32) arrow2(.clk(clk),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[1]),.speed_in(0),.direction_in(2'b01),.inversed_in(0),.pixel_out(arrow_out[1]),.valid_out(arrow_valid_out[1]));
arrow #(8,32) arrow3(.clk(clk),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[2]),.speed_in(0),.direction_in(2'b10),.inversed_in(0),.pixel_out(arrow_out[2]),.valid_out(arrow_valid_out[2]));

logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
block_sprite #(160,8,432,304,12'hFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(8,160,432,304,12'hFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(8,160,584,304,12'hFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(160,8,432,456,12'hFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));

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
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + arrow_out[0] + arrow_out[1] + arrow_out[2];
	end
end


logic[31:0] timing_count;
logic[6:0] arrow_count;
logic[3:0] old_state_in; //detecting rising edge at the beginning of each phase
always_ff @(posedge clk)begin
	if(rst)begin
		busy_out_buffer <= 0;
		finished_out <= 0;
		timing_count <= 0;
		old_state_in <= 4'b1010;
		//pixel_out <= 0;
	end else begin
		if(state_in == 4'b1000 && old_state_in != state_in)begin
			busy_out_buffer <= 1;
			timing_count <= 0;
			arrow_count <= 0;
			arrow_valid_in <= 24'h000001;
		end

		//if(busy_out_buffer)begin
		//if(hcount_in == 0 && vcount_in == 0)begin

		timing_count <= timing_count + 1;
                if(timing_count == /*timings[0][arrow_count+:3]*/650000000)begin
                        //arrow_valid_in <= 24'h000003;
			arrow_valid_in <= {arrow_valid_in[22:0],1'b1};
                        timing_count <= 0;
			arrow_count <= arrow_count + 3;
                end
		//end

		//end
		/*if(busy_out_buffer)begin
			if(hcount_in == 0 && vcount_in == 0)begin
				//arrow_valid_in <= 0;
				//arrow_valid_in = 24'h000003;
				timing_count <= timing_count + 1;
				if(timing_count == 10)begin
					timing_count <= 0;
					arrow_valid_in <= 24'h000003;
					//arrow_valid_in[1] <= 0;
				end
			end
		old_state_in <= state_in;
		end*/
	        old_state_in <= state_in;
	end
	//output the pixel value from 24 arrows, heart, etc. 
	//alpha blending
	//interval control
end

assign busy_out = busy_out_buffer;
endmodule
`default_nettype wire

