module button_sprite #(X_POS = 240,Y_POS = 240)(
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  input wire [1:0] command_in,
  input wire selected_in,
  output logic [11:0] pixel_out
);
localparam WIDTH = 154;
localparam HEIGHT = 52;
localparam DESELECTED_COLOR = 12'hF50;
localparam SELECTED_COLOR = 12'hFF0;
logic[11:0] green_heart_pixel_out;
logic green_heart_out;
green_heart_sprite #(X_POS + 8,Y_POS + 12,12'h0F0) menu_heart(.hcount_in(hcount_in),.vcount_in(vcount_in),.divided_in(0),.pixel_out(green_heart_pixel_out),.in_sprite(green_heart_out));


  logic in_sprite_buffer;
  always_comb begin
	  in_sprite_buffer = ((hcount_in >= X_POS && hcount_in < (X_POS + WIDTH)) && (vcount_in >= Y_POS && vcount_in < (Y_POS + HEIGHT)));
	  if(in_sprite_buffer)begin
		  if(selected_in)
			  pixel_out = SELECTED_COLOR + green_heart_pixel_out;
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

