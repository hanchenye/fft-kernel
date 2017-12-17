module tm_testbench();

localparam DATA_WIDTH_IN = 18;
localparam DATA_WIDTH_OUT = 18;

reg signed                      clk;
reg signed                      rst_n;
reg signed                      halt_ctrl;
reg signed [5:0]                tm64_ctrl;
reg signed [DATA_WIDTH_IN-1:0]  din_real;
reg signed [DATA_WIDTH_IN-1:0]  din_imag;

always
begin
	#5 clk = ~clk;
end

initial
begin
	clk = 1;
	rst_n = 1;
	halt_ctrl = 0;
	tm64_ctrl = 0;
	din_real = 0;
	din_imag = 0;

	#40 rst_n = 0;
	#20 rst_n = 1;

	#20 halt_ctrl <= 1;
		tm64_ctrl <= 27;
		din_real <= 10000;
		din_imag <= -10000;

	#10 tm64_ctrl <= 55;
		din_real <= 10000;
		din_imag <= -10000;

end

dif_radix2_64p_tm
#(
	.DATA_WIDTH_IN(18),
	.DATA_WIDTH_OUT(18)
) tm (
	.clk(clk),
	.rst_n(rst_n),
	.halt_ctrl(halt_ctrl),
	.tm64_ctrl(tm64_ctrl),
	.din_real(din_real),
	.din_imag(din_imag),
	.dout_real(),
	.dout_imag()
);

endmodule