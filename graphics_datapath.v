//data path for graphics
//figure out how to write to larger part of screen - lab moniter is 1680 x 1050

module graphics_datapath(clock, ,x_out, y_out, load, enable, resetn);

	input clock, load, enable, resetn;
	
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour_out;
	
	reg [7:0] x;
	reg [6:0] y;
	
	//counter for implementing coordinates of pixels
	reg [5:0] counter;
	
	always @(posedge clock) begin
		if (!resetn) begin
			x <= 8'b0;
			y <= 7'b0;
			colour <= 3'b0;
		end
		else begin
			if (load_t0)
				x <= 8'd0;
				y <= 7'd0;
				colour <= 3'b001;
			if (load_t1)
				x <= 8'd8;
				y <= 7'd0;
				colour <= 3'b010;
			if (load_t2)
				x <= 8'd0;
				y <= 7'd8;
				colour <= 3'b100;
			if (load_t3)
				x <= 8'd8;
				y <= 7'd8;
				colour <= 3'b011;
			if (flash)
				colour <= 3'b111;
		end
	end
	
	
	always @(posedge clock) begin
		if(!resetn)
			counter <= 6'b000000;
		else if (enable) begin
				if (load)
					counter <= 6'b000000;
				else
					counter <= counter + 1'b1;
			end
	end
	
	assign x_out = x_in[5:0] + counter[5:3];
	assign y_out = y_in[5:0] + counter[2:0];
	
endmodule