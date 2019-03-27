
module top
(
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
	wire counter;
	wire [1:0] tile;
	wire flash;
	wire load_tile;
	wire [1:0] start_tiles;
	wire [1:0] random_in;
	wire [8:0] difficulty;
	
	reg [17:0] random_seq;
	reg [5:0] seq_counter;
	
	wire [17:0] seq_wire;
	wire [5:0] seq_counter_wire;
//	wire second;
	
	tile_LUT t0(
		.seq(seq_wire),
		.counter(seq_counter_wire),
		.x(lut_x), //output to 
		.y(lut_y), //output to 
		.colour(lut_colour), //output to
		.load_random(randomEN),
		.boot(start_tiles)
		);

	graphics_datapath data(
		.clock(CLOCK_50),
		.x_out(vga_x),
		.y_out(vga_y),
		.load(load_tile),
		.enable(counter),
		.resetn(SW[9]),
		.x_in(lut_x),
		.y_in(lut_y),
		.flash(flash),
		.colour_out(colour),
		.colour_in(lut_colour)
		);
		
	graphics_control control(
		.clock(CLOCK_50),
		.resetn(SW[9]),
		.load(KEY[0]),
		.ld_tile(load_tile),
		.ld_flash(flash),
		.writeEnable(writeEN),
		.randomEnable(randomEN),
		.counterEnable(counter),
		.tile_num(start_tiles),
		.easy(KEY[1]),
		.normal(KEY[2]),
		.hard(KEY[3]),
		.sequence_counter(seq_counter_wire),
		.difficulty(difficulty)
		);
		
	random_generator random_gen(
		.clock(CLOCK_50),
		.randEN(randomEN),
		.difficulty(difficulty),
		.seq(seq_wire)
		);
//		
//	ratedivider rate(
//		.clk(CLOCK_50),
//		.pulse(second),
//		.load(SW[9])
//		);

endmodule
