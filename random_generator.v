module random_generator(clock, randEN, difficulty, seq);
	input clock;
	input randEN;
	input [4:0] difficulty;
	reg [17:0] counter;
	output reg [17:0] seq;
 	
	//test purposes
	initial begin
		counter = 18'b101100101010101001;
	end
	
	always @(posedge randEN) begin
		seq <= counter;
	end
	
	always @(posedge clock) begin
		counter <= counter + 1;
	end
	
endmodule 
