`timescale 1ns / 1ps
`default_nettype none

module arrow #(parameter WIDTH = 8,HEIGHT = 32)(
	input wire clk,
	input wire[10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire valid_in,
	input wire[2:0] speed_in,
	input wire[1:0] direction_in,
	input wire inversed_in,

	output logic[11:0] pixel_out,
	output logic valid_out
);

logic[10:0] x;
logic[9:0] y;
logic old_valid_in;

always_ff @(posedge clk)begin
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
				x <= 512;
				y <= 0;
			end
		endcase
	end else if(old_valid_in && valid_in)begin
		if(hcount_in == 0 && vcount_in == 0)begin
			case(direction_in)
                        	2'b00:begin
                                	y <= y + 4;
                        	end
                        	2'b01:begin
                                	y <= y - 4;
                        	end
                        	2'b10:begin
                                	x <= x + 4;
                        	end
                        	2'b11:begin
                                	y <= y + 4;
                        	end
			endcase


		end

	end
	old_valid_in <= valid_in;
end
assign valid_out = (hcount_in >= x) && (hcount_in <= x+WIDTH) && (vcount_in >= y) && (vcount_in <= y+HEIGHT);
assign pixel_out = valid_out ? 12'hF00 : 0;
endmodule
`default_nettype wire

