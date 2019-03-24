module random_generator(clock, randEN, difficulty, sequence);
	input clock;
	input randEN;
	input [8:0] difficulty;
	reg [17:0] counter;
	output reg [17:0] sequence;
 	
	//test purposes
	initial begin
		counter = 18'b101100101010101001;
	end
	
	always @(posedge randEN) begin
		sequence <= counter;
	end
	
	always @(posedge clock) begin
		counter <= counter + 1;
	end
	
endmodule 
