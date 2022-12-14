module arrow_sprite #(parameter TARGET_COLOR = 12'hF00,NONTARGET_COLOR = 12'hFF0,INVERSE_COLOR = 12'hFF0)(
  input wire [10:0] x_in, hcount_in,
  input wire [9:0]  y_in, vcount_in,
  input wire [1:0] rotate_in,
  input wire next_in,
  input wire inversed_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);

  logic[15:0] pixel_bram[31:0];
  logic in_sprite_buffer;
  logic[10:0] relative_x;
  logic[9:0] relative_y;
  logic[11:0] pixel_out_buffer;
  logic[10:0] modified_x;
  logic[9:0] modified_y;
  always_comb begin
	  for(int i = 0;i < 24;i = i + 1)begin
		  pixel_bram[i] = 16'b0000111111110000;
	  end
	  for(int i = 24;i<32;i = i + 1)begin
		  if(i == 24)
			  pixel_bram[i] = 16'hFFFF;
		  else
			  pixel_bram[i] = (16'hFFFF << (i-24)*2) >> (i-24);
	  end
	  if(inversed_in)
		  pixel_out_buffer = INVERSE_COLOR;
	  else
		  pixel_out_buffer = next_in ? TARGET_COLOR : NONTARGET_COLOR;
	 relative_x = hcount_in - x_in;
	 relative_y = vcount_in - y_in;
	 case(rotate_in)
		 2'b00:begin
			 if(relative_x >= 0 && relative_x <= 15 && relative_y >= 0 && relative_y <= 31)begin
                 		in_sprite_buffer = pixel_bram[relative_y][relative_x];
         	 	 end
         	 	 else
                 	 	in_sprite_buffer = 0;
		 end
		 2'b01:begin
			 if(relative_x >= 0 && relative_x <= 15 && relative_y >= 0 && relative_y <= 31)begin
				 modified_y = 31 - relative_y;
				 in_sprite_buffer = pixel_bram[modified_y][relative_x];
			 end
			 else
				 in_sprite_buffer = 0;
		 end
		 2'b11:begin
			 if(relative_x >= 0 && relative_x <= 31 && relative_y >= 0 && relative_y <= 15)begin
				 modified_x = 31 - relative_x;
                                 in_sprite_buffer = pixel_bram[modified_x][relative_y];
                         end
                         else
                                 in_sprite_buffer = 0;
		 end
		 2'b10:begin
			 if(relative_x >= 0 && relative_x <= 31 && relative_y >= 0 && relative_y <= 15)begin
                                 in_sprite_buffer = pixel_bram[relative_x][relative_y];
                         end
                         else
                                 in_sprite_buffer = 0;
		 end
	 endcase
  end


  assign pixel_out = in_sprite ? pixel_out_buffer : 0;
  assign in_sprite = in_sprite_buffer;
endmodule

