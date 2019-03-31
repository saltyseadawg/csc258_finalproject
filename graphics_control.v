//control unit for graphics

module graphics_control(
	clock, resetn,
	load, ld_tile, ld_flash, writeEnable,
	randomEnable, counterEnable, tile_num,
	easy, normal, hard, difficulty,
	delayEN, ld_delay, delay_done,
	ld_previous, load_level,
	checkEN, check,
	player_input, player_start, playerEN,
	seq, sequence_counter,
	ld_current_score, ld_best_score
	);

	input clock;
	input resetn;
	input load, load_level;
	input easy, normal, hard; //keys to indicate levels
	input delay_done;
	input player_input, player_start;
	input check;
	input [17:0] seq;

	output reg ld_current_score, ld_best_score;
	output reg ld_tile, ld_flash, ld_previous; //datapath signals
	output reg writeEnable;
	output reg randomEnable;
	output reg counterEnable; //paint counter
	output reg [1:0] tile_num;
	output reg delayEN, ld_delay; //delay_counter signals
	output reg checkEN, playerEN;//player signals

	reg [6:0] write_counter; //keeps track of number of pixels drawn
	reg levelEN; //enable level pick
	reg seqEN, reset_seqEN; //trigger sequence counter
	reg reset_write_counter;
	reg [5:0] curr_state, next_state;
	//output reg [9:0] difficulty;
	output reg [4:0] difficulty;
	output reg [3:0] sequence_counter; //

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
				load_tile 			= 5'd11,	//load tile sequence
				transition 				= 5'd12,
				flash			= 5'd13,	//load tile flash colour
				draw					 	= 5'd14,
				flash_delay = 5'd15,
				load_previous = 5'd16, //load previous tile to be drawn
				draw_previous = 5'd17,
				draw_previous_delay = 5'd18,
				sequence_increase = 5'd19,
				transition_player = 5'd20,
				player = 5'd21, //player turn
				player_check_load = 5'd22,
				player_check = 5'd23, //check player input
				load_correct = 5'd24, //load correctly guessed tile
				flash_correct = 5'd25,
				draw_correct = 5'd26,
				flash_correct_delay = 5'd27,
				load_previous_correct = 5'd28,
				draw_previous_correct = 5'd29,
				draw_previous_correct_delay = 5'd30,
				sequence_increase_player = 5'd31;


	// State Table
	always @(*) begin
		case (curr_state)
			bootup: next_state = load ? load_t0 : bootup;
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
			level_select: next_state = load_level ? generate_sequence : level_select;
			generate_sequence: next_state = load_tile;
			load_tile: begin
				if (sequence_counter < difficulty)
					next_state = transition;
				else
					next_state = transition_player;
			end
			transition: next_state = flash; //buffer for load time
			flash: next_state = draw;
			draw: begin
				if (write_counter < 63)
					next_state = draw;
				else
					next_state = flash_delay;
			end
			flash_delay: begin
				if (delay_done == 1)
					next_state = load_previous;
				else
					next_state = flash_delay;
			end
			load_previous: next_state = draw_previous;
			draw_previous: begin
				if (write_counter < 63)
					next_state = draw_previous;
				else
					next_state = draw_previous_delay;
			end
			draw_previous_delay: begin
				if (delay_done == 1)
					next_state = sequence_increase;
				else
					next_state = draw_previous_delay;
			end
			sequence_increase: next_state = load_tile;
			transition_player: next_state = player_start ? player : transition_player;
			player: begin
				if (sequence_counter >= difficulty)
					next_state = level_select;
				else if (player_input == 1) //check if player pressed a button
					next_state = player_check_load;
				else
					next_state = player;
			end
			player_check_load: next_state = player_check;
			player_check: begin
				if (check == 1) //correct input
					next_state = load_correct;
				else //wrong input
					next_state = level_select;
			end
			load_correct: begin
				next_state = flash_correct;
			end
			flash_correct: begin
				next_state = draw_correct;
			end
			draw_correct: begin
				if (write_counter < 63)
					next_state = draw_correct;
				else
					next_state = flash_correct_delay;
			end
			flash_correct_delay: begin
				if (delay_done == 1)
					next_state = load_previous_correct;
				else
					next_state = flash_correct_delay;
			end
			load_previous_correct: begin
				next_state = draw_previous_correct;
			end
			draw_previous_correct: begin
				if (write_counter < 63)
					next_state = draw_previous_correct;
				else
					next_state = draw_previous_correct_delay;
			end
			draw_previous_correct_delay: begin
				if (delay_done == 1)
					next_state = sequence_increase_player;
				else
					next_state = draw_previous_correct_delay;
			end
			sequence_increase_player: next_state = player;
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
		reset_seqEN = 1'b0;
		reset_write_counter = 1'b0;
		delayEN = 1'b0;
		ld_delay = 1'b0;
		ld_previous = 1'b0;
		playerEN = 1'b0;
		checkEN = 1'b0;
		ld_best_score = 1'b0;
		ld_current_score = 1'b0;

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
				reset_write_counter = 1'b1;
				tile_num = {seq[sequence_counter * 2], seq[sequence_counter * 2 + 1]};
			end
			transition: begin
			end
			flash: begin
				ld_flash = 1'b1;
				reset_write_counter = 1'b1;
			end
			flash_delay: begin
				delayEN = 1'b1;
			end
			draw: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
				ld_delay = 1'b1;
			end
			load_previous: begin
				ld_previous = 1'b1;
				reset_write_counter = 1'b1;
			end
			draw_previous: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
				ld_delay = 1'b1;
			end
			sequence_increase: begin
				seqEN = 1'b1;
			end
			draw_correct: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
				ld_delay = 1'b1;
			end
			load_correct: begin
				reset_write_counter = 1'b1;
				tile_num = {seq[sequence_counter * 2], seq[sequence_counter * 2 + 1]};
				ld_tile = 1'b1;
			end
			flash_correct: begin
				ld_flash = 1'b1;
				reset_write_counter = 1'b1;
			end
			flash_correct_delay: begin
				delayEN = 1'b1;
			end
			draw_previous_delay: begin
				delayEN = 1'b1;
			end
			load_previous_correct: begin
				ld_previous = 1'b1;
				reset_write_counter = 1'b1;
			end
			draw_previous_correct: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;
				ld_delay = 1'b1;
			end
			draw_previous_correct_delay: begin
			 	delayEN = 1'b1;
			end
			transition_player: begin
				reset_seqEN = 1'b1;
			end
			player: begin
				playerEN = 1'b1;
				ld_current_score = 1'b1;
				ld_best_score = 1'b1;
			end
			player_check_load: begin
				checkEN = 1'b1;
			end
			player_check: begin
			end
			sequence_increase_player: begin
				seqEN = 1'b1;
			end
	//------BOOTUP LOADS AND DRAWS------//
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
		if (!resetn) begin
			write_counter <= 0;
		end
		if (reset_write_counter) begin
			write_counter <= 0;
		end
		if (writeEnable) begin
			write_counter <= write_counter + 1;
		end
	end

	always @(posedge clock) begin
			if (!resetn)
				sequence_counter <= 0;
			if (reset_seqEN)
				sequence_counter <= 0;
			if (seqEN)
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
