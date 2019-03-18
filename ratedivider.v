//ratedivider for the 50_Mhz clock, divides for 1 second

module ratedivider(clk, pulse, load);
	input load;
	input clk;
	output pulse;	
	reg [28:0] counter;
	
	always @(posedge clk, negedge load)
		begin
			if (~load)
				counter = 50000000;
			else
				begin
				counter <= counter - 1;
				if (counter == 0)
					begin 
						counter <= 50000000;
					end
				end
		end
	

	assign pulse = (counter == 0) ? 1 : 0;
	
endmodule