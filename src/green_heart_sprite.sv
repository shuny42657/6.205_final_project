module green_heart_sprite #(parameter X_POS = 128,Y_POS = 128,COLOR = 12'hF00)(
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  input wire divided_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);

logic[15:0] pixel_bram[15:0];
logic in_sprite_buffer;
logic[10:0] relative_x;
logic[9:0] relative_y;
logic[4:0] modified_x;
logic[4:0] modified_y;
assign pixel_bram[0]  = 16'b0001110000111000;
assign pixel_bram[1]  = 16'b0011111001111100;
assign pixel_bram[2]  = 16'b0111111111111110;
assign pixel_bram[3]  = 16'hFFFF;
assign pixel_bram[4]  = 16'hFFFF;
assign pixel_bram[5]  = 16'hFFFF;
assign pixel_bram[6]  = 16'hFFFF;
assign pixel_bram[7]  = 16'hFFFF;
assign pixel_bram[8]  = 16'hFFFF;
assign pixel_bram[9]  = 16'b0111111111111110;
assign pixel_bram[10] = 16'b0011111111111100;
assign pixel_bram[11] = 16'b0001111111111000;
assign pixel_bram[12] = 16'b0000111111110000;
assign pixel_bram[13] = 16'b0000011111100000;
assign pixel_bram[14] = 16'b0000001111000000;
assign pixel_bram[15] = 16'b0000000110000000;

always_comb begin
	if(~divided_in)begin
		relative_x <= hcount_in - X_POS;
        	relative_y <= vcount_in - Y_POS;
        	if(relative_x >= 0 && relative_x <= 31 && relative_y >= 0 && relative_y <= 31)begin
                	modified_x = relative_x >> 1;
                	modified_y = relative_y >> 1;
                	in_sprite_buffer = pixel_bram[modified_y][modified_x];
                	//in_sprite_buffer = pixel_bram[3][0];
        	end
        	else
                	in_sprite_buffer = 0;

	end
	else begin
		relative_x <= hcount_in - X_POS;
		relative_y <= vcount_in - Y_POS;
		if(relative_x >= 0 && relative_x <= 35 && relative_y >= 0 && relative_y <= 31)begin
			if(relative_x <= 15)begin
				modified_x = relative_x >> 1;
				modified_y = relative_y >> 1;
			end
			else if(relative_x >= 16 && relative_x <= 19)begin
				modified_x = 0;
				modified_y = 0;
			end
			else begin
				modified_x = (relative_x - 4) >> 1;
				modified_y = relative_y >> 1;
			end
			in_sprite_buffer = pixel_bram[modified_y][modified_x];
		end
		else
			in_sprite_buffer = 0;
	end
end

assign in_sprite = in_sprite_buffer;
assign pixel_out = in_sprite_buffer ? COLOR : 0;

endmodule

