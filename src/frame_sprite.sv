module frame_sprite #(
  parameter COLOR=12'hFFF)(
  input wire [10:0] x_in, hcount_in,width_in,
  input wire [9:0]  y_in, vcount_in,height_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);

  logic in_sprite_buffer;
          /*if(~is_fixed)begin
                  in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + width_in)) && (vcount_in >= y_in && vcount_in < (y_in + height_in)));
          end else begin
                  in_sprite_buffer = ((hcount_in >= X_FIXED && hcount_in < (X_FIXED + WIDTH)) && (vcount_in >= Y_FIXED && vcount_in < (Y_FIXED + HEIGHT)));
          end*/
	  //in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + width_in)) && (vcount_in >= y_in && vcount_in < (y_in + height_in)));

  

  assign in_sprite_buffer = (hcount_in >= x_in && hcount_in < (x_in + width_in)) && (vcount_in >= y_in && vcount_in < (y_in + height_in));

  assign pixel_out = in_sprite ? COLOR : 0;
  assign in_sprite = in_sprite_buffer;
endmodule 
