//LUT for tile coordinate and colour values

module tile_LUT(seq, x, y, colour, load_random, boot, counter, load_correct, correct);
	input [5:0] counter;
	input [17:0] seq;
	output reg [2:0] colour;
	output reg [7:0] x;
	output reg [7:0] y;
	input load_random, load_correct;
	input [1:0] boot, correct;


	always @(*)
		if (load_correct) begin
			case(correct)
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
		else if (load_random) begin
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
					colour = 3'b000;
				end
			endcase
		end
		else begin
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
				colour = 3'b000;
			end
		endcase
		end


endmodule
