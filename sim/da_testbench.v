module da_testbench();

localparam DATA_WIDTH = 17;
localparam RF_DEPTH = 8;

reg                   clk;
reg                   rst_n;
reg  [RF_DEPTH-1:0]   wen_ctrl;
reg  [RF_DEPTH-1:0]   ren_ctrl;
reg  [2:0]            waddr_ctrl;
reg  [2:0]            raddr_ctrl;
reg  [DATA_WIDTH-1:0] din_real;
reg  [DATA_WIDTH-1:0] din_imag;

always
begin
	#5 clk = ~clk;
end

initial
begin
	clk = 1;
	rst_n = 1;
	wen_ctrl = 0;
	ren_ctrl = 1;
	waddr_ctrl = 0;
	raddr_ctrl = 0;
	din_real = 0;
	din_imag = 0;

	#20 rst_n = 0;
	#40 rst_n = 1;

	#20 wen_ctrl[1] <= 1;
	    waddr_ctrl <= 0;
	    din_real <= 0;
	    din_imag <= 0;

	#10 waddr_ctrl <= 1;
		din_real <= 4;
	    din_imag <= 4;

	#10 waddr_ctrl <= 2;
		din_real <= 2;
	    din_imag <= 2;

	#10 waddr_ctrl <= 3;
		din_real <= 6;
	    din_imag <= 6;

	#10 waddr_ctrl <= 4;
		din_real <= 1;
	    din_imag <= 1;

	#10 waddr_ctrl <= 5;
		din_real <= 5;
	    din_imag <= 5;

	#10 waddr_ctrl <= 6;
		din_real <= 3;
	    din_imag <= 3;

	#10 waddr_ctrl <= 7;
		din_real <= 7;
	    din_imag <= 7;

	#10 wen_ctrl[1] <= 0;
		waddr_ctrl <= 0;

	#20 ren_ctrl[4] <= 1;
		raddr_ctrl <= 0;

	#10 raddr_ctrl <= 1;
	#10 raddr_ctrl <= 2;
	#10 raddr_ctrl <= 3;
	#10 raddr_ctrl <= 4;
	#10 raddr_ctrl <= 5;
	#10 raddr_ctrl <= 6;
	#10 raddr_ctrl <= 7;
end

dif_radix2_64p_da
#(
	.DATA_WIDTH(17),
	.RF_DEPTH(8)
) dif_radix2_64p_da (
	.clk(clk),
	.rst_n(rst_n),
	.wen_ctrl(wen_ctrl),
	.ren_ctrl(ren_ctrl),
	.waddr_ctrl(waddr_ctrl),
	.raddr_ctrl(raddr_ctrl),
	.din_real(din_real),
	.din_imag(din_imag),
	.dout_real(),
	.dout_imag()
);

endmodule