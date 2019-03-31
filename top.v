
module top
(
		PS2_CLK,
		PS2_DAT,
		HEX0,
		HEX3,
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
        KEY,
        SW,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input			CLOCK_50;				//	50 MHz
	input   [9:0]   SW;
	input   [3:0]   KEY;
	inout PS2_CLK, PS2_DAT;

	output [6:0] HEX0, HEX3;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]


	vga_adapter VGA(
			.resetn(SW[9]),
			.clock(CLOCK_50),
			.colour(colour),
			.x(vga_x),
			.y(vga_y),
			.plot(writeEN),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";
//-------------------VGA end---------------------------------//
	wire [7:0] lut_x;
	wire [7:0] lut_y;
	wire [7:0] vga_x;
	wire [7:0] vga_y;
	wire [2:0] colour;
	wire [2:0] lut_colour;
	wire writeEN;
	wire randomEN;
	wire counter_wire;
	wire [1:0] tile;
	wire flash;
	wire load_tile;
	wire ld_previous_wire;
	wire [1:0] start_tiles;
	wire [1:0] random_in;
	wire [4:0] difficulty;

	wire [17:0] seq_wire;
	wire [3:0] seq_counter_wire;

	wire delay_done_wire, delayEN_wire, ld_delay_wire; //delay_counter wires

	wire playerEN_wire, checkEN_wire, check_wire, player_input_wire; //player wires
	wire [1:0] tile_wire;
	wire load_current_score_wire, load_best_score_wire;

	tile_LUT t0(
		.x(lut_x), //output to
		.y(lut_y), //output to
		.colour(lut_colour), //output to
		.tile(tile_wire)
		);

	graphics_datapath data(
		.clock(CLOCK_50),
		.x_out(vga_x),
		.y_out(vga_y),
		.load(load_tile),
		.enable(counter_wire),
		.resetn(SW[9]),
		.x_in(lut_x),
		.y_in(lut_y),
		.flash(flash),
		.colour_out(colour),
		.colour_in(lut_colour),
		.ld_previous(ld_previous_wire)
		);

	graphics_control control(
		.clock(CLOCK_50),
		.resetn(SW[9]),
		.load(SW[0]),
		.load_level(SW[1]),
		.ld_tile(load_tile),
		.ld_flash(flash),
		.ld_previous(ld_previous_wire),
		.writeEnable(writeEN),
		.randomEnable(randomEN),
		.counterEnable(counter_wire),
		.tile_num(tile_wire),
		.easy(KEY[1]),
		.normal(KEY[2]),
		.hard(KEY[3]),
		.player_start(SW[2]),
		.sequence_counter(seq_counter_wire),
		.difficulty(difficulty),
		.delayEN(delayEN_wire),
		.ld_delay(ld_delay_wire),
		.delay_done(delay_done_wire),
		.checkEN(checkEN_wire),
		.player_input(player_input_wire),
		.playerEN(playerEN_wire),
		.check(check_wire),
		.seq(seq_wire),
		.ld_best_score(load_best_score_wire),
		.ld_current_score(load_current_score_wire)
		);

	random_generator random_gen(
		.clock(CLOCK_50),
		.randEN(randomEN),
		.difficulty(difficulty),
		.seq(seq_wire)
		);

	delay_counter dc(
		.clk(CLOCK_50),
		.delayEN(delayEN_wire),
		.ld_delay(ld_delay_wire),
		.delay_done(delay_done_wire)
		);

	player p0(
		.seq(seq_wire),
		.seq_counter(seq_counter_wire),
		.check(check_wire),
		.playerEN(playerEN_wire),
		.checkEN(checkEN_wire),
		.q(q_wire),
		.w(w_wire),
		.a(a_wire),
		.s(s_wire),
		.clk(CLOCK_50),
		.player_input(player_input_wire)
		);

	highscore h0(
		.clk(CLOCK_50),
		.sequence_counter(seq_counter_wire),
		.HEX_best(HEX3),
		.HEX_current(HEX0),
		.load_current(load_current_score_wire),
		.load_best(load_best_score_wire)
		);

	wire q_wire, w_wire, a_wire, s_wire;

	keyboard_tracker #(.PULSE_OR_HOLD(0)) keyboard_player(
		.clock(CLOCK_50),
		.reset(SW[9]),
		.PS2_CLK(PS2_CLK),
		.PS2_DAT(PS2_DAT),
		.w(w_wire),
		.a(a_wire),
		.s(s_wire),
		.q(q_wire)
		);
endmodule
