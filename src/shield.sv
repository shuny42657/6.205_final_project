`default_nettype none
`timescale 1ns / 1ps
module shield(
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[1:0] rotate_in,

	output logic[11:0] pixel_out
);

logic[10:0] x,width;
logic[9:0] y,height;
always_comb begin
	case(rotate_in)
		2'b00:begin
			x = 448;
			y = 320;
			width = 128;
			height = 4;
		end
		2'b01:begin
			x = 448;
			y = 320;
			width = 4;
			height = 128;
		end
		2'b10:begin
			x = 568;
			y = 320;
			width = 4;
			height = 128;
		end
		2'b11:begin
			x = 448;
			y = 440;
			width = 128;
			height = 4;
		end
	endcase
end
logic in_sprite;
assign in_sprite = (hcount_in >= 448) /*&& (hcount_in <= 566)  && ((vcount_in >= 320) && (vcount_in <= 328)))*/;
assign pixel_out = in_sprite ? 12'hFFF : 0;
endmodule
`default_nettype wire

