module tile_LUT(in, x, y, colour);
	input [1:0];
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [6:0] y;
	 
	always @(*)
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
				colour = 3'b100;
			end
			2'b11: begin
				x = 8'd8;
				y = 7'd8;
				colour = 3'b011;
			end
			default: begin
				x = 8'd0;
				y = 7'd0;
				colour = 3'b000;
			end
			
endmodule 