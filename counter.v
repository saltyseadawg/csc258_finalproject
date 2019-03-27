// count # rounds, current/completed sequences 
module counter (
    count,
    increase,
    reset,
    clk
);

    always @(posedge clk)
    begin
        if (reset)
            // active high reset
            count <= 5'd0
        else if (increase)
            count <= count + 5'd1;
    end
    endmodule

