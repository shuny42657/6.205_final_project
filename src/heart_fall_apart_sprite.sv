module heart_fall_apart_sprite (
  input wire [10:0] x_in,hcount_in,
  input wire [9:0] y_in,vcount_in,
  input wire mirror_in,

  output logic in_sprite);

logic[2:0] part_bram[3:0];
logic[10:0] relative_x;
logic[9:0] relative_y;
logic[10:0] modified_x;
logic[9:0] modified_y;
logic in_sprite_buffer;

assign part_bram[0] = 3'b100;
assign part_bram[1] = 3'b110;
assign part_bram[2] = 3'b011;
assign part_bram[3] = 3'b001;

always_comb begin
	relative_x = hcount_in - x_in;
	relative_y = vcount_in - y_in;
	if(relative_x >= 0 && relative_x <= 7 && relative_y >= 0 && relative_y <= 11)begin
		modified_x = relative_x >> 2;
		modified_y = relative_y >> 2;
		if(mirror_in)begin
			in_sprite_buffer = part_bram[modified_y][modified_x];
		end else begin
			in_sprite_buffer = part_bram[modified_y][2-modified_x];
		end
	        //in_sprite_buffer = part_bram[relative_y][relative_x];
	end
	else
		in_sprite_buffer = 0;
	
end

assign in_sprite = in_sprite_buffer;

endmodule

