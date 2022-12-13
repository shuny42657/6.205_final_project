`timescale 1ns / 1ps
`default_nettype none

module arrow #(parameter WIDTH = 8,HEIGHT = 32)(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire valid_in,
	input wire[2:0] speed_in,
	input wire[1:0] direction_in,
	input wire inversed_in,
	input wire[1:0] rotate_in,
	input wire next_in,

	output logic[11:0] pixel_out,
	output logic valid_out,
	output logic is_hit,
	output logic hit_player
);


logic[10:0] x;
logic[9:0] y;
logic old_valid_in;
logic in_sprite_buffer;
logic valid_out_buffer;
logic is_hit_once;
logic is_hit_buffer;
logic hit_player_buffer;
logic old_hit_player_buffer;
logic[1:0] inverse_state;
logic[11:0] pixel_out_buffer;
//inverse_state = 0 : normal
//inverse_state = 1 : parabora trajectory
//inverse_state = 2 : inversed
arrow_sprite #(12'hF00,12'h0CF) arrow_color (.x_in(x),.hcount_in(hcount_in),.y_in(y),.vcount_in(vcount_in),.rotate_in(direction_in),.next_in(next_in),.pixel_out(pixel_out_buffer),.in_sprite(in_sprite_buffer));
always_ff @(posedge clk)begin
	if(rst)begin
		//pixel_out <= 0;
		//valid_out <= 0;
		is_hit_once <= 0;
		hit_player_buffer <= 0;
		is_hit_buffer <= 0;
	end
	else begin
		if(~old_valid_in && valid_in)begin
                	case(direction_in)
                        	2'b00:begin
                                	x <= 512;
                                	y <= 0;
                        	end
                        	2'b01:begin
                                	x <= 512;
                                	y <= 767;
                        	end
                        	2'b10:begin
                                	x <= 128;
                                	y <= 384;
                        	end
                        	2'b11:begin
                                	x <= 896;
                                	y <= 384;
                        	end
                	endcase
			is_hit_once <= 0;
			is_hit_buffer <= 0;
			hit_player_buffer <= 0;
			inverse_state <= 0;
        	end else if(old_valid_in && valid_in)begin
                	if(hcount_in == 0 && vcount_in == 0)begin
                        	case(direction_in)
					2'b00:begin//top
						if(inverse_state == 0)begin
							y <= y + speed_in;
							if (y >= 274 && inversed_in == 1)
								inverse_state <= 1;
							if(rotate_in == 2'b00 && y >= 288 && y <= 320 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                	end
                                                	else if(y >= 384 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                        	hit_player_buffer <= 1;
                                                        //hit_player <= 1;
                                                	end
						end
						else if(inverse_state == 1)begin
							y <= y + speed_in*2;
							if(x <= 511)begin
								inverse_state <= 2;
							end else begin
								if(y <= 384)begin
                                                                	x <= 607 - ((384-y) >> 4)*((384-y) >> 3);
                                                        	end
                                                        	else if(y > 384)begin
                                                                	x <= 607 - ((y-384) >> 4)*((y-384) >> 3);
                                                        	end
							end
							/*if(y <= 384)begin
								x <= 607 - ((384-y) >> 4)*((384-y) >> 3);
							end
							else if(y > 384)begin
								x <= 607 - ((y-384) >> 4)*((y-384) >> 3);

							end
							if(y >= 470 || x <= 512)begin
								inverse_state <= 2;
							end*/
						end
						else if(inverse_state == 2)begin
							y <= y - speed_in;
							if(rotate_in == 2'b01 && y <= 440 && y >= 408 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                	end
                                                	else if(y <= 384 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                        	hit_player_buffer <= 1;
                                                	end
						end

                               	 	end
                                	2'b01:begin//bottom
						if(inverse_state == 0)begin
							y <= y - speed_in;
							if(y <= 494 && inversed_in == 1)begin
								inverse_state <= 1;
							end
							if(rotate_in == 2'b01 && y <= 440 && y >= 408 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                        end
                                                        else if(y <= 384 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                                hit_player_buffer <= 1;
                                                        end
						end
						else if(inverse_state == 1)begin
							y <= y - speed_in*2;
							if(x >= 513)begin
								inverse_state <= 2;
							end
							else begin
								if(y <= 384)begin
                                                                        x <= 417 + ((384-y) >> 4)*((384-y) >> 3);
                                                                end
                                                                else if(y > 384)begin
                                                                        x <= 417 + ((y-384) >> 4)*((y-384) >> 3);
                                                                end
							end

						end
						else if(inverse_state == 2)begin
							y <= y + speed_in;
							if(rotate_in == 2'b00 && y >= 288 && y <= 320 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                        end
                                                        else if(y >= 384 && ~is_hit_once)begin
								is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                                hit_player_buffer <= 1;
                                                        end
						end
                                	end
                                	2'b10:begin//right
						if(inverse_state == 0)begin
							x <= x + speed_in;
							if(x >= 402 && inversed_in == 1)
								inverse_state <= 1;
							if(rotate_in == 2'b11 && x >= 448 && x <= 480 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                	end
                                                	if(x >= 512 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                        	hit_player_buffer <= 1;
                                                	end
						end
						else if(inverse_state == 1)begin
							x <= x + speed_in*2;
							if(y >= 385)
								inverse_state <= 2;
							else begin
								if(x <= 512)
									y <= 289 + ((512-x)>>4)*((512-x)>>3);
								else if(x > 512)
									y <= 289 + ((x-512)>>4)*((x-512)>>3);
							end
						end
						else if(inverse_state == 2)begin
							x <= x - speed_in;
							if(rotate_in == 2'b10 && x <= 568 && x >= 536 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                	end
                                                	else if(x <= 512 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                        	hit_player_buffer <= 1;
                                                	end
						end
                                	end
                                	2'b11:begin//left
						if(inverse_state == 0)begin
							x <= x - speed_in;
							if(x <= 622 && inversed_in == 1)
								inverse_state <= 1;
                                                	if(rotate_in == 2'b10 && x <= 568 && x >= 536 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                	end
                                                	else if(x <= 512 && ~is_hit_once)begin
                                                        	is_hit_once <= 1;
                                                        	is_hit_buffer <= 1;
                                                        	hit_player_buffer <= 1;
                                                	end
						end
						else if(inverse_state == 1)begin
							x <= x - speed_in*2;
							if(y >= 385)
								inverse_state <= 2;
							else begin
								if(x <= 512)
                                                                        y <= 289 + ((512-x)>>4)*((512-x)>>3);
                                                                else if(x > 512)
                                                                        y <= 289 + ((x-512)>>4)*((x-512)>>3);
							end
						end
						else if(inverse_state == 2)begin
							x <= x + speed_in;
							if(x >= 402 && inverse_state == 0)
                                                                inverse_state <= 1;
                                                        if(rotate_in == 2'b11 && x >= 448 && x <= 480 && ~is_hit_once)begin
                                                                is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                        end
                                                        if(x >= 512 && ~is_hit_once)begin
                                                                is_hit_once <= 1;
                                                                is_hit_buffer <= 1;
                                                                hit_player_buffer <= 1;
                                                        end
							
						end
                                	end
                        	endcase
                	end
		end
	end
		/*if(hit_player_buffer)
			hit_player_buffer <= 0;*/
	//end
	//valid_out = valid_in ? /*(hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT)*//*1 : 0;
	//valid_out = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
	//pixel_out = valid_out ? 12'hF00 : 0;
	old_valid_in <= valid_in;
	if(hit_player_buffer)
		hit_player_buffer <= 0;
	if(is_hit_buffer)
		is_hit_buffer <= 0;
end
assign is_hit = is_hit_buffer;
assign valid_out = (valid_in && ~is_hit_once) ? /*((hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT))*/in_sprite_buffer : 0;
assign hit_player = hit_player_buffer;
/*always_comb begin
	valid_out_buffer = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
end*/
//assign valid_out = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
//assign valid_out = valid_out_buffer;
assign pixel_out = valid_out ? pixel_out_buffer : 0;
endmodule
`default_nettype wire

