module const_testbench();

reg signed [17:0] din_real;
reg signed [17:0] din_imag;
wire signed [17:0] dout_rere;
wire signed [17:0] dout_imim;
wire signed [17:0] dout_reim;
wire signed [17:0] dout_imre;

wire signed [17:0] dout_real;
wire signed [17:0] dout_imag;

initial
begin
    din_real = 100000;
    din_imag = -100000;
end

twiddle64_3
#(
    .DATA_WIDTH(18)
) inst (
	.din_real(din_real),
	.din_imag(din_imag),
    .dout_rere(dout_rere),
    .dout_imim(dout_imim),
    .dout_reim(dout_reim),
    .dout_imre(dout_imre)
);

twiddle_45degree
#(
    .DATA_WIDTH(18)
) twiddle_45degree (
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(dout_real),
    .dout_imag(dout_imag)
);

endmodule