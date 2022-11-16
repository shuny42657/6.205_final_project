`timescale 1ns / 1ps
`default_nettype none

module game_state(
	input wire clk,
	input wire rst,

	input wire [10:0] hcount_in,
	input wire[9:0] vcount_in,
	input wire[1:0] rotate_in,

	output logic[11:0] pixel_out
);

logic[3:0] state_out;
logic[3:0] turn_out;
/*
* 4'b1000 = enemy
* 4'b0000 = menu
* 4'b0001 = player
*/
logic enemy_busy_out;
logic enemy_finish_out;
logic[11:0] enemy_pixel_out;
//assign state_out = 4'b1000;
assign turn_out = 4'b0000;
enemy en(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.turn_in(turn_out),
	.rotate_in(rotate_in),
	.busy_out(enemy_busy_out),
	.finished_out(enemy_finish_out),
	.pixel_out(enemy_pixel_out)

);

menu mn(
	.clk(clk),
	.rst(rst),
	.hcount_in(hcount_in),
	.vcount_in(vcount_in),
	.state_in(state_out),
	.busy_out(menu_busy_out),
	.finished_out(menu_finish_out),
	.pixel_out(menu_pixel_out)
);
logic menu_busy_out;
logic menu_finish_out;
logic[11:0] menu_pixel_out;

always_comb begin
	case(state_out)
		4'b1000:begin
			pixel_out = enemy_pixel_out;
		end
		4'b0000:begin
			pixel_out = menu_pixel_out;
		end
	endcase
end

always_ff @(posedge clk)begin
	if(rst)begin
		state_out <= 4'b1000;
	end
	else begin
		if(enemy_finish_out)begin
			//shift to next state
			state_out <= 4'b0000;
		end
		else if(menu_finish_out)begin
			state_out <= 4'b1000;
		end
	end
end

endmodule
`default_nettype wire
