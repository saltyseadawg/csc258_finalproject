// code adapted from the following source:
// https://www.instructables.com/id/Make-your-own-Simon-Says-Game/

// supporting module coordinating grid

module display_grid (color, level, state, pix_x, pix_y, vga_R, vga_G, vga_B, video_on);

	input [1:0] state;
	input [3:0] color;
	input [2:0] level;
	input [9:0] pix_x, pix_y;
	output reg [7:0] vga_R, vga_G, vga_B;
	output reg video_on;

	//constant declaration
	localparam Max_X = 788;
	localparam Max_Y = 490;

	//Square Buttons
	localparam button_spacing = 25;
	localparam button_size = 50;
	localparam RED_X_L = 315;
	localparam RED_X_R = RED_X_L + button_size;
	localparam RED_Y_T = 250;
	localparam RED_Y_B = RED_Y_T + button_size;
	localparam YEL_X_L = RED_X_R + button_spacing;
	localparam YEL_X_R = YEL_X_L + button_size;
	localparam YEL_Y_T = 250;
	localparam YEL_Y_B = YEL_Y_T + button_size;
	localparam GRN_X_L = YEL_X_R + button_spacing;
	localparam GRN_X_R = GRN_X_L + button_size;
	localparam GRN_Y_T = 250;
	localparam GRN_Y_B = GRN_Y_T + button_size;
	localparam BLU_X_L = GRN_X_R + button_spacing;
	localparam BLU_X_R = BLU_X_L + button_size;
	localparam BLU_Y_T = 250;
	localparam BLU_Y_B = BLU_Y_T + button_size;

	//status signals
	wire redB_on, yelB_on, grnB_on, bluB_on, bounding_box;
	reg bright;

	//pixel in red button
	assign redB_on = ((RED_X_L <= pix_x) && (pix_x <= RED_X_R) &&
							(RED_Y_T <= pix_y) && (pix_y <= RED_Y_B));

	//pixel in yellow button
	assign yelB_on = ((YEL_X_L <= pix_x) && (pix_x <= YEL_X_R) &&
							(YEL_Y_T <= pix_y) && (pix_y <= YEL_Y_B));

	//pixel in green button
	assign grnB_on = ((GRN_X_L <= pix_x) && (pix_x <= GRN_X_R) &&
							(GRN_Y_T <= pix_y) && (pix_y <= GRN_Y_B));

	//pixel in blue button
	assign bluB_on = ((BLU_X_L <= pix_x) && (pix_x <= BLU_X_R) &&
							(BLU_Y_T <= pix_y) && (pix_y <= BLU_Y_B));


	//pixel is in bounding box
	assign bounding_box = (pix_x == 250 && pix_y <= 450 && 100 <= pix_y) |
									(pix_x == 650 && pix_y <= 450 && 100 <= pix_y) |
										(pix_y == 100 && pix_x <= 650 && 250 <= pix_x) |
											(pix_y == 450 && pix_x <= 650 && 250 <= pix_x);


//-------------Display the Letter L for level--------------//
wire [2:0] L_addr, L_col;
reg [7:0] L_data;
wire L_bit;
wire L_on;

always@*
		case (L_addr)
		3'b000: L_data = 8'b00000000; //
		3'b001: L_data = 8'b01000000; // *
		3'b010: L_data = 8'b01000000; // *
		3'b011: L_data = 8'b01000000; // *
		3'b100: L_data = 8'b01000000; // *
		3'b101: L_data = 8'b01000000; // *
		3'b110: L_data = 8'b01111111; // *******
		3'b111: L_data = 8'b00000000; //
		endcase
//-------------------------------------//

	assign L_addr = pix_y[3:1];
	assign L_col = pix_x[3:1];
	assign L_bit = L_data[~L_col];

	assign L_on = (256<=pix_x && pix_x<=271 && 112<= pix_y && pix_y <= 127 && L_bit);

//-------------Display the Letter S to indicate that Simon Says--------------//
wire [2:0] S_addr, S_col;
reg [7:0] S_data;
wire S_bit;
wire S_on;

always@*
		case (S_addr)
		3'b000: S_data = 8'b00000000; //
		3'b001: S_data = 8'b00111110; //  *****
		3'b010: S_data = 8'b01000000; // *
		3'b011: S_data = 8'b00111110; //  *****
		3'b100: S_data = 8'b00000001; //       *
		3'b101: S_data = 8'b01000001; // *     *
		3'b110: S_data = 8'b00111110; //  *****
		3'b111: S_data = 8'b00000000; //
		endcase
//-------------------------------------//

	assign S_addr = pix_y[4:2];
	assign S_col = pix_x[4:2];
	assign S_bit = S_data[~S_col];

	assign S_on = (416<=pix_x && pix_x<=447 && 192<= pix_y && pix_y <= 224 && S_bit && state ==1);

//-------------Display the Letter P to indicate it is the player's turn--------------//
wire [2:0] P_addr, P_col;
reg [7:0] P_data;
wire P_bit;
wire P_on;

always@*
		case (P_addr)
		3'b000: P_data = 8'b00000000; //
		3'b001: P_data = 8'b01111110; // *****
		3'b010: P_data = 8'b01000001; // *    *
		3'b011: P_data = 8'b01111110; // *****
		3'b100: P_data = 8'b01000000; // *
		3'b101: P_data = 8'b01000000; // *
		3'b110: P_data = 8'b01000000; // *
		3'b111: P_data = 8'b00000000; //
		endcase
//-------------------------------------//

	assign P_addr = pix_y[4:2];
	assign P_col = pix_x[4:2];
	assign P_bit = P_data[~P_col];

	assign P_on = (480<=pix_x && pix_x<=511 && 192<= pix_y && pix_y <= 224 && P_bit && state==2);

//----- Level Numbers -----//

wire [2:0] num_addr, num_col;
reg [7:0] num_data;
wire num_bit;
wire num_on;

always@*
	if (level == 1)
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b00011000; //   **
		3'b010: num_data = 8'b00101000; //  * *
		3'b011: num_data = 8'b00001000; //    *
		3'b100: num_data = 8'b00001000; //    *
		3'b101: num_data = 8'b00001000; //    *
		3'b110: num_data = 8'b00111110; //  *****
		3'b111: num_data = 8'b00000000; //
		endcase

	else if (level == 2)
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b00111100; //  ****
		3'b010: num_data = 8'b01000010; // *    *
		3'b011: num_data = 8'b00000100; //     *
		3'b100: num_data = 8'b00001000; //    *
		3'b101: num_data = 8'b00010000; //   *
		3'b110: num_data = 8'b01111110; // ******
		3'b111: num_data = 8'b00000000; //
		endcase

	else if (level ==3)
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b00111100; //  ****
		3'b010: num_data = 8'b01000010; // *    *
		3'b011: num_data = 8'b00001100; //    **
		3'b100: num_data = 8'b00000010; //      *
		3'b101: num_data = 8'b01000010; // *    *
		3'b110: num_data = 8'b00111100; //  ****
		3'b111: num_data = 8'b00000000; //
		endcase

	else if (level ==4)
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b01000010; // *    *
		3'b010: num_data = 8'b01000010; // *    *
		3'b011: num_data = 8'b01111110; // ******
		3'b100: num_data = 8'b00000010; //      *
		3'b101: num_data = 8'b00000010; //      *
		3'b110: num_data = 8'b00000010; //      *
		3'b111: num_data = 8'b00000000; //
		endcase

	else if (level ==5)
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b01111110; // ******
		3'b010: num_data = 8'b01000000; // *
		3'b011: num_data = 8'b01111100; // *****
		3'b100: num_data = 8'b00000010; //      *
		3'b101: num_data = 8'b01000010; // *    *
		3'b110: num_data = 8'b00111100; //  ****
		3'b111: num_data = 8'b00000000; //
		endcase

	else
		case (num_addr)
		3'b000: num_data = 8'b00000000; //
		3'b001: num_data = 8'b00000000; //
		3'b010: num_data = 8'b00000000; //
		3'b011: num_data = 8'b00000000; //
		3'b100: num_data = 8'b00000000; //
		3'b101: num_data = 8'b00000000; //
		3'b110: num_data = 8'b00000000; //
		3'b111: num_data = 8'b00000000; //
		endcase

	assign num_addr = pix_y[3:1];
	assign num_col = pix_x[3:1];
	assign num_bit = num_data[~num_col];

	assign num_on = (272<=pix_x && pix_x<=287 && 112<= pix_y && pix_y <= 127 && num_bit);

//----- color Selection MUX -----//
	//check if there is input - indicates need for a bright signal
	always@(state)
		if (state[0] || state[1])
			bright = 1;
		else
			bright = 0;

	//Produce color when the pixel is in the range of the button.
	always@*
	begin
		if (bounding_box)
		begin
			video_on = 1;
			vga_R = 8'b11111111;
			vga_G = 8'b11111111;
			vga_B = 8'b11111111;
			end
			// based on input verus rest: assign lit versus unlit color to each button.
		else if (redB_on)
		begin
			video_on = 1;
			vga_G = 8'b00000000;
			vga_B = 8'b00000000;
			if (bright && color[2])
				vga_R = 8'b11111111;
			else
				vga_R = 8'b01100000;
		end
		else if (yelB_on)
		begin
			video_on = 1;
			if (bright && color[1])
			begin
				vga_R = 8'b11111111;
				vga_G = 8'b11111111;
				vga_B = 8'b00000000;
			end
			else
			begin
				vga_R = 8'b01111111;
				vga_G = 8'b01111111;
				vga_B = 8'b00110000;
			end
		end
		else if (grnB_on)
		begin
			video_on = 1;
			vga_R = 8'b00000000;
			vga_B = 8'b00000000;
			if (bright && color[0])
				vga_G = 8'b11111111;
			else
				vga_G = 8'b01100000;
		end
		else if (bluB_on)
		begin
			video_on = 1;
			vga_R = 8'b00000000;
			vga_G = 8'b00000000;
			if (bright && color[3])
				vga_B = 8'b11111111;
			else
				vga_B = 8'b01100000;
		end
		else if (L_on || S_on || P_on || num_on)
		begin
		if (num_on)		//shows the number 5 in green
			begin
			video_on = 1;
			vga_R = 8'b00000000;
			vga_G = 8'b11111111;
			vga_B = 8'b00000000;
			end
		else
			begin
			video_on = 1;
			vga_R = 8'b11111111;
			vga_G = 8'b11111111;
			vga_B = 8'b11111111;
			end
		end
		else
		begin
			vga_R = 8'b00000000;
			vga_G = 8'b00000000;
			vga_B = 8'b00000000;
			end
			end
endmodule
