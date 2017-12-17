module radix2_butterfly
#(
    parameter DATA_WIDTH_IN = 10,
    parameter DATA_WIDTH_OUT = DATA_WIDTH_IN + 1
)(
    input  wire signed [DATA_WIDTH_OUT-1:0]  ain_real,
    input  wire signed [DATA_WIDTH_OUT-1:0]  ain_imag,
    input  wire signed [DATA_WIDTH_IN-1:0]  bin_real,
    input  wire signed [DATA_WIDTH_IN-1:0]  bin_imag,
    output wire signed [DATA_WIDTH_OUT-1:0] aout_real,
    output wire signed [DATA_WIDTH_OUT-1:0] aout_imag,
    output wire signed [DATA_WIDTH_OUT-1:0] bout_real,
    output wire signed [DATA_WIDTH_OUT-1:0] bout_imag
);

assign aout_real = ain_real + bin_real;
assign aout_imag = ain_imag + bin_imag;

assign bout_real = ain_real - bin_real;
assign bout_imag = ain_imag - bin_imag;

endmodule
