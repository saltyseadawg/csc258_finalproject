//control unit for graphics

module graphics_control(clock, resetn, load, ld_tile, ld_flash, ld_previous, drw, writeEnable, randomEnable, counterEnable);
	input clock;
	input resetn;
	input load;
	input drw;

	output reg ld_tile, ld_flash, ld_previous;
	output reg writeEnable;
	output reg randomEnable;
	output reg counterEnable;

	reg [3:0] curr_state, next_state;

	// States
	localparam bootup			= 4'd0,	
				tile_select 	= 4'd1, //wait until user input
				load_tile 			= 4'd2,	//load top left tile 
				transition 				= 4'd3,	
				draw					 	= 4'd4,	
				flash			= 4'd5,	//load tile flash colour
				load_previous = 4'd6,
				draw_previous = 4'd7;

	// State Table
	always @(*) begin
		case (curr_state)
			bootup: next_state = load ? game_start : bootup;
			tile_select: next_state = load ? load_tile : tile_select; 
			load_tile: next_state = load ? transition : load_tile;
			transition: next_state = flash;
			flash: next_state = drw ? draw : flash;
			draw: next_state = load_previous;
			load_previous: next_state = drw ? draw_previous ? load_previous;
			draw_previous: next_state = tile_select;
		endcase
	end

	// Output Logic
	always @(*) begin
		ld_tile = 1'b0;
		ld_flash = 1'b0;
		ld_previous = 1'b0;
		writeEnable = 1'b0;
		randomEnable = 1'b0;
		counterEnable = 1'b0;

		case (curr_state)
			bootup: begin
			end
			tile_select: begin
				randomEnable = 1'b1;
			end
			load_tile: begin
				ld_tile = 1'b1;
			end
			transition: begin
			end
			flash: begin
				ld_flash = 1'b1;
			end
			draw: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
			end
			load_previous: begin
				ld_previous = 1'b1;
			end
			draw_previous: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;		
		endcase
	end

	// Current State Register
	always @(posedge clock) begin
		if (!resetn)
			curr_state <= bootup;
		else
			curr_state <= next_state;
	end
endmodule
