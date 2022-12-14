`timescale 1ns / 1ps
`default_nettype none

module game_state(
	input wire clk,
	input wire rst,

	input wire [10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[1:0] rotate_in,
	input wire[1:0] key_input_in,
	input wire decide_in,

	output logic[11:0] pixel_out
);

logic[3:0] state_out;
logic[3:0] turn_out;
/*
* 4'b1000 = enemy
* 4'b0000 = menu
* 4'b0001 = player
* 4'b1111 = game over
*/
logic enemy_busy_out;
logic enemy_finish_out,old_enemy_finish_out;
logic[11:0] enemy_pixel_out;
logic round_rst;
logic state_rst;
logic damage_out;
logic game_over_out,old_game_over_out;
//assign state_out = 4'b1000;
//assign turn_out = 4'b0000;
assign state_rst = round_rst || rst;

logic[11:0] undyne_pixel_out;
logic undyne_out;
logic[10:0] undyne_x;
image_sprite #(372,372,"undyne.mem","undyne_palette.mem") undyne(.pixel_clk_in(clk),.rst_in(rst),.x_in(undyne_x),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(undyne_pixel_out),.in_sprite(undyne_out));

logic[10:0] enemy_hp_left_out;


logic[11:0] hp_pixel_out[1:0];
logic[1:0] hp_out;

fonts #(416,588) H(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b01000),.color_in(12'hFFF),.scale_in(1),.pixel_out(hp_pixel_out[0]),.in_sprite(hp_out[0]));
fonts #(444,588) P(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b01001),.color_in(12'hFFF),.scale_in(1),.pixel_out(hp_pixel_out[1]),.in_sprite(hp_out[1]));

logic[11:0] name_lv_pixel_out[7:0];
logic[7:0] name_lv_out;

fonts #(128,588) name_s(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100001),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[0]),.in_sprite(name_lv_out[0]));
fonts #(156,588) name_h(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001000),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[1]),.in_sprite(name_lv_out[1]));
fonts #(184,588) name_u(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100010),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[2]),.in_sprite(name_lv_out[2]));
fonts #(212,588) name_n(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100011),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[3]),.in_sprite(name_lv_out[3]));
fonts #(268,588) lv_l(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b001011),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[4]),.in_sprite(name_lv_out[4]));
fonts #(288,588) lv_v(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b000110),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[5]),.in_sprite(name_lv_out[5]));
fonts #(328,588) lv_1(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b011000),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[6]),.in_sprite(name_lv_out[6]));
fonts #(354,588) lv_0(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b010111),.color_in(12'hFFF),.scale_in(1),.pixel_out(name_lv_pixel_out[7]),.in_sprite(name_lv_out[7]));


enemy en(
	.clk(clk),
	.rst(state_rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.turn_in(turn_out),
	.rotate_in(rotate_in),
	.busy_out(enemy_busy_out),
	.finished_out(enemy_finish_out),
	.damage_out(damage_out),
	.pixel_out(enemy_pixel_out)

);

menu mn(
	.clk(clk),
	.rst(state_rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.key_input_in(key_input_in),
	.enemy_hp_left_in(enemy_hp_left_out),
	.decide_in(decide_in),
	.busy_out(menu_busy_out),
	.finished_out(menu_finish_out),
	.pixel_out(menu_pixel_out)
);

player pl(
	.clk(clk),
	.rst(/*state_rst*/rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.rotate_in(rotate_in),
	.busy_out(player_busy_out),
	.finished_out(player_finish_out),
	.undyne_x(undyne_x),
	.enemy_hp_left_out(enemy_hp_left_out),
	.pixel_out(player_pixel_out)
);
logic menu_busy_out;
logic menu_finish_out,old_menu_finish_out;
logic[11:0] menu_pixel_out;
logic player_busy_out;
logic player_finish_out,old_player_finish_out;
logic[11:0] player_pixel_out;
logic game_over_busy_out;
logic game_over_finish_out;

/*game_over go(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.busy_out(game_over_busy_out),
	.finished_out(game_over_finish_out),
	.pixel_out(game_over_pixel_out)
);*/
logic[11:0] health_bar_pixel_out;
health_bar #(480,584,112,32) hb(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.damage_in(damage_out),
	.game_over_out(game_over_out),
	.pixel_out(health_bar_pixel_out)
);


/*variables for game_over*/
logic[31:0] timing_count;
logic[2:0] animation_phase;
logic[11:0] green_heart_pixel_out;
logic[11:0] game_over_pixel_out[7:0];
logic[7:0] font_out;
logic green_heart_out;
logic divided_in;
logic fall_apart_valid_in;
logic[11:0] fall_apart_pixel_out;
logic[11:0] fall_apart_out;
logic[3:0] color_r_in,color_g_in,color_b_in;
logic[11:0] font_color_in;
logic[7:0] fade_interval;
green_heart_sprite #(496,368,12'h0F0) green_heart(.hcount_in(hcount_in),.vcount_in(vcount_in),.divided_in(divided_in),.pixel_out(green_heart_pixel_out),.in_sprite(green_heart_out));
fonts #(288,128) G(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00001),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[0]),.in_sprite(font_out[0]));
fonts #(400,128) A(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00010),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[1]),.in_sprite(font_out[1]));
fonts #(512,128) M(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00011),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[2]),.in_sprite(font_out[2]));
fonts #(672,128) E(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00100),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[3]),.in_sprite(font_out[3]));
fonts #(304,240) O(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00101),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[4]),.in_sprite(font_out[4]));
fonts #(416,240) V(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00110),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[5]),.in_sprite(font_out[5]));
fonts #(528,240) E_two(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00100),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[6]),.in_sprite(font_out[6]));
fonts #(640,240) R(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(5'b00111),.color_in(font_color_in),.scale_in(3),.pixel_out(game_over_pixel_out[7]),.in_sprite(font_out[7]));


heart_fall_apart #(12'hF00) heart_parts(.clk(clk),.rst(rst),.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(fall_apart_valid_in),.in_sprite(fall_apart_out),.pixel_out(fall_apart_pixel_out));
always_comb begin
	case(state_out)
		4'b1000:begin
			if(enemy_pixel_out != 0)
				pixel_out = enemy_pixel_out + health_bar_pixel_out + hp_pixel_out[0] + hp_pixel_out[1] + name_lv_pixel_out[0] + name_lv_pixel_out[1] + name_lv_pixel_out[2] + name_lv_pixel_out[3] + name_lv_pixel_out[4] + name_lv_pixel_out[5] + name_lv_pixel_out[6] + name_lv_pixel_out[7];
			else
				pixel_out = enemy_pixel_out + health_bar_pixel_out + {undyne_pixel_out[11:8]>>1,undyne_pixel_out[7:4]>>1,undyne_pixel_out[3:0]>>1} + hp_pixel_out[0] + hp_pixel_out[1] + name_lv_pixel_out[0] + name_lv_pixel_out[1] + name_lv_pixel_out[2] + name_lv_pixel_out[3] + name_lv_pixel_out[4] + name_lv_pixel_out[5] + name_lv_pixel_out[6] + name_lv_pixel_out[7];
		end
		4'b0000:begin
			pixel_out = menu_pixel_out + health_bar_pixel_out + undyne_pixel_out + hp_pixel_out[0] + hp_pixel_out[1] + name_lv_pixel_out[0] + name_lv_pixel_out[1] + name_lv_pixel_out[2] + name_lv_pixel_out[3] + name_lv_pixel_out[4] + name_lv_pixel_out[5] + name_lv_pixel_out[6] + name_lv_pixel_out[7];
		end
		4'b0001:begin
			if(player_pixel_out != 0)
				pixel_out = player_pixel_out + health_bar_pixel_out + hp_pixel_out[0] + hp_pixel_out[1] + name_lv_pixel_out[0] + name_lv_pixel_out[1] + name_lv_pixel_out[2] + name_lv_pixel_out[3] + name_lv_pixel_out[4] + name_lv_pixel_out[5] + name_lv_pixel_out[6] + name_lv_pixel_out[7];
			else
				pixel_out = player_pixel_out + health_bar_pixel_out + undyne_pixel_out + hp_pixel_out[0] + hp_pixel_out[1] + name_lv_pixel_out[0] + name_lv_pixel_out[1] + name_lv_pixel_out[2] + name_lv_pixel_out[3] + name_lv_pixel_out[4] + name_lv_pixel_out[5] + name_lv_pixel_out[6] + name_lv_pixel_out[7];
		end
		4'b1111:begin
			if(animation_phase == 1 || animation_phase == 0)begin
				pixel_out = green_heart_pixel_out;
			end
			else if(animation_phase == 2)begin
				pixel_out = fall_apart_pixel_out;
			end
			else if(animation_phase == 3)begin
				pixel_out = fall_apart_pixel_out + game_over_pixel_out[0] + game_over_pixel_out[1] + game_over_pixel_out[2] + game_over_pixel_out[3] + game_over_pixel_out[4] + game_over_pixel_out[5] + game_over_pixel_out[6] + game_over_pixel_out[7];
			end
		end
	endcase
end

always_ff @(posedge clk)begin
	if(rst)begin
		//game_over_out <= 0;
		state_out <= 4'b0000;
		turn_out <= 0;
		old_enemy_finish_out <= 0;
		old_menu_finish_out <= 0;
		round_rst <= 0;
		fall_apart_valid_in <= 0;
		timing_count <= 0;
		color_r_in <= 0;
		color_g_in <= 0;
		color_b_in <= 0;
		fade_interval <= 0;
	end
	else if(round_rst)begin
		state_out <= 4'b0000;
		old_enemy_finish_out <= 0;
		old_menu_finish_out <= 0;
		old_player_finish_out <= 0;
		round_rst <= 0;
		fall_apart_valid_in <= 0;
		timing_count <= 0;
		color_r_in <= 0;
		color_g_in <= 0;
		color_b_in <= 0;
	end
	else begin
		if(state_out == 4'b1111)begin
			if(animation_phase == 0)begin //idling
				//game_over_pixel_out <= 12'h0F0;
				timing_count <= timing_count + 1;
				if(timing_count == 6500000*10)begin
					timing_count <= 0;
					animation_phase <= 1;
				end
			end
			else if(animation_phase == 1)begin //heart breaks in two
				//game_over_pixel_out <= 12'hF00;
				divided_in <= 1;
				timing_count <= timing_count + 1;
				if(timing_count == 65000000 * 2)begin
					timing_count <= 0;
					animation_phase <= 2;
				end
			end
			else if(animation_phase == 2)begin //heart fall apart
				fall_apart_valid_in <= 1;
				timing_count <= timing_count + 1;
				if(timing_count == 65000000*2)begin
					animation_phase <= 3;
				end
			end
			else if(animation_phase == 3)begin
				if(hcount_in == 0 && vcount_in == 0)begin
					fade_interval <= fade_interval + 1;
					if(fade_interval[2:0] == 3'b111)begin
						if(color_r_in != 4'b1111)begin
                                                	color_r_in <= color_r_in + 1;
                                                	color_g_in <= color_g_in + 1;
                                                	color_b_in <= color_b_in + 1;
                                        	end
					end
				end
			end
		end
		else if(old_game_over_out != game_over_out && game_over_out == 1)begin
                        state_out <= 4'b1111;
                        animation_phase <= 0;
                        timing_count <= 0;
                        divided_in <= 0;
                end
                else begin
                        if(old_enemy_finish_out != enemy_finish_out && enemy_finish_out)begin
                                //shift to next state
                                //state_out <= 4'b0001;
				if(turn_out == 9)
					turn_out <= 0;
				else
					turn_out <= turn_out + 1;
                                round_rst <= 1;
                        end
                        if(old_menu_finish_out != menu_finish_out && menu_finish_out)begin
                                state_out <= 4'b0001;
                        end
                        if(old_player_finish_out && player_finish_out)begin
                                state_out <= 4'b1000;
                        end
                end

		old_enemy_finish_out <= enemy_finish_out;
		old_menu_finish_out <= menu_finish_out;
		old_player_finish_out <= player_finish_out;
		old_game_over_out <= game_over_out;
	end
end
assign font_color_in = {color_r_in,color_g_in,color_b_in};
endmodule
`default_nettype wire
