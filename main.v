// code adapted from the following source:
// https://www.instructables.com/id/Make-your-own-Simon-Says-Game/

// top level module

// USAGE:
// reset = SW[9]

// 00 = static, 01 = game, 10 = user, 11 = static
// state = SW[1:0]

// set 5 difficulty levels
// level = SW[4:2]

// user color Selection
// color = KEY[3:0]

module main(
        reset,
        level,
        state,
        color,
        CLOCK_50,
        VGA_CLK,   						//	VGA Clock
    		VGA_HS,							//	VGA H_SYNC
    		VGA_VS,							//	VGA V_SYNC
    		VGA_BLANK_N,						//	VGA BLANK
    		VGA_SYNC_N,						//	VGA SYNC
    		VGA_R,   						//	VGA Red[9:0]
    		VGA_G,	 						//	VGA Green[9:0]
    		VGA_B,   						//	VGA Blue[9:0]
        state_out,
        level_out,
        level_n
);

  // VGA outputs
  output VGA_HS, VGA_VS;
  output reg [7:0] VGA_R, VGA_G, VGA_B;
  output VGA_SYNC_N;
  output VGA_BLANK_N;
  output VGA_CLK;

  // game metadata output
  output reg [0:6] state_out;
  output wire [0:6] level_out;
  output reg [0:6] level_n;

  // inputs
  input	CLOCK_50;	//	50 MHz
  input [9:0] SW;
  input [3:0] KEY;

  // assignments
  assign reset = SW[9];
	assign level[3:0] = SW[4:2];
	assign state[1:0] = SW[1:0];
	assign color[3:0] = KEY[3:0];

  // grid wires
	wire [7:0] grid_VGA_R, grid_VGA_G, grid_VGA_B;
	reg [9:0] pixel_x;
	reg [8:0] pixel_y;
	wire img_on;

//------Initialize VGA (modified code from Brandon Hill)------//
	reg VGA_HS, VGA_VS;

	wire xmax = (pixel_x==799); //799 full width of field including front and back porches and sync
	wire ymax = (pixel_y==525); //525 full length of field including front and back porches and sync

  vga_adapter VGA(
			.resetn(reset),
			.clock(CLOCK_50),
			.color(color),
			.x(pixel_x),
			.y(pixel_y),
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
		defparam VGA.BITS_PER_color_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

//-----Synchronize VGA Output-----//
	assign VGA_CLK = CLOCK_50;
	assign VGA_BLANK_N = VGA_VS & VGA_HS;
	assign VGA_SYNC_N = 1;

	always @(posedge CLOCK_50)
		if(xmax && ~ymax)
			begin
			pixel_x <= 0;
			pixel_y <= pixel_y + 1;
			end
		else if (~xmax)
			pixel_x <= pixel_x + 1;
		else if (xmax && ymax)
			begin
			pixel_y <= 0;
			pixel_x <= 0;
			end
//
	always @(posedge CLOCK_50)
		begin
			VGA_HS <= (pixel_x <= 96);   // active for 16 clocks
			VGA_VS <= (pixel_y <= 2);   // active for 800 clocks
		end

	assign VGA_HS = ~VGA_HS;
	assign VGA_VS = ~VGA_VS;
//----- end synchronization -----//

//-----------Instantiate Modules-----------//
	display_grid g0 (.level(level), .color(color), .state(state),
										.pix_x(pixel_x), .pix_y(pixel_y),
											.VGA_R(grid_VGA_R), .VGA_G(grid_VGA_G), .VGA_B(grid_VGA_B),
                      .video_on(img_on));

	always @(posedge CLOCK_50)
		if(img_on)
		begin
			VGA_R = grid_VGA_R;
			VGA_G = grid_VGA_G;
			VGA_B = grid_VGA_B;
		end


//----- set game state and difficulty level -----//

	assign level_out = 7'b1110001; // L
	always@*
		begin
		case (state_out)
		2'b00: state_out = 7'b1111010; //ready
		2'b01: state_out = 7'b0000100; //game
		2'b10: state_out = 7'b1100011; //user
		default: state_out = 7'b1111111; //off
		endcase

		case (level)
		3'b001: level_n = 7'b1001111; // one
		3'b010: level_n = 7'b0010010; // two
		3'b011: level_n = 7'b0000110; // three
		3'b100: level_n = 7'b1001100; // four
		3'b101: level_n = 7'b0100100; // five
		default: level_n = 7'b1111111; // off
		endcase
		end


endmodule
