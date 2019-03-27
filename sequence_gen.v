module sequence_gen(
    seq,
    go_to_next_seq,
    reset,
    clk
);

    output seq [3:0];
    
    // use linear feedback switch-register to generate random sequences
    // runs for 2^(n)-1 clock cycles -- set n=8
    
    reg [7:0] = seed;
    wire linear_feedback = !(seed[6] ^ seed[3]);

    assign seq = seed[7:4];

    always @(posedge clk)
    begin
        if (reset)
            seed <= 8'd0
        else if (go_to_next_seq)
            seed <= {out[6:0], linear_feedback}
    end
    endmodule


