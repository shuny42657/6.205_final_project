`timescale 1ns / 1ps
`default_nettype none

module enemy_health_bar #(parameter POS_X = 480,parameter POS_Y = 720,parameter WIDTH = 96,parameter HEIGHT = 32,parameter FILL_COLOR = 12'h0F0,parameter BASE_COLOR = 12'h333)(
	input wire valid_in,
        input wire[10:0] hcount_in,
        input wire[9:0] vcount_in,
	input wire[10:0] border_in,
        output logic[11:0] pixel_out
);


logic in_sprite;
logic is_left;

always_comb begin
        if(hcount_in >= POS_X&&hcount_in<= POS_X + border_in && vcount_in >= POS_Y && vcount_in <= POS_Y + HEIGHT)
                pixel_out = valid_in ? 12'h0F0 : 0;
        else if(hcount_in > POS_X + border_in && hcount_in <= POS_X+WIDTH&&vcount_in>=POS_Y&&vcount_in<=POS_Y+HEIGHT)
                pixel_out = valid_in ? 12'h333 : 0;
        else
                pixel_out = 12'h0;
end
endmodule
`default_nettype wire

