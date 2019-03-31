//LUT for tile coordinate and colour values

module tile_LUT(x, y, colour, tile);
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [7:0] y;
	input [1:0] tile;


	always @(*) begin
			// case({seq[counter * 2], seq[counter * 2 + 1]})
			case(tile)
			2'b00: begin
				x = 8'd0;
				y = 8'd0;
				colour = 3'b001;
			end
			2'b01: begin
				x = 8'd8;
				y = 8'd0;
				colour = 3'b010;
			end
			2'b10: begin
				x = 8'd0;
				y = 8'd8;
				colour = 3'b011;
			end
			2'b11: begin
				x = 8'd8;
				y = 8'd8;
				colour = 3'b100;
			end
			default: begin
				x = 8'd0;
				y = 8'd0;
				colour = 3'b000;
			end
		endcase
		end
endmodule
