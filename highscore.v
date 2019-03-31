module highscore(clk, sequence_counter, HEX_best, HEX_current, load_current, load_best);

  input clk;
  input [3:0] sequence_counter;
  input load_current, load_best;

  reg [3:0] current_score; //score of current round
  reg [3:0] best_score; //overall best score of all round
  output [6:0] HEX_best, HEX_current;

  initial begin
    current_score = 3'b000;
    best_score = 3'b000;
  end

  always @(posedge clk) begin
    if (load_current)
      current_score <= sequence_counter;
    if (load_best) begin
      if (sequence_counter > best_score)
        best_score <= sequence_counter;
    end
  end

  decoder decode_best(
    .SW(best_score),
    .HEX(HEX_best)
    );

  decoder decode_current(
    .SW(current_score),
    .HEX(HEX_current)
    );
endmodule
