//data path for graphics
//TODO: figure out which coordinates to write to -lab moniter is 1680 x 1050 (currently default to (0,0) for testing purposes)
//TODO: timing issues - make datapath use a faster clock than control so that all pixels properly written?

module graphics_datapath(clock, x_out, y_out, load, enable, resetn, x_in, y_in, flash, colour_in, colour_out);

	input clock, load, enable, resetn, flash;
	input [7:0] x_in; 
	input [7:0] y_in;
	input [2:0] colour_in;
	
	output [7:0] x_out;
	output [7:0] y_out;
	output [2:0] colour_out;
	
	reg [7:0] x;
	reg [7:0] y;
	reg [2:0] colour;
	
	//counter for implementing coordinates of pixels
	reg [5:0] counter;
	
	
	always @(posedge clock) begin
		if (!resetn) begin
			x <= 8'b0;
			y <= 8'b0;
			colour <= 3'b000;
		end
		if (load) begin
			x <= x_in;
			y <= y_in;
			colour <= colour_in;
		end
		if (flash) begin
				colour <= 3'b111;
		end
	end
	
	
	always @(posedge clock) begin
		if(!resetn)
			counter <= 6'b000000;
		else if (enable)
			if (load) begin
				counter <= 6'b000000;
			end
			else begin
				counter <= counter + 1'b1;
			end
	end
			
	
	assign x_out = x + counter[5:3];
	assign y_out = y + counter[2:0];
	assign colour_out = colour;
	
endmodule
