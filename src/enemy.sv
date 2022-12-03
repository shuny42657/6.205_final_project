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
	output logic damage_out,
	output logic[11:0] pixel_out //pixel output
);
logic busy_out_buffer;

//shield
logic[11:0] shield_out;
shield player_shield(.hcount_in(hcount_in),.vcount_in(vcount_in),.rotate_in(rotate_in),.pixel_out(shield_out));

logic[71:0] timings[9:0];
logic[9:0] speeds[71:0];
logic[9:0] directions[47:0];
logic[9:0] inverseds[23:0];
//patterns
pattern #(24,/*72'h249_249_249_249_249_249*/72'b000001001001001001001001001001001001001001001001001001001001001001001001,72'h249_249_249_249_249_249,48'h0,24'h0,0) pattern1(.turn_in(turn_in),.valid_out(pattern_valid_1),.arrows(arrow_max),.timing(timings[0]),.speed(speeds[0]),.direction(directions[0]),.inversed(inverseds[0]));
logic pattern_valid_1;
//assign timings[0] = 72'h249_249_249_249_249_249;
logic timing_1;
assign timing_1 = 72'b001001001001001001001001001001001001001001001001001001001001001001001001;
//logic[23:0] arrow_on;
//24 arrows
logic[23:0] arrow_valid_in;
//logic[11:0][23:0] arrow_out;
logic[23:0] arrow_out[11:0];
logic[23:0] arrow_valid_out;
logic[23:0] hit_player_out;
logic[23:0] is_hit_out;
logic[4:0] arrow_max;
arrow #(8,32) arrow1(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[0]),.speed_in(0),.direction_in(2'b00),.inversed_in(1),.rotate_in(rotate_in),.pixel_out(arrow_out_1),.valid_out(/*arrow_valid_1*/arrow_valid_out[0]),.is_hit(is_hit_out[0]),.hit_player(hit_player_out[0]));
arrow #(8,32) arrow2(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[1]),.speed_in(0),.direction_in(2'b01),.inversed_in(1),.rotate_in(rotate_in),.pixel_out(arrow_out_2),.valid_out(/*arrow_valid_2*/arrow_valid_out[1]),.is_hit(is_hit_out[1]),.hit_player(hit_player_out[1]));
arrow #(32,8) arrow3(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[2]),.speed_in(0),.direction_in(2'b10),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_3),.valid_out(/*arrow_valid_3*/arrow_valid_out[2]),.is_hit(is_hit_out[2]),.hit_player(hit_player_out[2]));
arrow #(8,32) arrow4(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[3]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_4),.valid_out(/*arrow_valid_3*/arrow_valid_out[3]),.is_hit(is_hit_out[3]),.hit_player(hit_player_out[3]));
arrow #(8,32) arrow5(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[4]),.speed_in(0),.direction_in(2'b00),.inversed_in(1),.rotate_in(rotate_in),.pixel_out(arrow_out_5),.valid_out(/*arrow_valid_3*/arrow_valid_out[4]),.is_hit(is_hit_out[4]),.hit_player(hit_player_out[4]));
arrow #(8,32) arrow6(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[5]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_6),.valid_out(/*arrow_valid_3*/arrow_valid_out[5]),.is_hit(is_hit_out[5]),.hit_player(hit_player_out[5]));
arrow #(8,32) arrow7(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[6]),.speed_in(0),.direction_in(2'b00),.inversed_in(1),.rotate_in(rotate_in),.pixel_out(arrow_out_7),.valid_out(/*arrow_valid_3*/arrow_valid_out[6]),.is_hit(is_hit_out[6]),.hit_player(hit_player_out[6]));
arrow #(8,32) arrow8(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[7]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_8),.valid_out(/*arrow_valid_3*/arrow_valid_out[7]),.is_hit(is_hit_out[7]),.hit_player(hit_player_out[7]));
arrow #(8,32) arrow9(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[8]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_9),.valid_out(/*arrow_valid_3*/arrow_valid_out[8]),.is_hit(is_hit_out[8]),.hit_player(hit_player_out[8]));
arrow #(8,32) arrow10(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[9]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_10),.valid_out(/*arrow_valid_3*/arrow_valid_out[9]),.is_hit(is_hit_out[9]),.hit_player(hit_player_out[9]));
arrow #(8,32) arrow11(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[10]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_11),.valid_out(/*arrow_valid_3*/arrow_valid_out[10]),.is_hit(is_hit_out[10]),.hit_player(hit_player_out[10]));
arrow #(8,32) arrow12(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[11]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_12),.valid_out(/*arrow_valid_3*/arrow_valid_out[11]),.is_hit(is_hit_out[11]),.hit_player(hit_player_out[11]));
arrow #(8,32) arrow13(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[12]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_13),.valid_out(/*arrow_valid_3*/arrow_valid_out[12]),.is_hit(is_hit_out[12]),.hit_player(hit_player_out[12]));
arrow #(8,32) arrow14(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[13]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_14),.valid_out(/*arrow_valid_3*/arrow_valid_out[13]),.is_hit(is_hit_out[13]),.hit_player(hit_player_out[13]));
arrow #(8,32) arrow15(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[14]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_15),.valid_out(/*arrow_valid_3*/arrow_valid_out[14]),.is_hit(is_hit_out[14]),.hit_player(hit_player_out[14]));
arrow #(8,32) arrow16(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[15]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_16),.valid_out(/*arrow_valid_3*/arrow_valid_out[15]),.is_hit(is_hit_out[15]),.hit_player(hit_player_out[15]));
arrow #(8,32) arrow17(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[16]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_17),.valid_out(/*arrow_valid_3*/arrow_valid_out[16]),.is_hit(is_hit_out[16]),.hit_player(hit_player_out[16]));
arrow #(8,32) arrow18(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[17]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_18),.valid_out(/*arrow_valid_3*/arrow_valid_out[17]),.is_hit(is_hit_out[17]),.hit_player(hit_player_out[17]));
arrow #(8,32) arrow19(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[18]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_19),.valid_out(/*arrow_valid_3*/arrow_valid_out[18]),.is_hit(is_hit_out[18]),.hit_player(hit_player_out[18]));
arrow #(8,32) arrow20(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[19]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_20),.valid_out(/*arrow_valid_3*/arrow_valid_out[19]),.is_hit(is_hit_out[19]),.hit_player(hit_player_out[19]));
arrow #(8,32) arrow21(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[20]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_21),.valid_out(/*arrow_valid_3*/arrow_valid_out[20]),.is_hit(is_hit_out[20]),.hit_player(hit_player_out[20]));
arrow #(8,32) arrow22(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[21]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_22),.valid_out(/*arrow_valid_3*/arrow_valid_out[21]),.is_hit(is_hit_out[21]),.hit_player(hit_player_out[21]));
arrow #(8,32) arrow23(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[22]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_23),.valid_out(/*arrow_valid_3*/arrow_valid_out[22]),.is_hit(is_hit_out[22]),.hit_player(hit_player_out[22]));
arrow #(8,32) arrow24(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[23]),.speed_in(0),.direction_in(2'b00),.inversed_in(0),.rotate_in(rotate_in),.pixel_out(arrow_out_24),.valid_out(/*arrow_valid_3*/arrow_valid_out[23]),.is_hit(is_hit_out[23]),.hit_player(hit_player_out[23]));



//arrow out individual
//logic arrow_valid_1,arrow_valid_2,arrow_valid_3;
logic[11:0] arrow_out_1,arrow_out_2,arrow_out_3,arrow_out_4,arrow_out_5,arrow_out_6,arrow_out_7,arrow_out_8,arrow_out_9,arrow_out_10,arrow_out_11,arrow_out_12,arrow_out_13,arrow_out_14,arrow_out_15,arrow_out_16,arrow_out_17,arrow_out_18,arrow_out_19,arrow_out_20,arrow_out_21,arrow_out_22,arrow_out_23,arrow_out_24;
logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
block_sprite #(160,8,432,304,12'hFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(8,160,432,304,12'hFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(8,160,584,304,12'hFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(160,8,432,456,12'hFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));

logic[11:0] green_heart_pixel_out;
logic green_heart_valid_out;
image_sprite #(64,64) green_heart(.pixel_clk_in(clk),.rst_in(rst),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(green_heart_pixel_out),.in_sprite(green_heart_valid_out));

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
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + arrow_out_1 + arrow_out_2 + arrow_out_3 + arrow_out_4 + arrow_out_5 + arrow_out_6 + arrow_out_7 + arrow_out_8 +arrow_out_9 + arrow_out_10 + arrow_out_11 + arrow_out_12 + arrow_out_13 + arrow_out_14 + arrow_out_15 + arrow_out_16 + arrow_out_17 + arrow_out_18 + arrow_out_19 + arrow_out_20 + arrow_out_21 + arrow_out_22 + arrow_out_23 + arrow_out_24 + shield_out + green_heart_pixel_out;
		//pixel_out = 1;
	end 
	else begin
		pixel_out = frame_bottom_pixel;
	end
end
logic[4:0] arrow_count;
logic[31:0] timing_count;
logic[6:0] arrow_count_first;
logic pattern_ended;
logic[23:0] old_arrow_valid_out;
logic[3:0] old_state_in; //detecting rising edge at the beginning of each phase
always_ff @(posedge clk)begin
	if(rst)begin
		busy_out_buffer <= 0;
		finished_out <= 0;
		finished_out <= 0;
		timing_count <= 0;
		old_state_in <= 4'b1010;
		arrow_count_first <= 0;
		pattern_ended <= 0;
		//hit_player_out <= 0;
		//pixel_out <= 0;
	end else begin
		if(state_in == 4'b1000 && old_state_in != state_in)begin
			busy_out_buffer <= 1;
			finished_out <= 0;
			timing_count <= 0;
			//arrow_count_first <= 0;
			arrow_valid_in <= 24'h000000;
			old_arrow_valid_out <= arrow_valid_out;
			arrow_count <= 0;
		end
		if(busy_out_buffer ==1)begin
			if(timings[0][arrow_count_first+:3] == 3'b0)begin
				if(pattern_ended == 0)
					pattern_ended <= 1;
			end
			else begin
				timing_count <= timing_count + 1;
                        	if(timing_count == /*timings[0][arrow_count+:3]5*6500000*/timings[0][arrow_count_first+:3]*5*6500000)begin
                                	arrow_valid_in <= {arrow_valid_in[22:0],1'b1};
                                	arrow_count_first <= arrow_count_first + 3;
					//if(arrow_count < arrow_max)
						//arrow_count <= arrow_count + 1;
                                	timing_count <= 0;
                        	end
			end

			if(pattern_ended && arrow_valid_out == 0)begin
				finished_out <= 1;
				busy_out_buffer <= 0;
			end

		end
		if(hit_player_out != 0)begin
			damage_out <= 1;
			//hit_player_out <= 0;
		end
		if(is_hit_out != 0 && arrow_count < arrow_max)begin
			arrow_count <= arrow_count + 1;
		end
		if(damage_out == 1)
			damage_out <= 0;
	        old_state_in <= state_in;
		old_arrow_valid_out <= arrow_valid_out;
		/*if(arrow_count == arrow_max)begin
			finished_out <= 1;
			busy_out_buffer <= 0;
		end*/
		if(finished_out == 1)begin
			finished_out <= 0;
		end
	end
	//output the pixel value from 24 arrows, heart, etc. 
	//alpha blending
	//interval control
end

assign busy_out = busy_out_buffer;
endmodule
`default_nettype wire
