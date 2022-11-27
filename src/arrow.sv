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

	output logic[11:0] pixel_out,
	output logic valid_out,
	output logic hit_player
);


logic[10:0] x;
logic[9:0] y;
logic old_valid_in;
logic valid_out_buffer;
logic is_hit;
logic hit_player_buffer;
logic old_hit_player_buffer;
always_ff @(posedge clk)begin
	/*if(rst)begin
		//pixel_out <= 0;
		//valid_out <= 0;
		//hit_player_buffer <= 0;
	end
	else begin*/
		if(~old_valid_in && valid_in)begin
                	case(direction_in)
                        	2'b00:begin
                                	x <= 512;
                                	y <= 0;
                        	end
                        	2'b01:begin
                                	x <= 512;
                                	y <= 720;
                        	end
                        	2'b10:begin
                                	x <= 0;
                                	y <= 384;
                        	end
                        	2'b11:begin
                                	x <= 1024;
                                	y <= 384;
                        	end
                	endcase
			is_hit <= 0;
			hit_player <= 0;
        	end else if(old_valid_in && valid_in)begin
                	if(hcount_in == 0 && vcount_in == 0)begin
                        	case(direction_in)
                                	2'b00:begin
                                        	y <= y + 4;
						if(rotate_in == 2'b00 && y >= 288 && y <= 320 && ~is_hit)begin
							is_hit <= 1;
						end
						else if(y >= 384 && ~is_hit)begin
							is_hit <= 1;
							//hit_player_buffer <= 1;
							hit_player <= 1;
						end
                               	 	end
                                	2'b01:begin
                                        	y <= y - 4;
						if(rotate_in == 2'b01 && y <= 440 && y <= 472 && ~is_hit)begin
							is_hit <= 1;
						end
						else if(y <= 384 && ~is_hit)begin
							is_hit <= 1;
							hit_player_buffer <= 1;
						end
                                	end
                                	2'b10:begin
                                        	x <= x + 4;
						if(rotate_in == 2'b10 && x >= 448 && x <= 480 && ~is_hit)begin
							is_hit <= 1;
						end
						if(x >= 512 && ~is_hit)begin
							is_hit <= 1;
							hit_player_buffer <= 1;
						end
                                	end
                                	2'b11:begin
                                        	x <= x - 4;
						if(rotate_in == 2'b11 && x <= 568 && x >= 536 && ~is_hit)begin
							is_hit <= 1;
						end
						else if(x <= 512 && ~is_hit)begin
							is_hit <= 1;
							hit_player_buffer <= 1;
						end
                                	end
                        	endcase
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
end
assign valid_out = (valid_in && ~is_hit) ? ((hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT)) : 0;
//assign hit_player = hit_player_buffer;
/*always_comb begin
	valid_out_buffer = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
end*/
//assign valid_out = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
//assign valid_out = valid_out_buffer;
assign pixel_out = valid_out ? 12'hF00 : 0;
endmodule
`default_nettype wire

