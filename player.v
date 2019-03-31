module player(seq, check, seq_counter, playerEN, checkEN, KEY, clk, player_input);
	input [3:0] KEY;
	input [17:0] seq;
	input [3:0] seq_counter;
	input playerEN, checkEN;
	input clk;

	output reg player_input;
	output reg check;
	reg [1:0] tile_selected;

	// get player input
	always @(posedge clk) begin
		if (playerEN) begin
			if (~KEY[0]) begin
				player_input <= 1;
				tile_selected <= 0;
			end
			if (~KEY[1]) begin
				player_input <= 1;
				tile_selected <= 1;
			end
			if (~KEY[2]) begin
				player_input <= 1;
				tile_selected <= 2;
			end
			if (~KEY[3]) begin
				player_input <= 1;
				tile_selected	<= 3;
			end
		end
		else begin
			player_input <= 0;
		end
	end

		// check player input
	always @(posedge clk) begin
		if (checkEN) begin
			if (tile_selected == {seq[seq_counter * 2], seq[seq_counter * 2 + 1]})
				check = 1'b1;
			else
				check = 1'b0;
			end
		end
endmodule
