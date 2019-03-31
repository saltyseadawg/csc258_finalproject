//adapted from Alex Hurka

module keyboard_tracker #(parameter PULSE_OR_HOLD = 0) (
    input clock,
	 input reset,

	 inout PS2_CLK,
	 inout PS2_DAT,

	 output w, a, s, q
	 );

	 // A flag indicating when the keyboard has sent a new byte.
	 wire byte_received;
	 // The most recent byte received from the keyboard.
	 wire [7:0] newest_byte;

	 localparam // States indicating the type of code the controller expects
	            // to receive next.
	            MAKE            = 2'b00,
	            BREAK           = 2'b01,
					SECONDARY_MAKE  = 2'b10,
					SECONDARY_BREAK = 2'b11,

					// Make/break codes for all keys that are handled by this
					// controller. Two keys may have the same make/break codes
					// if one of them is a secondary code.
					// TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
					W_CODE = 8'h1d,
					A_CODE = 8'h1c,
					S_CODE = 8'h1b,
					Q_CODE = 8'h15;

    reg [1:0] curr_state;

	 // Press signals are high when their corresponding key is being pressed,
	 // and low otherwise. They directly represent the keyboard's state.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
    reg w_press, a_press, s_press, q_press;

	 // Lock signals prevent a key press signal from going high for more than one
	 // clock tick when pulse mode is enabled. A key becomes 'locked' as soon as
	 // it is pressed down.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
	 reg w_lock, a_lock, s_lock, q_lock;

	 // Output is equal to the key press wires in mode 0 (hold), and is similar in
	 // mode 1 (pulse) except the signal is lowered when the key's lock goes high.
	 // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
    assign w = w_press && ~(w_lock && PULSE_OR_HOLD);
    assign a = a_press && ~(a_lock && PULSE_OR_HOLD);
    assign s = s_press && ~(s_lock && PULSE_OR_HOLD);
    assign q = q_press && ~(q_lock && PULSE_OR_HOLD);


	 // Core PS/2 driver.
	 PS2_Controller #(.INITIALIZE_MOUSE(0)) core_driver(
	     .CLOCK_50(clock),
		  .reset(~reset),
		  .PS2_CLK(PS2_CLK),
		  .PS2_DAT(PS2_DAT),
		  .received_data(newest_byte),
		  .received_data_en(byte_received)
		  );

    always @(posedge clock) begin
	     // Make is default state. State transitions are handled
        // at the bottom of the case statement below.
		  curr_state <= MAKE;

		  // Lock signals rise the clock tick after the key press signal rises,
		  // and fall one clock tick after the key press signal falls. This way,
		  // only the first clock cycle has the press signal high while the
		  // lock signal is low.
		  // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
		  w_lock <= w_press;
		  a_lock <= a_press;
		  s_lock <= s_press;
		  q_lock <= q_press;
	     if (~reset) begin
		      curr_state <= MAKE;

				// TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
				w_press <= 1'b0;
				a_press <= 1'b0;
				s_press <= 1'b0;
				q_press <= 1'b0;

				w_lock <= 1'b0;
				a_lock <= 1'b0;
				s_lock <= 1'b0;
				q_lock <= 1'b0;
        end
		  else if (byte_received) begin
		      // Respond to the newest byte received from the keyboard,
				// by either making or breaking the specified key, or changing
				// state according to special bytes.
				case (newest_byte)
				    // TODO: ADD TO HERE WHEN IMPLEMENTING NEW KEYS
		          W_CODE: w_press <= curr_state == MAKE;
					 A_CODE: a_press <= curr_state == MAKE;
					 S_CODE: s_press <= curr_state == MAKE;
					 Q_CODE: q_press <= curr_state == MAKE;


					 // State transition logic.
					 // An F0 signal indicates a key is being released. An E0 signal
					 // means that a secondary signal is being used, which will be
					 // followed by a regular set of make/break signals.
					 8'he0: curr_state <= SECONDARY_MAKE;
					 8'hf0: curr_state <= curr_state == MAKE ? BREAK : SECONDARY_BREAK;
		      endcase
        end
        else begin
		      // Default case if no byte is received.
		      curr_state <= curr_state;
		  end
    end
endmodule
