module button_sprite #(X_POS = 240,Y_POS = 240)(
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  input wire selected_in,
  output logic [11:0] pixel_out
);
localparam WIDTH = 154;
localparam HEIGHT = 52;
localparam DESELECTED_COLOR = 12'hF50;
localparam SELECTED_COLOR = 12'hFF0;
  logic in_sprite_buffer;
  always_comb begin
          /*if(~is_fixed)begin
                  in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in + HEIGHT)));
          end else begin
                  in_sprite_buffer = ((hcount_in >= X_FIXED && hcount_in < (X_FIXED + WIDTH)) && (vcount_in >= Y_FIXED && vcount_in < (Y_FIXED + HEIGHT)));
          end*/

	  in_sprite_buffer = ((hcount_in >= X_POS && hcount_in < (X_POS + WIDTH)) && (vcount_in >= Y_POS && vcount_in < (Y_POS + HEIGHT)));
	  if(in_sprite_buffer)begin
		  if(selected_in)
			  pixel_out = SELECTED_COLOR;
		  else
			  pixel_out = DESELECTED_COLOR;
	  end
	  else begin
		  pixel_out = 0;
	  end
  end


  //assign pixel_out = in_sprite_buffer ? COLOR : 0;
  //assign in_sprite = in_sprite_buffer;
endmodule

