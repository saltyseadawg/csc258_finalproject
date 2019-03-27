// count # rounds, current/completed sequences 
module counter_neg (
    count,
    increase,
    reset,
    clk
);

    //initialize count to 1
    count = 5'd1

    always @(negedge clk)
    begin
        if (reset)
            // active high reset
            count <= 5'd0
        else if (increase)
            count <= count + 5'd1;
    end
    endmodule

