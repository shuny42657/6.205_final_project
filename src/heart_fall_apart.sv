`timescale 1ns / 1ps
`default_nettype none
module heart_fall_apart #(parameter COLOR = 12'h0F0)(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire valid_in,

	output logic in_sprite,
	output logic[11:0] pixel_out
);

logic[10:0] part_1_x,part_2_x,part_3_x,part_4_x,part_5_x,part_6_x;
logic[9:0] part_1_y,part_2_y,part_3_y,part_4_y,part_5_y,part_6_y;
logic[5:0] in_sprite_buffer;
logic[2:0] mirror_switch_interval;
logic mirror_switch;

heart_fall_apart_sprite part_1(.x_in(part_1_x),.hcount_in(hcount_in),.y_in(part_1_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[0]));
heart_fall_apart_sprite part_2(.x_in(part_2_x),.hcount_in(hcount_in),.y_in(part_2_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[1]));
heart_fall_apart_sprite part_3(.x_in(part_3_x),.hcount_in(hcount_in),.y_in(part_3_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[2]));
heart_fall_apart_sprite part_4(.x_in(part_4_x),.hcount_in(hcount_in),.y_in(part_4_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[3]));
heart_fall_apart_sprite part_5(.x_in(part_5_x),.hcount_in(hcount_in),.y_in(part_5_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[4]));
heart_fall_apart_sprite part_6(.x_in(part_6_x),.hcount_in(hcount_in),.y_in(part_6_y),.vcount_in(vcount_in),.mirror_in(mirror_switch),.in_sprite(in_sprite_buffer[5]));

always_comb begin
	in_sprite = in_sprite_buffer != 0;
	pixel_out = in_sprite ? COLOR : 0;
end
always_ff @(posedge clk)begin
	if(rst)begin
		part_1_x <= 512;
		part_2_x <= 512;
		part_3_x <= 512;
		part_4_x <= 512;
		part_5_x <= 512;
		part_6_x <= 512;
		part_1_y <= 384;
		part_2_y <= 384;
		part_3_y <= 384;
		part_4_y <= 384;
		part_5_y <= 384;
		part_6_y <= 384;

	end
	else begin
		if(valid_in)begin
			if(hcount_in == 0 && vcount_in == 0)begin
				mirror_switch_interval <= mirror_switch_interval + 1;
				if(mirror_switch_interval[1:0] ==2'b0)
					mirror_switch <= ~mirror_switch;
					

				part_1_y <= part_1_y - 2;
				/*part_2_x <= part_2_x - 4;
				part_2_y <= part_2_y + 4;
				part_3_x <= part_3_x + 2;
				part_3_y <= part_3_y + 5;
				part_4_x <= part_4_x + 2;
				part_4_y <= part_4_y + 2;
				part_5_x <= part_5_x + 1;
				part_5_x <= part_5_x + 2;
				part_6_x <= part_6_x + 4;
				part_6_y <= part_6_y + 1;*/

			end
		end
	end
end

endmodule
`default_nettype wire

