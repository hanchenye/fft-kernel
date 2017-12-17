module da_coder
(
    input wire [2:0] origin,
    output reg [2:0] coded
);

always @(origin)
begin
    case(origin)
        0: coded = 0;
        1: coded = 4;
        2: coded = 2;
        3: coded = 6;
        4: coded = 1;
        5: coded = 5;
        6: coded = 3;
        7: coded = 7;
    endcase
end

endmodule