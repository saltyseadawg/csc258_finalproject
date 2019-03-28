module delay_counter(delayEN, ld_delay, clk, delay_done);
	input clk;
	input delayEN, ld_delay;
	reg [28:0] delay_count;
	output reg delay_done;
	
	always @(posedge clk) begin
		if (ld_delay) begin
			delay_count <= 50000000;
			delay_done <= 0;
		end
		if (delayEN) begin
			if (delay_count == 0) begin
				delay_done <= 1;
			end 
			else 
				delay_count <= delay_count - 1;
		end
	end
endmodule 