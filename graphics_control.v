//control unit for graphics

module graphics_control(clock, resetn, tile, load_t, drw, writeEnable, enable, ld_t0, ld_t1, ld_t2, ld_t3, flash);
	input clock;
	input resetn;
	input load_t;
	input drw;
	input player_in;

	output reg ld_t0, ld_t1, ld_t2, ld_t3, ld_flash;
	output reg writeEnable;
	output reg randomEnable;

	reg [3:0] curr_state, next_state;

	// States
	localparam bootup			= 4'd0	
				tile_select 	= 4'd1, //wait until user input
				load_t0 			= 4'd2,	//load top left tile 
				load_t1 			= 4'd3,	//load load top right tile
				load_t2 			= 4'd4, // load bottom left tile
				load_t3 			= 4'd5, // load bottom right tile
				transition 				= 4'd6,	
				draw					 	= 4'd7,	
				flash			= 4'd8;	//load tile flash colour

	// State Table
	always @(*) begin
		case (curr_state)
			bootup: next_state = load ? game_start : bootup;
			tile_select: begin
				if (tile == 1)
					next_state = load_t0;
				else if (tile == 2)
					next_state = load_t1;
				else if (tile == 3)
					next_state = load_t2;
				else if (tile == 4)
					next_state = load_t3;
				else
					next_state = tile_select;
			end
			load_t0: next_state = load ? transition : load_t0;
			load_t1: next_state = load ? transition : load_t1;
			load_t2: next_state = load ? transition : load_t2;
			load_t3: next_state = load ? transition : load_t3;
			transition: next_state = flash;
			flash: next_state = drw ? draw : flash;
			draw: next_state = tile_select;

			load_colour_and_y: next_state = load ? load_colour_and_y_wait : load_colour_and_y;
			load_colour_and_y_wait: next_state = load ? load_colour_and_y_wait : transition;

			transition: next_state = drw ? draw : transition; //introduced this state to use KEY[0]
			draw: next_state = tile_select;
		endcase
	end

	// Output Logic
	always @(*) begin
		ld_t0 = 1'b0;
		ld_t1 = 1'b0;
		ld_t2 = 1'b0;
		ld_t3 = 1'b0;
		ld_flash = 1'b0;
		writeEnable = 1'b0;
		randomEnable = 1'b0;
		counterEnable = 1'b0;

		case (curr_state)
			bootup: begin
			end
			tile_select: begin
				randomEnable = 1;
			end
			load_t0: begin
				ld_t0 = 1;
			end
			load_t1: begin
				ld_t1 = 1;
			end
			load_t2: begin
				ld_t2 = 1;
			end
			load_t3: begin
				ld_t3 = 1;
			end
			transition: begin
			end
			flash: begin
				ld_flash = 1;
			end
			draw: begin
				writeEnable = 1;
				enable = 1;
			end
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
