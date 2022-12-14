`default_nettype none

module pattern #(parameter ARROWS = 24,parameter TIMING = 72'b0,parameter SPEED = 72'b0,parameter DIRECTION = 48'b0,parameter INVERSED = 24'b0,parameter TURN = 4'b0)(
	input wire[3:0] turn_in,
	output logic[4:0] arrows,
	output logic[71:0] timing,
	output logic[71:0] speed,
	output logic[47:0] direction,
	output logic[23:0] inversed
);


always_comb begin
	if(turn_in == TURN)begin
		arrows = ARROWS;
		timing = TIMING;
		speed = SPEED;
		direction = DIRECTION;
		inversed = INVERSED;
	end
end

endmodule

`default_nettype wire
