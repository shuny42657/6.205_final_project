module block_sprite #(
  parameter WIDTH=256, HEIGHT=256,X_FIXED = 128,Y_FIXED = 128, COLOR=12'hFFF)(
  input wire is_fixed;
  input wire [10:0] x_in, hcount_in,
  input wire [9:0]  y_in, vcount_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);

  logic in_sprite_buffer;
  always_comb begin
	  if(~is_fixed)begin
		  in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in + HEIGHT)));
	  end else begin
		  in_sprite_buffer = ((hcount_in >= X_FIXED && hcount_in < (X_FIXED + WIDTH)) && (vcount_in >= Y_FIXED && vcount_in < (Y_FIXED + HEIGHT)));
	  end
  end


  assign pixel_out = in_sprite ? COLOR : 0;
  assign in_sprite = in_sprite_buffer;
endmodule
