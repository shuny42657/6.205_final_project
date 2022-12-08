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
logic[11:0] a_bram[11:0];
assign a_bram[0] = 12'h7FE;
assign a_bram[1] = 12'hFFF;
assign a_bram[2] = 12'hF9F;
assign a_bram[3] = 12'hF9F;
assign a_bram[4] = 12'hF9F;
assign a_bram[5] = 12'hFFF;
assign a_bram[6] = 12'hFFF;
assign a_bram[7] = 12'hF9F;
assign a_bram[8] = 12'hF9F;
assign a_bram[9] = 12'hF9F;
assign a_bram[10] = 12'hF9F;
assign a_bram[11] = 12'hF9F;

/*pixel fillin for "M"*/
logic[17:0] m_bram[11:0];
assign m_bram[0]  = 18'b111111111111111110;
assign m_bram[1]  = 18'b111111111111111111;
assign m_bram[2]  = 18'b111100011110001111;
assign m_bram[3]  = 18'b111100011110001111;
assign m_bram[4]  = 18'b111100011110001111;
assign m_bram[5]  = 18'b111100011110001111;
assign m_bram[6]  = 18'b111100011110001111;
assign m_bram[7]  = 18'b111100011110001111;
assign m_bram[8]  = 18'b111100011110001111;
assign m_bram[9]  = 18'b111100011110001111;
assign m_bram[10] = 18'b111100011110001111;
assign m_bram[11] = 18'b111100011110001111;

/*pixel filling for "E"*/
logic[11:0] e_bram[11:0];
assign e_bram[0]  = 12'h7FF;
assign e_bram[1]  = 12'hFFF;
assign e_bram[2]  = 12'hF00;
assign e_bram[3]  = 12'hF00;
assign e_bram[4]  = 12'hF00;
assign e_bram[5]  = 12'hFF0;
assign e_bram[6]  = 12'hFF0;
assign e_bram[7]  = 12'hF00;
assign e_bram[8]  = 12'hF00;
assign e_bram[9]  = 12'hF00;
assign e_bram[10] = 12'hFFF;
assign e_bram[11] = 12'h7FF;

/*pixel filling for "O"*/
logic[11:0] o_bram[11:0];
assign o_bram[0] = 12'h7FE;
assign o_bram[1] = 12'hFFF;
assign o_bram[2] = 12'hF9F;
assign o_bram[3] = 12'hF9F;
assign o_bram[4] = 12'hF9F;
assign o_bram[5] = 12'hF9F;
assign o_bram[6] = 12'hF9F;
assign o_bram[7] = 12'hF9F;
assign o_bram[8] = 12'hF9F;
assign o_bram[9] = 12'hF9F;
assign o_bram[10] = 12'hFFF;
assign o_bram[11] = 12'h7FE;

/*pixel filling for "V"*/
logic[11:0] v_bram[11:0];
assign v_bram[0] = 12'hF1F;
assign v_bram[1] = 12'hF1F;
assign v_bram[2] = 12'hF1F;
assign v_bram[3] = 12'hF1F;
assign v_bram[4] = 12'hF1F;
assign v_bram[5] = 12'hF1F;
assign v_bram[6] = 12'hF1F;
assign v_bram[7] = 12'hF1F;
assign v_bram[8] = 12'hF1F;
assign v_bram[9] = 12'hF1F;
assign v_bram[10] = 12'hFFF;
assign v_bram[11] = 12'hFFE;

/*pixel filling for "R"*/
logic[11:0] r_bram[11:0];
assign r_bram[0]  = 12'hFFE;
assign r_bram[1]  = 12'hFFF;
assign r_bram[2]  = 12'hF1F;
assign r_bram[3]  = 12'hF1F;
assign r_bram[4]  = 12'hF1F;
assign r_bram[5]  = 12'hFFE;
assign r_bram[6]  = 12'hFFE;
assign r_bram[7]  = 12'hF1F;
assign r_bram[8]  = 12'hF1F;
assign r_bram[9]  = 12'hF1F;
assign r_bram[10] = 12'hF1F;
assign r_bram[11] = 12'hF1F;

/*pixel filling for "H"*/
logic[11:0] h_bram[11:0];
assign h_bram[0]  = 12'hF0F;
assign h_bram[1]  = 12'hF0F;
assign h_bram[2]  = 12'hF0F;
assign h_bram[3]  = 12'hF0F;
assign h_bram[4]  = 12'hF0F;
assign h_bram[5]  = 12'hFFF;
assign h_bram[6]  = 12'hFFF;
assign h_bram[7]  = 12'hF0F;
assign h_bram[8]  = 12'hF0F;
assign h_bram[9]  = 12'hF0F;
assign h_bram[10] = 12'hF0F;
assign h_bram[11] = 12'hF0F;

/*pixel filling for "P"*/
logic[11:0] p_bram[11:0];
assign p_bram[0]  = 12'hF0F;
assign p_bram[1]  = 12'hF0F;
assign p_bram[2]  = 12'hF0F;
assign p_bram[3]  = 12'hF0F;
assign p_bram[4]  = 12'hF0F;
assign p_bram[5]  = 12'hFFF;
assign p_bram[6]  = 12'hFFF;
assign p_bram[7]  = 12'hF0F;
assign p_bram[8]  = 12'hF0F;
assign p_bram[9]  = 12'hF0F;
assign p_bram[10] = 12'hF0F;
assign p_bram[11] = 12'hF0F;



/*
* 00001 = G
* 00010 = A
* 00011 = M
* 00100 = E
* 00101 = O
* 00110 = V
* 00111 = R
* 01000 = H
* 01001 = P
*/
always_comb begin
	case(letter_in)
		5'b00001:begin
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
		5'b00010:begin
			relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = a_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
		end
		5'b00011:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 18*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 17 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = m_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b00100:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = e_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b00101:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = o_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b00110:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = v_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b00111:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = r_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b01000:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = h_bram[modified_y][modified_x];
                                //in_sprite_buffer = pixel_bram[3][0];
                        end
                        else
                                in_sprite_buffer = 0;
                end
		5'b01001:begin
                        relative_x <= hcount_in - X_POS;
                        relative_y <= vcount_in - Y_POS;
                        if(relative_x >= 0 && relative_x <= 12*(2**scale_in)-1 && relative_y >= 0 && relative_y <= 12*(2**scale_in)-1)begin
                                modified_x = 11 - (relative_x >> scale_in);
                                modified_y = relative_y >> scale_in;
                                in_sprite_buffer = p_bram[modified_y][modified_x];
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
