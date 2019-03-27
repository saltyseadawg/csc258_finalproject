module user_in(
    user_sel,
    button_pressed,
    key,
    clk
);

    output button_pressed;
    output reg [3:0] user_sel;

    input reg [3:0] key;

    // xor to ensure that input is only valid when user chooses 1 button
    // bool val for whether the user pressed a button
    assign button_pressed = |user_sel;

    always @(posedge clk)
    begin
        // update user's input 
        user_sel <= key;
    end
    endmodule

