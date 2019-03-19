//data path for graphics
//is adapter ok for screen size? - lab moniter is 1680 x 1050

module graphics_datapath(clock, x_in, y_in, size, x_out, y_out, load, enable, resetn);

	input clock, load, enable, resetn;
	
	output [7:0] x_out;
	output [6:0] y_out;
	output [2:0] colour_out;
	
	reg [2:0] colour;
	
	//counter for implementing all coordinates of pixels
	reg [5:0] counter;
	
	always @(posedge clock) begin
		if (!resetn) begin
			x <= 8'b0;
			y <= 7'b0;
			colour <= 3'b0;
		end
		else begin
			if (load)
				x <= {1'b0, point};
			if (load_y)
				y <= point;
			if (load_colour)
				colour <= c_in;
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