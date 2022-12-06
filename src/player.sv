`default_nettype none
`timescale 1ns / 1ps
module player(
        input wire clk,
        input wire rst,
        input wire[10:0] hcount_in,
        input wire[9:0] vcount_in,
        input wire[3:0] state_in,
	input wire[1:0] rotate_in,
        output logic busy_out,
        output logic finished_out,
        output logic[11:0] pixel_out
);

logic frame_top_out,frame_bottom_out,frame_right_out,frame_left_out,attack_bar_out;
logic[11:0] frame_top_pixel;
logic[11:0] frame_bottom_pixel;
logic[11:0] frame_right_pixel;
logic[11:0] frame_left_pixel;
logic[11:0] attack_bar_pixel;
logic[11:0] attack_bar_color;
/*block_sprite #(768,8,128,384,12'hFFF) frame_top(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
block_sprite #(8,192,128,384,12'hFFF) frame_left(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_left_out),.pixel_out(frame_left_pixel));
block_sprite #(8,192,888,384,12'hFFF) frame_right(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_right_out),.pixel_out(frame_right_pixel));
block_sprite #(768,8,128,568,12'hFFF) frame_bottom(.is_fixed(1),.x_in(0),.hcount_in(hcount_in),.y_in(0),.vcount_in(vcount_in),.in_sprite(frame_bottom_out),.pixel_out(frame_bottom_pixel));*/
logic[10:0] top_x,bottom_x,left_x,right_x,top_width,bottom_width,left_width,right_width;
logic[9:0] top_y,botton_y,left_y,right_y,top_height,bottom_height,left_height,right_height;

frame_sprite #(12'hFFF) frame_top(.x_in(top_x),.hcount_in(hcount_in),width_in(top_width),.y_in(top_y),.vcount_in(vcount_in),.height_in(top_height),.pixel_out(frame_top_pixel),.in_sprite(frame_top_out));
frame_sprite #(12'hFFF) frame_left(.x_in(left_x),.hcount_in(hcount_in),width_in(left_width),.y_in(left_y),.vcount_in(vcount_in),.height_in(left_height),.pixel_out(frame_left_pixel),.in_sprite(frame_left_out));
frame_sprite #(12'hFFF) frame_right(.x_in(right_x),.hcount_in(hcount_in),width_in(right_width),.y_in(right_y),.vcount_in(vcount_in),.height_in(right_height),.pixel_out(frame_right_pixel),.in_sprite(frame_right_out));
frame_sprite #(12'hFFF) frame_bottom(.x_in(bottom_x),.hcount_in(hcount_in),width_in(bottom_width),.y_in(bottom_y),.vcount_in(vcount_in),.height_in(bottom_height),.pixel_out(frame_bottom_pixel),.in_sprite(frame_bottom_out));
attack_bar_sprite #(8,160) attack_bar(.color_in(attack_bar_color),.x_in(attack_bar_x),.hcount_in(hcount_in),.y_in(attack_bar_y),.vcount_in(vcount_in),.in_sprite(attack_bar_out),.pixel_out(attack_bar_pixel));
logic [10:0] attack_bar_x;
logic [9:0] attack_bar_y;

logic attack_board_out;
logic[11:0] attack_board_pixel;
image_sprite #(750,172,"attack_board.mem","attack_board_palette.mem") attack_board(.pixel_clk_in(clk),.rst_in(rst),.x_in(130),.hcount_in(hcount_in),.y_in(390),.vcount_in(vcount_in),.pixel_out(attack_board_pixel),.in_sprite(attack_board_out));


logic[11:0] enemy_health_bar_out;
logic[11:0] enemy_health_bar_border_in;
enemy_health_bar #(416,288,192,16) enemy_health(.clk(clk),.rst(rst),.valid_in(bar_stopped),.hcount_in(hcount_in),.vcount_in(vcount_in),.border_in(enemy_health_bar_border_in),.pixel_out(enemy_health_bar_out));
logic busy_out_buffer;
logic[3:0] old_state_in;
logic swipe_set; //set high when rotate_in once becomes 2'b00 (up)
logic bar_stopped; //set high when bar should be stopped
logic[1:0] frame_moving;
logic[10:0] round_damage;
logic[31:0] timing_count;
logic[4:0] flash_count;
always_comb begin
        if(busy_out_buffer == 1)begin
		if(frame_moving == 0)
			pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel + attack_bar_pixel + enemy_health_bar_out +  attack_board_pixel;
		else
			pixel_out = frame_bottom_pixel + frame_top_pixel + frame_left_pixel + frame_right_pixel;
        end
end
always_ff @(posedge clk)begin
        if(rst)begin
                finished_out <= 0;
                busy_out_buffer <= 0;
                old_state_in = 4'b1010;
		enemy_health_bar_border_in <= 192;
		attack_bar_color <= 12'hFFF;
		top_x <= 128;
		top_y <= 384;
		top_width <= 768;
		top_height <= 8;
		left_x <= 128;
		left_y <= 384;
		left_width <= 8;
		left_height <= 192;
		right_x <= 888;
		right_y <= 384;
		right_width <= 192;
		right_height <= 8;
		bottom_x <= 128;
		bottom_y <= 568;
		bottom_width <= 768;
		bottom_height <= 8;
        end
        else begin
                if(old_state_in != state_in && state_in == 4'b0001)begin
                        busy_out_buffer <= 1;
                        timing_count <= 0;
			attack_bar_x <= 128;
			attack_bar_y <= 400; 
			swipe_set <= 0;
			bar_stopped <= 0;
			//enemy_health_bar_border_in <= 192;
			round_damage <= 24;
			attack_bar_color <= 12'hFFF;
			flash_count <= 0;
			top_x <= 128;
                	top_y <= 384;
                	top_width <= 768;
                	top_height <= 8;
                	left_x <= 128;
                	left_y <= 384;
                	left_width <= 8;
                	left_height <= 192;
                	right_x <= 888;
                	right_y <= 384;
                	right_width <= 192;
                	right_height <= 8;
                	bottom_x <= 128;
                	bottom_y <= 568;
                	bottom_width <= 768;
                	bottom_height <= 8;
                end
                if(busy_out_buffer == 1)begin
			if(rotate_in == 2'b00 && ~swipe_set)
				swipe_set <= 1;
			if(rotate_in == 2'b01 && swipe_set)begin
				//busy_out_buffer <= 0;
				//finished_out <= 1;
				bar_stopped <= 1;
			end
			if(hcount_in == 0 && vcount_in == 0)begin
				attack_bar_x <= bar_stopped ? attack_bar_x : attack_bar_x + 8;
				/*if(attack_bar_x >= 768)begin
					busy_out_buffer <= 0;
					finished_out <= 1;
				end*/
			end

			if(attack_bar_x >= 768)begin
				busy_out_buffer <= 0;
				finished_out <= 1;
			end
			
			if(bar_stopped)begin
				if(hcount_in == 0 && vcount_in == 0 && round_damage > 0)begin
					round_damage <= round_damage - 1;
					enemy_health_bar_border_in <= enemy_health_bar_border_in - 1;
				end
			        else if(round_damage == 0)begin
					timing_count <= timing_count + 1;
					if(hcount_in == 0 && vcount_in  == 0)begin
						flash_count <= flash_count + 1;
						if(flash_count == 10)begin
							flash_count <= 0;
							attack_bar_color <= attack_bar_color == 12'hFFF ? 12'h0 : 12'hFFF;
						end
					end
				        if(timing_count == 10*6500000)begin
						frame_moving <= 1;
						bar_stopped <= 0;
					        timing_count <= 0;
					        /*finished_out <= 1;
					        busy_out_buffer <= 0;
					        bar_stopped <= 0;*/
				        end
			        end
			end

			if(frame_moving == 1)begin
				if(hcount_in == 0 && vcount_in == 0)begin
					if(top_width = 160)
						frame_moving <= 2;
					else begin
						top_x <= top_x + 4;
                                        	bottom_x <= bottom_x + 4;
                                        	top_width <= 8;
                                        	bottom_width <= 8;
						left_x <= left_x + 4;
						right_x <= right_x - 4;
					end
				end
			end
			else if(frame_moving == 2)begin
				if(hcount_in == 0 && vcount_in == 0)begin
					if(top_y == 304)begin
						frame_moving <= 0;
						finished_out <= 1;
						busy_out_buffer <= 0;
					end
					else begin
						top_y <= top_y - 8;
						left_y <= left_y - 8;
						right_y <= right_y - 8;
						bottom_y <= bottom_y - 8;
					end
				end
			end
		end
                if(finished_out == 1 && state_in != 4'b0001)
			finished_out <= 0;
                old_state_in <= state_in;
        end
end
assign busy_out = busy_out_buffer;
//assign finished_out = 0;
endmodule
`default_nettype wire

