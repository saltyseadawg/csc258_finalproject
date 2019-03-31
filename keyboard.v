module keyboard(clk,PS2_DATA,PS2_CLOCK,rxdata);
  input PS2_DATA;
  input PS2_CLOCK;
  output [7:0]rxdata; // print input data
  reg [7:0] rxdata1;
  reg datafetched;

	always@(posedge PS2_CLOCK)
	begin
	rxdata1=rxdata;
		begin
		case(rxdata)
		8'h1C: colour[0] = 1;  //r a
		8'h1B: colour[1] = 1;  //y s
		8'h23: colour[2] = 1;  //b d
		8'h2B: colour[3] = 1;  //g f
		default colour[3:0] = 0;
		endcase
	end
  endmodule
