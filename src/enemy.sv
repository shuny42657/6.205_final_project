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
logic[71:0] speeds[9:0];
logic[47:0] directions[9:0];
logic[23:0] inverseds[9:0];
logic[5:0] arrow_maxes[9:0];
//patterns
pattern #(12,72'b010_010_010_010_010_010_010_010_010_111_100_100_100,72'b111_111_111_111_111_111_111_111_111_100_100_100,48'h0000009D89C0,24'h0,0) pattern1(.turn_in(turn_in),.arrows(arrow_maxes[0]),.timing(timings[0]),.speed(speeds[0]),.direction(directions[0]),.inversed(inverseds[0]));
pattern #(13,72'b100_100_100_100_100_100_100_100_100_100_100_100_100_100,72'b100100100100100100100100100100100100100100,48'b1011101110111110111110101110,24'h0,1) pattern2(.turn_in(turn_in),.arrows(arrow_maxes[1]),.timing(timings[1]),.speed(speeds[1]),.direction(directions[1]),.inversed(inverseds[1]));
pattern #(9,72'b100_100_100_100_100_100_100_100_100_100,72'b00100100100100100100100100100,48'b0,24'h0,1) pattern3(.turn_in(turn_in),.arrows(arrow_maxes[2]),.timing(timings[2]),.speed(speeds[2]),.direction(directions[2]),.inversed(inverseds[2]));
logic pattern_valid_1;
//assign timings[0] = 72'h249_249_249_249_249_249;
logic timing_1;
assign timing_1 = 72'b001001001001001001001001001001001001001001001001001001001001001001001001;
//logic[23:0] arrow_on;
//24 arrows
logic[23:0] arrow_valid_in;
//logic[11:0][23:0] arrow_out;
logic[23:0] next_arrow;
logic[23:0] arrow_out[11:0];
logic[23:0] arrow_valid_out;
logic[23:0] hit_player_out;
logic[23:0] is_hit_out;
logic[4:0] arrow_max;
arrow #(8,32) arrow1(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[0]),.speed_in(speeds[turn_in][2:0]),.direction_in(directions[turn_in][1:0]),.inversed_in(inverseds[turn_in][0]),.rotate_in(rotate_in),.next_in(next_arrow[0]),.pixel_out(arrow_out_1),.valid_out(arrow_valid_out[0]),.is_hit(is_hit_out[0]),.hit_player(hit_player_out[0]));
arrow #(8,32) arrow2(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[1]),.speed_in(speeds[turn_in][5:3]),.direction_in(directions[turn_in][3:2]),.inversed_in(inverseds[turn_in][1]),.rotate_in(rotate_in),.next_in(next_arrow[1]),.pixel_out(arrow_out_2),.valid_out(arrow_valid_out[1]),.is_hit(is_hit_out[1]),.hit_player(hit_player_out[1]));
arrow #(32,8) arrow3(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[2]),.speed_in(speeds[turn_in][8:6]),.direction_in(directions[turn_in][5:4]),.inversed_in(inverseds[turn_in][2]),.rotate_in(rotate_in),.next_in(next_arrow[2]),.pixel_out(arrow_out_3),.valid_out(arrow_valid_out[2]),.is_hit(is_hit_out[2]),.hit_player(hit_player_out[2]));
arrow #(8,32) arrow4(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[3]),.speed_in(speeds[turn_in][11:9]),.direction_in(directions[turn_in][7:6]),.inversed_in(inverseds[turn_in][3]),.rotate_in(rotate_in),.next_in(next_arrow[3]),.pixel_out(arrow_out_4),.valid_out(arrow_valid_out[3]),.is_hit(is_hit_out[3]),.hit_player(hit_player_out[3]));
arrow #(8,32) arrow5(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[4]),.speed_in(speeds[turn_in][14:12]),.direction_in(directions[turn_in][9:8]),.inversed_in(inverseds[turn_in][4]),.rotate_in(rotate_in),.next_in(next_arrow[4]),.pixel_out(arrow_out_5),.valid_out(arrow_valid_out[4]),.is_hit(is_hit_out[4]),.hit_player(hit_player_out[4]));
arrow #(8,32) arrow6(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[5]),.speed_in(speeds[turn_in][17:15]),.direction_in(directions[turn_in][11:10]),.inversed_in(inverseds[turn_in][5]),.rotate_in(rotate_in),.next_in(next_arrow[5]),.pixel_out(arrow_out_6),.valid_out(arrow_valid_out[5]),.is_hit(is_hit_out[5]),.hit_player(hit_player_out[5]));
arrow #(8,32) arrow7(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[6]),.speed_in(speeds[turn_in][20:18]),.direction_in(directions[turn_in][13:12]),.inversed_in(inverseds[turn_in][6]),.rotate_in(rotate_in),.next_in(next_arrow[6]),.pixel_out(arrow_out_7),.valid_out(arrow_valid_out[6]),.is_hit(is_hit_out[6]),.hit_player(hit_player_out[6]));
arrow #(8,32) arrow8(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[7]),.speed_in(speeds[turn_in][23:21]),.direction_in(directions[turn_in][15:14]),.inversed_in(inverseds[turn_in][7]),.rotate_in(rotate_in),.next_in(next_arrow[7]),.pixel_out(arrow_out_8),.valid_out(arrow_valid_out[7]),.is_hit(is_hit_out[7]),.hit_player(hit_player_out[7]));
arrow #(8,32) arrow9(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[8]),.speed_in(speeds[turn_in][26:24]),.direction_in(directions[turn_in][17:16]),.inversed_in(inverseds[turn_in][8]),.rotate_in(rotate_in),.next_in(next_arrow[8]),.pixel_out(arrow_out_9),.valid_out(arrow_valid_out[8]),.is_hit(is_hit_out[8]),.hit_player(hit_player_out[8]));
arrow #(8,32) arrow10(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[9]),.speed_in(speeds[turn_in][29:27]),.direction_in(directions[turn_in][19:18]),.inversed_in(inverseds[turn_in][9]),.rotate_in(rotate_in),.next_in(next_arrow[9]),.pixel_out(arrow_out_10),.valid_out(arrow_valid_out[9]),.is_hit(is_hit_out[9]),.hit_player(hit_player_out[9]));
arrow #(8,32) arrow11(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[10]),.speed_in(speeds[turn_in][32:30]),.direction_in(directions[turn_in][21:20]),.inversed_in(inverseds[turn_in][10]),.rotate_in(rotate_in),.next_in(next_arrow[10]),.pixel_out(arrow_out_11),.valid_out(arrow_valid_out[10]),.is_hit(is_hit_out[10]),.hit_player(hit_player_out[10]));
arrow #(8,32) arrow12(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[11]),.speed_in(speeds[turn_in][35:33]),.direction_in(directions[turn_in][23:22]),.inversed_in(inverseds[turn_in][11]),.rotate_in(rotate_in),.next_in(next_arrow[11]),.pixel_out(arrow_out_12),.valid_out(arrow_valid_out[11]),.is_hit(is_hit_out[11]),.hit_player(hit_player_out[11]));
arrow #(8,32) arrow13(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[12]),.speed_in(speeds[turn_in][38:36]),.direction_in(directions[turn_in][25:24]),.inversed_in(inverseds[turn_in][12]),.rotate_in(rotate_in),.next_in(next_arrow[12]),.pixel_out(arrow_out_13),.valid_out(arrow_valid_out[12]),.is_hit(is_hit_out[12]),.hit_player(hit_player_out[12]));
arrow #(8,32) arrow14(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[13]),.speed_in(speeds[turn_in][41:39]),.direction_in(directions[turn_in][27:26]),.inversed_in(inverseds[turn_in][13]),.rotate_in(rotate_in),.next_in(next_arrow[13]),.pixel_out(arrow_out_14),.valid_out(arrow_valid_out[13]),.is_hit(is_hit_out[13]),.hit_player(hit_player_out[13]));
arrow #(8,32) arrow15(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[14]),.speed_in(speeds[turn_in][44:42]),.direction_in(directions[turn_in][29:28]),.inversed_in(inverseds[turn_in][14]),.rotate_in(rotate_in),.next_in(next_arrow[14]),.pixel_out(arrow_out_15),.valid_out(arrow_valid_out[14]),.is_hit(is_hit_out[14]),.hit_player(hit_player_out[14]));
arrow #(8,32) arrow16(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[15]),.speed_in(speeds[turn_in][47:45]),.direction_in(directions[turn_in][31:30]),.inversed_in(inverseds[turn_in][15]),.rotate_in(rotate_in),.next_in(next_arrow[15]),.pixel_out(arrow_out_16),.valid_out(arrow_valid_out[15]),.is_hit(is_hit_out[15]),.hit_player(hit_player_out[15]));
arrow #(8,32) arrow17(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[16]),.speed_in(speeds[turn_in][50:48]),.direction_in(directions[turn_in][33:32]),.inversed_in(inverseds[turn_in][16]),.rotate_in(rotate_in),.next_in(next_arrow[16]),.pixel_out(arrow_out_17),.valid_out(arrow_valid_out[16]),.is_hit(is_hit_out[16]),.hit_player(hit_player_out[16]));
arrow #(8,32) arrow18(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[17]),.speed_in(speeds[turn_in][53:51]),.direction_in(directions[turn_in][35:34]),.inversed_in(inverseds[turn_in][17]),.rotate_in(rotate_in),.next_in(next_arrow[17]),.pixel_out(arrow_out_18),.valid_out(arrow_valid_out[17]),.is_hit(is_hit_out[17]),.hit_player(hit_player_out[17]));
arrow #(8,32) arrow19(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[18]),.speed_in(speeds[turn_in][56:54]),.direction_in(directions[turn_in][37:36]),.inversed_in(inverseds[turn_in][18]),.rotate_in(rotate_in),.next_in(next_arrow[18]),.pixel_out(arrow_out_19),.valid_out(arrow_valid_out[18]),.is_hit(is_hit_out[18]),.hit_player(hit_player_out[18]));
arrow #(8,32) arrow20(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[19]),.speed_in(speeds[turn_in][59:57]),.direction_in(directions[turn_in][39:38]),.inversed_in(inverseds[turn_in][19]),.rotate_in(rotate_in),.next_in(next_arrow[19]),.pixel_out(arrow_out_20),.valid_out(arrow_valid_out[19]),.is_hit(is_hit_out[19]),.hit_player(hit_player_out[19]));
arrow #(8,32) arrow21(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[20]),.speed_in(speeds[turn_in][62:60]),.direction_in(directions[turn_in][41:40]),.inversed_in(inverseds[turn_in][20]),.rotate_in(rotate_in),.next_in(next_arrow[20]),.pixel_out(arrow_out_21),.valid_out(arrow_valid_out[20]),.is_hit(is_hit_out[20]),.hit_player(hit_player_out[20]));
arrow #(8,32) arrow22(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[21]),.speed_in(speeds[turn_in][65:63]),.direction_in(directions[turn_in][43:42]),.inversed_in(inverseds[turn_in][21]),.rotate_in(rotate_in),.next_in(next_arrow[21]),.pixel_out(arrow_out_22),.valid_out(arrow_valid_out[21]),.is_hit(is_hit_out[21]),.hit_player(hit_player_out[21]));
arrow #(8,32) arrow23(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[22]),.speed_in(speeds[turn_in][68:66]),.direction_in(directions[turn_in][45:44]),.inversed_in(inverseds[turn_in][22]),.rotate_in(rotate_in),.next_in(next_arrow[22]),.pixel_out(arrow_out_23),.valid_out(arrow_valid_out[22]),.is_hit(is_hit_out[22]),.hit_player(hit_player_out[22]));
arrow #(8,32) arrow24(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(arrow_valid_in[23]),.speed_in(speeds[turn_in][71:69]),.direction_in(directions[turn_in][47:46]),.inversed_in(inverseds[turn_in][23]),.rotate_in(rotate_in),.next_in(next_arrow[23]),.pixel_out(arrow_out_24),.valid_out(arrow_valid_out[23]),.is_hit(is_hit_out[23]),.hit_player(hit_player_out[23]));



//arrow out individual
//logic arrow_valid_1,arrow_valid_2,arrow_valid_3;
logic[11:0] arrow_out_1,arrow_out_2,arrow_out_3,arrow_out_4,arrow_out_5,arrow_out_6,arrow_out_7,arrow_out_8,arrow_out_9,arrow_out_10,arrow_out_11,arrow_out_12,arrow_out_13,arrow_out_14,arrow_out_15,arrow_out_16,arrow_out_17,arrow_out_18,arrow_out_19,arrow_out_20,arrow_out_21,arrow_out_22,arrow_out_23,arrow_out_24;
logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
/*block_sprite #(160,8,432,304,12'hFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(8,160,432,304,12'hFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(8,160,584,304,12'hFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(160,8,432,456,12'hFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));*/
logic[10:0] top_x,bottom_x,left_x,right_x,top_width,bottom_width,left_width,right_width;
logic[9:0] top_y,bottom_y,left_y,right_y,top_height,bottom_height,left_height,right_height;

frame_sprite #(12'hFFF) frame_top(.x_in(top_x),.hcount_in(hcount_in),.width_in(top_width),.y_in(top_y),.vcount_in(vcount_in),.height_in(top_height),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
frame_sprite #(12'hFFF) frame_left(.x_in(left_x),.hcount_in(hcount_in),.width_in(left_width),.y_in(left_y),.vcount_in(vcount_in),.height_in(left_height),.pixel_out(frame_left_pixel),.in_sprite(frame_left_out));
frame_sprite #(12'hFFF) frame_right(.x_in(right_x),.hcount_in(hcount_in),.width_in(right_width),.y_in(right_y),.vcount_in(vcount_in),.height_in(right_height),.pixel_out(frame_right_pixel),.in_sprite(frame_right_out));
frame_sprite #(12'hFFF) frame_bottom(.x_in(bottom_x),.hcount_in(hcount_in),.width_in(bottom_width),.y_in(bottom_y),.vcount_in(vcount_in),.height_in(bottom_height),.pixel_out(frame_bottom_pixel),.in_sprite(frame_bottom_out));


/*logic[11:0] undyne_pixel_out;
logic undyne_out;
block_sprite #(128,256,512,128,12'hFFF) undyne(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(undyne_out),.pixel_out(undyne_pixel_out));*/
logic[11:0] green_heart_pixel_out;
logic green_heart_valid_out;
//image_sprite #(64,64,"green_heart.mem","green_heart_palette.mem") green_heart(.pixel_clk_in(clk),.rst_in(rst),.x_in(480),.hcount_in(hcount_in),.y_in(352),.vcount_in(vcount_in),.pixel_out(green_heart_pixel_out),.in_sprite(green_heart_valid_out));
green_heart_sprite #(488,368,12'h0F0) (.hcount_in(hcount_in),.vcount_in(vcount_in),.divided_in(0),.pixel_out(green_heart_pixel_out),.in_sprite(green_heart_valid_out));
logic frame_moving;
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
		if(frame_moving == 0)begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + arrow_out_1 + arrow_out_2 + arrow_out_3 + arrow_out_4 + arrow_out_5 + arrow_out_6 + arrow_out_7 + arrow_out_8 +arrow_out_9 + arrow_out_10 + arrow_out_11 + arrow_out_12 + arrow_out_13 + arrow_out_14 + arrow_out_15 + arrow_out_16 + arrow_out_17 + arrow_out_18 + arrow_out_19 + arrow_out_20 + arrow_out_21 + arrow_out_22 + arrow_out_23 + arrow_out_24 + shield_out + green_heart_pixel_out;
		//pixel_out = 1;
	end
	else begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel;
	end
	end 
	else begin
		pixel_out = frame_bottom_pixel;
	end
end
logic[4:0] arrow_count;
logic[31:0] timing_count;
//logic[1:0] frame_moving;
logic[6:0] arrow_count_first;
logic pattern_ended;
logic[23:0] old_arrow_valid_out;
logic[3:0] old_state_in; //detecting rising edge at the beginning of each phase
always_ff @(posedge clk)begin
	if(rst)begin
		busy_out_buffer <= 0;
		finished_out <= 0;
		//game_over_out <= 0;
		timing_count <= 0;
		old_state_in <= 4'b1010;
		arrow_count_first <= 0;
		pattern_ended <= 0;
		arrow_count <= 0;
		next_arrow <= 24'b1;
		frame_moving <= 0;
		top_x <= 432;
                top_y <= 304;
                top_width <= 160;
                top_height <= 8;
                left_x <= 432;
                left_y <= 304;
                left_width <= 8;
                left_height <= 160;
                right_x <= 584;
                right_y <= 304;
                right_width <= 8;
                right_height <= 160;
                bottom_x <= 432;
                bottom_y <= 456;
                bottom_width <= 160;
                bottom_height <= 8;

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
			next_arrow <= 24'h000001;
			frame_moving <= 0;
			top_x <= 432;
                	top_y <= 304;
                	top_width <= 160;
                	top_height <= 8;
                	left_x <= 432;
                	left_y <= 304;
                	left_width <= 8;
               	 	left_height <= 160;
                	right_x <= 584;
                	right_y <= 304;
                	right_width <= 8;
                	right_height <= 160;
                	bottom_x <= 432;
                	bottom_y <= 456;
                	bottom_width <= 160;
                	bottom_height <= 8;

		end
		else begin
			if(busy_out_buffer ==1)begin
				if(is_hit_out != 0 && arrow_count < arrow_maxes[turn_in])begin
                                	arrow_count <= arrow_count + 1;
                                	next_arrow <= {next_arrow[22:0],next_arrow[23]};
					//next_arrow <= next_arrow <<  1;
                        	end
				if(timings[0][arrow_count_first+:3] == 3'b0)begin
					if(pattern_ended == 0)
						pattern_ended <= 1;
				end
				else begin
					timing_count <= timing_count + 1;
                        		if(timing_count == timings[0][arrow_count_first+:3]*6500000*2)begin
                                		arrow_valid_in <= {arrow_valid_in[22:0],1'b1};
                                		arrow_count_first <= arrow_count_first + 3;
                                		timing_count <= 0;
                        		end
				end

				if(/*arrow_valid_out == 0*/arrow_count == arrow_maxes[turn_in] && frame_moving == 0)begin
					//finished_out <= 1;
					//busy_out_buffer <= 0;
					//game_over_out <= 1;
					arrow_valid_in <= 0;
			        	frame_moving <= 1;
				end
				if(hit_player_out != 0)begin
                        		damage_out <= 1;
					//next_arrow <= {next_arrow[22:0],next_arrow[23]};
                        		//hit_player_out <= 0;
                		end
                		if(damage_out == 1)
                        		damage_out <= 0;
				if(frame_moving == 1)begin
					if(hcount_in == 0 && vcount_in == 0)begin
						if(top_y == 384)begin
                                        		//frame_moving <= 3;
							bottom_y <= 568;
                                                        top_width <= top_width + 8;
                                                        bottom_width <= bottom_width + 8;
                                                        top_x <= top_x - 4;
                                                        bottom_x <= bottom_x - 4;
                                                        left_x <= left_x - 4;
                                                        right_x <= right_x + 4;
							if(top_width == 768)begin
								finished_out <= 1;
								busy_out_buffer <= 0;
							end

						end
                                		else begin
                                        		left_height <= 192;
                                        		right_height <= 192;
                                        		top_y <= top_y + 8;
							bottom_y <= top_y + 184;
                                        		left_y <= left_y + 8;
                                        		right_y <= right_y + 8;
                                        		bottom_y <= bottom_y + 8;
                                		end

					end
				end
				else if(frame_moving == 3)begin
					if(hcount_in == 0 && vcount_in == 0)begin
						/*if(top_width == 768)begin
                                        		finished_out <= 1;
                                        		busy_out_buffer <= 0;
						end
						else begin*/
                                                	bottom_y <= 568;
                                                	top_width <= top_width + 8;
                                                	bottom_width <= bottom_width + 8;
                                                	top_x <= top_x - 4;
                                                        bottom_x <= bottom_x - 4;
                                                        left_x <= left_x - 4;
                                                        right_x <= right_x + 4;
                                                //end
                                        end
				end
			end
		end
		/*if(hit_player_out != 0)begin
			damage_out <= 1;
			//hit_player_out <= 0;
		end
		if(is_hit_out != 0 && arrow_count < arrow_max)begin
			arrow_count <= arrow_count + 1;
		end
		if(damage_out == 1)
			damage_out <= 0;*/
	        old_state_in <= state_in;
		old_arrow_valid_out <= arrow_valid_out;
		/*if(arrow_count == arrow_max)begin
			finished_out <= 1;
			busy_out_buffer <= 0;
		end*/
		if(finished_out == 1)begin
			finished_out <= 0;
			//game_over_out <= 0;
		end
	end
	//output the pixel value from 24 arrows, heart, etc. 
	//alpha blending
	//interval control
end

assign busy_out = busy_out_buffer;
endmodule
`default_nettype wire
