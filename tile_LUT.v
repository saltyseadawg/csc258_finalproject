module tile_LUT(in, x, y, colour, load_random);
	input [1:0] in;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	input load_random;
	 
	always @(*)
		if (load_random) begin
		case(in):
			2'b00: begin
				x = 8'd0;
				y = 7'd0;
				colour = 3'b001;
			end
			2'b01: begin
				x = 8'd8;
				y = 7'd0;
				colour = 3'b010;
			end
			2'b10: begin
				x = 8'd0;
				y = 7'd8;
				colour = 3'b011;
			end
			2'b11: begin
				x = 8'd8;
				y = 7'd8;
				colour = 3'b100;
			end
			default: begin
				x = 8'd0;
				y = 7'd0;
				colour = 3'b000;
			end
		endcase
		end
			
endmodule 