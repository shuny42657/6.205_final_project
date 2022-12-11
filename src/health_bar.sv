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
logic health_amount;
logic[10:0] border_x;
logic in_sprite;
logic is_left;
logic old_damage_in;
logic[5:0] tens,ones;
always_ff @(posedge clk)begin
	//letter_in[1] = 6'b011011;
	//letter_in[0] = 6'b011100;
	if(rst)begin
		health_amount <= 56;
		tens <= 5;
		ones <= 6;
		border_x <= 592; 
	end
	else begin
		if(old_damage_in != damage_in && damage_in && border_x >= 496)begin
			//health_amount <= health_amount - 8;
			border_x <= border_x - 16;
			if(ones < 8)begin
				ones <= ones + 2;
				tens <= tens - 1;
			end else
				ones <= ones - 8;
		end
	end
	old_damage_in <= damage_in;
end

//logic [11:0] letter_in[1:0];
logic [11:0] health_number_pixel_out[4:0];
logic [4:0] health_number_out;

fonts #(700,588) five(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b011100),.color_in(12'hFFF),.scale_in(1),.pixel_out(health_number_pixel_out[3]),.in_sprite(health_number_out[3]));
fonts #(730,588) six(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b011101),.color_in(12'hFFF),.scale_in(1),.pixel_out(health_number_pixel_out[2]),.in_sprite(health_number_out[2]));
fonts #(600,588) tens_(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(tens + 23),.color_in(12'hFFF),.scale_in(1),.pixel_out(health_number_pixel_out[1]),.in_sprite(health_number_out[1]));
fonts #(630,588) ones_(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(ones + 23),.color_in(12'hFFF),.scale_in(1),.pixel_out(health_number_pixel_out[0]),.in_sprite(health_number_out[0]));

fonts #(670,588) sl(.hcount_in(hcount_in),.vcount_in(vcount_in),.valid_in(1),.letter_in(6'b100101),.color_in(12'hFFF),.scale_in(1),.pixel_out(health_number_pixel_out[4]),.in_sprite(health_number_out[4]));

//assign border_x = POS_X + health_amount*2;
always_comb begin
	if(hcount_in >= POS_X&&hcount_in<= border_x&&vcount_in >= POS_Y && vcount_in <= POS_Y + HEIGHT)
		pixel_out = 12'hFF0;
	else if(hcount_in > border_x&&hcount_in <= POS_X+WIDTH&&vcount_in>=POS_Y&&vcount_in<=POS_Y+HEIGHT)
		pixel_out = 12'hF00;
	else if(health_number_out != 0)
		pixel_out = 12'hFFF;
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

