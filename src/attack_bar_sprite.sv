module attack_bar_sprite #(
  parameter WIDTH=256, HEIGHT=256)(
  input wire[11:0] color_in,
  input wire [10:0] x_in, hcount_in,
  input wire [9:0]  y_in, vcount_in,
  output logic [11:0] pixel_out,
  output logic in_sprite);

  logic in_sprite_buffer;
  always_comb begin
	  in_sprite_buffer = ((hcount_in >= x_in && hcount_in < (x_in + WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in + HEIGHT)));
  end


  assign pixel_out = in_sprite ? color_in : 0;
  assign in_sprite = in_sprite_buffer;
endmodule

