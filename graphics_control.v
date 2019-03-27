//control unit for graphics

module graphics_control(clock, resetn, load, ld_tile, ld_flash, writeEnable, randomEnable, counterEnable, tile_num, easy, normal, hard, sequence_counter, difficulty);
	input clock;
	input resetn;
	input load;
	input easy, normal, hard; //keys to indicate levels

	output reg ld_tile, ld_flash;
	output reg writeEnable; 
	output reg randomEnable;
	output reg counterEnable; //paint counter
	output reg [1:0] tile_num;

	reg [6:0] write_counter;
	reg levelEN, seqEN, reset_write_counter;
	reg [5:0] curr_state, next_state;
	//output reg [9:0] difficulty;
	output reg [4:0] difficulty;
	output reg [5:0] sequence_counter; //

	//ensure difficulty starts with value;
	initial begin
		write_counter = 0;
		sequence_counter = 0;
		difficulty = 3;
	end
	
	// States
	localparam bootup			= 5'd0, 
				load_t0 = 5'd1,
				draw_t0 = 5'd2,
				load_t1 = 5'd3,
				draw_t1 = 5'd4,
				load_t2 = 5'd5,
				draw_t2 = 5'd6,
				load_t3 = 5'd7,
				draw_t3 = 5'd8,
				level_select 	= 5'd9, //choose difficulty
				generate_sequence = 5'd10,
				load_tile 			= 5'd11,	//load top left tile 
				transition 				= 5'd12,	
				flash			= 5'd13,	//load tile flash colour
				draw					 	= 5'd14,	
				load_previous = 5'd15,
				draw_previous = 5'd16;

	// State Table
	always @(*) begin
		case (curr_state)
			bootup: next_state = ~load ? load_t0 : bootup;
			load_t0: next_state = draw_t0;
			draw_t0: begin
				if (write_counter < 63)
					next_state = draw_t0;
				else
					next_state = load_t1;
			end
			load_t1: next_state = draw_t1;
			draw_t1: begin
				if (write_counter < 63)
					next_state = draw_t1;
				else
					next_state = load_t2;
			end
			load_t2: next_state = draw_t2;
			draw_t2: begin
				if (write_counter < 63)
					next_state = draw_t2;
				else
					next_state = load_t3;
			end
			load_t3: next_state = draw_t3;
			draw_t3: begin
				if (write_counter < 63)
					next_state = draw_t3;
				else
					next_state = level_select;
			end
			level_select: next_state = ~load ? generate_sequence : level_select;
			generate_sequence: next_state = load_tile;
			load_tile: begin
				if (sequence_counter < difficulty) 
					next_state = transition;
				else
					next_state = level_select;
			end
			transition: next_state = flash; //buffer for load time
			flash: next_state = draw;
			draw: begin
				if (write_counter < 63)
					next_state = draw;
				else
					next_state = load_previous;
			end
			load_previous: next_state = draw_previous;
			draw_previous: begin
				if (write_counter < 63)
					next_state = draw_previous;
				else
					next_state = load_tile;
			end
		endcase
	end

	// Output Logic
	always @(*) begin
		ld_tile = 1'b0;
		ld_flash = 1'b0;
		writeEnable = 1'b0;
		randomEnable = 1'b0;
		counterEnable = 1'b0;
		tile_num = 2'b00;
		levelEN = 1'b0;
		seqEN = 1'b0;
		reset_write_counter = 1'b0;
		
		case (curr_state)
			bootup: begin
			end
			level_select: begin
				levelEN = 1;
			end
			generate_sequence: begin
				randomEnable = 1;
			end
			load_tile: begin
				ld_tile = 1'b1;
				randomEnable = 1;
				reset_write_counter = 1'b1;
			end
			transition: begin
			end
			flash: begin
				ld_flash = 1'b1;
				reset_write_counter = 1'b1;
			end
			draw: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
			end
			load_previous: begin
				ld_tile = 1'b1;
				reset_write_counter = 1'b1;
			end
			draw_previous: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
				seqEN = 1'b1;
			end
			load_t0: begin
				tile_num = 2'b00;
				ld_tile = 1;
				reset_write_counter = 1'b1;
			end
			load_t1: begin
				tile_num = 2'b01;
				ld_tile = 1;
				reset_write_counter = 1'b1;
			end
			load_t2: begin
				tile_num = 2'b10;
				ld_tile = 1;
				reset_write_counter = 1'b1;
			end
			load_t3: begin
				tile_num = 2'b11;
				ld_tile = 1;
				reset_write_counter = 1'b1;
			end
			draw_t0: begin
				writeEnable = 1;
				counterEnable = 1;
			end
			draw_t1: begin
				writeEnable = 1;
				counterEnable = 1;
			end
			draw_t2: begin
				writeEnable = 1;
				counterEnable =1 ;
			end
			draw_t3: begin
				writeEnable = 1;
				counterEnable = 1;
			end
		endcase
	end

	//select difficulty
	always @(posedge clock) begin
		if (levelEN) begin
			if (~easy)
					difficulty = 3;
			if (~normal)
					difficulty = 6;
			if (~hard)
					difficulty = 9;
		end
			
	end
	
	//TODO: fix transition from draw to load so that colour doesn't change before coordinates change
	always @(posedge clock) begin
		if (writeEnable) begin
			if ( write_counter >= 63) begin
				write_counter <= 0;
			end
			else
				write_counter <= write_counter + 1;
		if (!resetn) begin
			write_counter <= 0;
		end
		if (reset_write_counter)
			write_counter <= 0;
		end
	end
	
	//TODO: figure out how to reset sequence_counter w/o multiple constant driver error
	always @(posedge seqEN) begin
			sequence_counter <= sequence_counter + 1;
	end
	
	
	// Current State Register
	always @(posedge clock) begin
		if (!resetn) begin
			curr_state <= bootup;
			end
		else
			curr_state <= next_state;
	end
endmodule
