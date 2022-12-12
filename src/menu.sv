`default_nettype none
`timescale 1ns / 1ps
module menu(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[3:0] state_in,
	input wire[1:0] key_input_in,
	input wire[10:0] enemy_hp_left_in,
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
button_sprite #(126,707) attack_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.command_in(2'b00),.selected_in(selected_in[3]),.pixel_out(attack_button_out));
button_sprite #(332,707) act_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.command_in(2'b01),.selected_in(selected_in[2]),.pixel_out(act_button_out));
button_sprite #(552,707) talk_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.command_in(2'b10),.selected_in(selected_in[1]),.pixel_out(talk_button_out));
button_sprite #(748,707) mercy_buttom(.hcount_in(hcount_in),.vcount_in(vcount_in),.command_in(2'b11),.selected_in(selected_in[0]),.pixel_out(mercy_button_out));

/*wind is howling text variables*/
logic [11:0] wind_pixel_out[15:0];
logic [15:0] wind_valid_in;
logic [15:0] wind_out;

fonts #(200,432) wind_T(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[0]),.letter_in(6'b001010),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[0]),.in_sprite(wind_out[0]));
fonts #(224,432) wind_h(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[1]),.letter_in(6'b001100),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[1]),.in_sprite(wind_out[1]));
fonts #(248,440) wind_e(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[2]),.letter_in(6'b001101),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[2]),.in_sprite(wind_out[2]));
fonts #(296,440) wind_w(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[3]),.letter_in(6'b001110),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[3]),.in_sprite(wind_out[3]));
fonts #(320,432) wind_i(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[4]),.letter_in(6'b001111),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[4]),.in_sprite(wind_out[4]));
fonts #(344,440) wind_n(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[5]),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[5]),.in_sprite(wind_out[5]));
fonts #(368,432) wind_d(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[6]),.letter_in(6'b010001),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[6]),.in_sprite(wind_out[6]));
fonts #(416,432) wind_i_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[7]),.letter_in(6'b001111),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[7]),.in_sprite(wind_out[7]));
fonts #(440,440) wind_s(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[8]),.letter_in(6'b010010),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[8]),.in_sprite(wind_out[8]));
fonts #(488,432) wind_h_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[9]),.letter_in(6'b001100),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[9]),.in_sprite(wind_out[9]));
fonts #(512,440) wind_o(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[10]),.letter_in(6'b010011),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[10]),.in_sprite(wind_out[10]));
fonts #(536,440) wind_w_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[11]),.letter_in(6'b001110),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[11]),.in_sprite(wind_out[11]));
fonts #(560,432) wind_l(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[12]),.letter_in(6'b010100),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[12]),.in_sprite(wind_out[12]));
fonts #(584,432) wind_i_three(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[13]),.letter_in(6'b001111),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[13]),.in_sprite(wind_out[13]));
fonts #(608,440) wind_n_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[14]),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[14]),.in_sprite(wind_out[14]));
fonts #(636,440) wind_g(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(wind_valid_in[15]),.letter_in(6'b010101),.color_in(12'hFFF),.scale_in(1),.pixel_out(wind_pixel_out[15]),.in_sprite(wind_out[15]));

/*undyne the undying text variables*/
logic[11:0] undyne_text_pixel_out[15:0];
logic[15:0] undyne_text_out;
fonts #(200,432) undyne_U(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100010),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[0]),.in_sprite(undyne_text_out[0]));
fonts #(228,440) undyne_n(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[1]),.in_sprite(undyne_text_out[1]));
fonts #(252,432) undyne_d(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010001),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[2]),.in_sprite(undyne_text_out[2]));
fonts #(276,440) undyne_y(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010110),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[3]),.in_sprite(undyne_text_out[3]));
fonts #(300,440) undyne_n_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[4]),.in_sprite(undyne_text_out[4]));
fonts #(324,440) undyne_e(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001101),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[5]),.in_sprite(undyne_text_out[5]));
fonts #(372,432) undyne_t(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100100),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[6]),.in_sprite(undyne_text_out[6]));
fonts #(396,432) undyne_h(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001100),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[7]),.in_sprite(undyne_text_out[7]));
fonts #(420,440) undyne_e_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001101),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[8]),.in_sprite(undyne_text_out[8]));
fonts #(468,432) undyne_U_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100010),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[9]),.in_sprite(undyne_text_out[9]));
fonts #(494,440) undyne_n_three(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[10]),.in_sprite(undyne_text_out[10]));
fonts #(518,432) undyne_d_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010001),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[11]),.in_sprite(undyne_text_out[11]));
fonts #(542,440) undyne_y_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010110),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[12]),.in_sprite(undyne_text_out[12]));
fonts #(566,432) undyne_i(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001111),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[13]),.in_sprite(undyne_text_out[13]));
fonts #(590,440) undyne_n_four(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010000),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[14]),.in_sprite(undyne_text_out[14]));
fonts #(614,440) undyne_g(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010101),.color_in(12'hFFF),.scale_in(1),.pixel_out(undyne_text_pixel_out[15]),.in_sprite(undyne_text_out[15]));

logic [11:0] select_heart_pixel_out;
logic select_heart_out;
green_heart_sprite #(160,428) select_heart(.hcount_in(hcount_in),.vcount_in(vcount_in),.divided_in(0),.pixel_out(select_heart_pixel_out),.in_sprite(select_heart_out));


logic[11:0] menu_enemy_health_bar_out;
logic[10:0] hp_left_out;
enemy_health_bar #(670,440,96,16,12'h0F0,12'hF00) menu_enemy_health_bar(.valid_in(1),.hcount_in(hcount_in),.vcount_in(vcount_in),.border_in(enemy_hp_left_in >> 1),.pixel_out(menu_enemy_health_bar_out));
logic busy_out_buffer;
logic[3:0] old_state_in;
logic[1:0] old_key_input_in;
logic old_decide_in;
logic menu_phase;
logic[31:0] timing_count;
always_comb begin
	if(busy_out_buffer == 1 && menu_phase == 0)begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + attack_button_out + act_button_out + talk_button_out + mercy_button_out + wind_pixel_out[0] + wind_pixel_out[1] + wind_pixel_out[2] + wind_pixel_out[3] + wind_pixel_out[4] + wind_pixel_out[5] + wind_pixel_out[6] + wind_pixel_out[7] + wind_pixel_out[8] + wind_pixel_out[9] + wind_pixel_out[10] + wind_pixel_out[11] + wind_pixel_out[12] + wind_pixel_out[13] + wind_pixel_out[14] + wind_pixel_out[15];

	end else if(busy_out_buffer == 1 && menu_phase == 1)begin
		pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + attack_button_out + act_button_out + talk_button_out + mercy_button_out + undyne_text_pixel_out[0] + undyne_text_pixel_out[1] + undyne_text_pixel_out[2] + undyne_text_pixel_out[3] + undyne_text_pixel_out[4] + undyne_text_pixel_out[5] + undyne_text_pixel_out[6] + undyne_text_pixel_out[7] + undyne_text_pixel_out[8] + undyne_text_pixel_out[9] + undyne_text_pixel_out[10] + undyne_text_pixel_out[11] + undyne_text_pixel_out[12] + undyne_text_pixel_out[13] + undyne_text_pixel_out[14] + undyne_text_pixel_out[15] + select_heart_pixel_out + menu_enemy_health_bar_out;
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
		wind_valid_in <= 16'h0000;
		menu_phase <= 0;
	end
	else begin
		if(old_state_in != state_in && state_in == 4'b0000)begin
			busy_out_buffer <= 1;
			timing_count <= 0;
			menu_phase <= 0;
		end
		if(busy_out_buffer ==1)begin
			if(menu_phase == 0)begin
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
                                        	//finished_out <= 1;
                                        	//busy_out_buffer <= 0;
						menu_phase <= 1;
                                	end
                        	end

                        	if(hcount_in == 0 && vcount_in == 0)begin
                                	timing_count <= timing_count + 1;
                                	if(timing_count == 2)begin
                                        	wind_valid_in <= {wind_valid_in[14:0],1'b1};
                                        	timing_count <= 0;

                                	end
                        	end

			end
			else if(menu_phase == 1)begin
				if(old_decide_in == 0 && decide_in == 1)begin
                                        if(selected_in == 4'b1000)begin
                                                finished_out <= 1;
                                                busy_out_buffer <= 0;
                                                //menu_phase == 1;
                                        end
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

