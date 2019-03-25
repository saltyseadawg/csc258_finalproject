//LUT for tile coordinate and colour values

module tile_LUT(seq, x, y, colour, load_random, boot, counter);
	input [5:0] counter;
	input [17:0] seq;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [7:0] y;
	input load_random;
	input [1:0] boot;
	
	//reg [1:0] seq_tile;
	 
	always @(*)
		if (load_random)
		case({seq[counter * 2], seq[counter * 2 + 1]})
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
				colour = 3'b111;
			end
		endcase
		else
			case(boot)
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
				colour = 3'b111;
			end
		endcase
			
			
endmodule 