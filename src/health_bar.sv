`timescale 1ns / 1ps
`default_nettype none

module health_bar #(parameter POS_X = 480,parameter POS_Y = 720,parameter WIDTH = 96,parameter HEIGHT = 32)(
	input wire clk,
	input wire rst,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire damage_in,
	output logic[11:0] pixel_out
);

logic[10:0] border_x;
logic in_sprite;
logic is_left;
logic old_damage_in;
always_ff @(posedge clk)begin
	if(rst)begin
		border_x <= 528; 
	end
	else begin
		if(hcount_in == 0 && vcount_in == 0)begin
			if(old_damage_in != damage_in && damage_in)
				border_x <= border_x - 4;
		end
	end
	old_damage_in <= damage_in;
end

always_comb begin
	if(hcount_in >= POS_X&&hcount_in<= border_x&&vcount_in >= POS_Y && vcount_in <= POS_Y + HEIGHT)
		pixel_out = 12'hFF0;
	else if(hcount_in > border_x&&hcount_in <= POS_X+WIDTH&&vcount_in>=POS_Y&&vcount_in<=POS_Y+HEIGHT)
		pixel_out = 12'hF00;
	else
		pixel_out = 12'h0;
	/*in_sprite = (hcount_in >= POS_X) && (hcount_in <= POS_X + WIDTH) && (vcount_in >= POS_Y) && (vcount_in <= POS_Y + HEIGHT);
	if(hcount_in >= border_x)
		is_left = 0;
	else
		is_left = 1;
	if(in_sprite && is_left)
		pixel_out = 12'hFFFF00;
	else if(in_sprite && ~is_left)
		pixel_out = 12'hFF0000;
	else
		pixel_out = 12'h0;*/
end
endmodule
`default_nettype wire

