module fonts #(parameter X_POS = 128,Y_POS = 128)(
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  input wire[4:0] letter_in,
  input wire[11:0] color_in,
  input wire[3:0] scale_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);


logic in_sprite_buffer;
logic[10:0] relative_x;
logic[9:0] relative_y;
logic[4:0] modified_x;
logic[4:0] modified_y;

logic[11:0] g_bram[11:0];
/*pixel filling for "G"*/
assign g_bram[0] = 12'h7FF;
assign g_bram[1] = 12'hFFF;
assign g_bram[2] = 12'hF00;
assign g_bram[3] = 12'hF00;
assign g_bram[4] = 12'hF3F;
assign g_bram[5] = 12'hF3F;
assign g_bram[6] = 12'hF3F;
assign g_bram[7] = 12'hF0F;
assign g_bram[8] = 12'hF0F;
assign g_bram[9] = 12'hF0F;
assign g_bram[10] = 12'hFFF;
assign g_bram[11] = 12'h7FF;

/*pixel filling for "A"*/
logic[11:0] a_bram[11:0]
assign a_bram[0] = 12'h7FF;
assign a_bram[1] = 12'hFFF;
assign a_bram[2] = 12'hF00;
assign a_bram[3] = 12'hF00;
assign a_bram[4] = 12'hF3F;
assign a_bram[5] = 12'hF3F;
assign a_bram[6] = 12'hF3F;
assign a_bram[7] = 12'hF0F;
assign a_bram[8] = 12'hF0F;
assign a_bram[9] = 12'hF0F;
assign a_bram[10] = 12'hFFF;
assign a_bram[11] = 12'h7FF;

always_comb begin
	case(letter_in)
		4'b0001:begin
			relative_x <= hcount_in - X_POS;
                	relative_y <= vcount_in - Y_POS;
                	if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                        	modified_x = 11 - (relative_x >> scale_in);
                        	modified_y = relative_y >> scale_in;
                        	in_sprite_buffer = g_bram[modified_y][modified_x];
                        	//in_sprite_buffer = pixel_bram[3][0];
                	end
                	else
                        	in_sprite_buffer = 0;
		end
	endcase
       /*relative_x <= hcount_in - X_POS;
       relative_y <= vcount_in - Y_POS;
       if(relative_x >= 0 && relative_x <= 23 && relative_y >= 0 && relative_y <= 23)begin
	       modified_x = 11- (relative_x >> 1);
	       modified_y = relative_y >> 1;
	       in_sprite_buffer = g_bram[modified_y][modified_x];
	       //in_sprite_buffer = g_bram[3][0]
	end
	else
		in_sprite_buffer = 0;*/

end
assign in_sprite = in_sprite_buffer;
assign pixel_out = in_sprite_buffer ? color_in : 0;

endmodule
