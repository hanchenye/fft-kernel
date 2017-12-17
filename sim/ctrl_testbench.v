module ctrl_testbench();

localparam FFT_NUM = 6;
localparam TM_DELAY = 1;

reg                clk;
reg                rst_n;
reg                din_valid;
wire               dout_valid;
wire               halt_ctrl;
wire [1:0]         pe5_tm8_ctrl;
wire               pe4_tm4_ctrl;
wire [1:0]         pe2_tm8_ctrl;
wire               pe1_tm4_ctrl;

always
begin
    #5 clk = ~clk;
end

initial
begin
    clk = 1;
    rst_n = 1;
    din_valid = 0;

    #20 rst_n = 0;
    #20 rst_n = 1;

    #40 din_valid <= 1;
//    #250 din_valid <= 0;
//    #300 din_valid <= 1;
//    #600 din_valid <= 0;
//    #650 din_valid <= 1;
end

dif_radix2_ctrl
#(
    .FFT_NUM(FFT_NUM),
    .TM_DELAY(TM_DELAY)
) ctrl (
    .clk(clk),
    .rst_n(rst_n),
    .din_valid(din_valid),
    .dout_valid(dout_valid),
    .halt_ctrl(halt_ctrl),
    .pe5_tm8_ctrl(pe5_tm8_ctrl),
    .pe4_tm4_ctrl(pe4_tm4_ctrl),
    .pe2_tm8_ctrl(pe2_tm8_ctrl),
    .pe1_tm4_ctrl(pe1_tm4_ctrl)
);

endmodule