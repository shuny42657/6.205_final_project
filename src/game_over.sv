`timescale 1ns / 1ps
`default_nettype none

module game_over(
	input wire clk,
        input wire rst,

        input wire [10:0] hcount_in,
        input wire[9:0] vcount_in,
	input wire[3:0] state_in, //used to check if this module is busy

	output logic busy_out, //busy while this is high
        output logic finished_out, //asserted high for one clk cycle when the module exits busy state
	output logic[11:0] pixel_out //pixel output
);
logic[3:0] old_state_in;
logic[2:0] animation_phase;
logic busy_out_buffer;
logic pixel_out_buffer;
logic[31:0] timing_count;
always_ff @(posedge clk)begin
	/*if(rst)begin
		old_state_in <= 4'b1010;
		animation_phase <= 0;
		busy_out_buffer <= 0;
		pixel_out_buffer <= 0;
		timing_count <= 0;
	end
	else begin
		if(state_in == 4'b1111 && busy_out_buffer == 0)begin
			busy_out_buffer <= 1;
		end
		if(state_in == 4'b1111)begin
			if(animation_phase == 0)begin
				pixel_out_buffer <= 12'h0F0;
				timing_count <= timing_count + 1;
				if(timing_count == 65000000)begin
					timing_count <= 0;
					animation_phase <= 1;
				end
			end
			else if(animation_phase ==1)begin
				pixel_out_buffer <= 12'hF00;
			end
			old_state_in <= state_in;
		end
		//old_state_in <= state_in;
	end*/

        	//if(state_in == 4'b1111)begin
			animation_phase <= 0;
                        if(animation_phase == 0)begin
                                pixel_out_buffer <= 12'h0F0;
                                timing_count <= timing_count + 1;
                                if(timing_count == 65000000)begin
                                        timing_count <= 0;
                                        animation_phase <= 1;
                                end
                        end
                        else if(animation_phase ==1)begin
                                pixel_out_buffer <= 12'hF00;
                        end
                        old_state_in <= state_in;
                //end

end

assign busy_out = busy_out_buffer;
assign pixel_out = pixel_out_buffer; 
endmodule
`default_nettype wire

