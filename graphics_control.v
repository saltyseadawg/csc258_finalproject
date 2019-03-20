//control unit for graphics

module graphics_control(clock, resetn, load, ld_tile, ld_flash, drw, writeEnable, randomEnable, counterEnable, tile_num);
	input clock;
	input resetn;
	input load;
	input drw;

	output reg ld_tile, ld_flash;
	output reg writeEnable;
	output reg randomEnable;
	output reg counterEnable;
	output reg [2:0] tile_num;

	reg [5:0] curr_state, next_state;

	// States
	localparam bootup			= 4'd0,
				load_t1 = 4'd8,
				load_t2 = 4'd9,
				load_t3 = 4'd10,
				load_t0 = 4'd11,
				draw_t0 = 4'd12,
				draw_t1 = 4'd13,
				draw_t2 = 4'd14,
				draw_t3 = 4'd15,
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
			bootup: next_state = ~drw ? load_t0 : bootup;
			load_t0: next_state = draw_t0;
			draw_t0: next_state = load_t1;
			load_t1: next_state = draw_t1;
			draw_t1: next_state = load_t2;
			load_t2: next_state = draw_t2;
			draw_t2: next_state = load_t3;
			load_t3: next_state = draw_t3;
			draw_t3: next_state = tile_select;
			tile_select: next_state = ~load ? load_tile : tile_select; 
			load_tile: next_state = ~load ? transition : load_tile;
			transition: next_state = flash;
			flash: next_state = ~drw ? draw : flash;
			draw: next_state = load_previous;
			load_previous: next_state = ~drw ? draw_previous : load_previous;
			draw_previous: next_state = tile_select;
		endcase
	end

	// Output Logic
	always @(*) begin
		ld_tile = 1'b0;
		ld_flash = 1'b0;
//		ld_previous = 1'b0;
		writeEnable = 1'b0;
		randomEnable = 1'b0;
		counterEnable = 1'b0;
		tile_num = 3'b000;
		
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
				ld_tile = 1'b1;
			end
			draw_previous: begin
				writeEnable = 1'b1;
				counterEnable = 1'b1;	
			end
			load_t0: begin
				tile_num = 2'b00;
				ld_tile = 1;
			end
			load_t1: begin
				tile_num = 2'b01;
				ld_tile = 1;
			end
			load_t2: begin
				tile_num = 2'b10;
				ld_tile = 1;
			end
			load_t3: begin
				tile_num = 2'b11;
				ld_tile = 1;
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

	// Current State Register
	always @(posedge clock) begin
		if (!resetn)
			curr_state <= bootup;
		else
			curr_state <= next_state;
	end
endmodule
