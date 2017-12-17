module twiddle64_0
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

assign dout_rere = din_real;
assign dout_imim = din_imag;
assign dout_reim = din_real;
assign dout_imre = din_imag;

endmodule


module twiddle64_1
#(
	parameter DATA_WIDTH = 14
)(
	input  signed [DATA_WIDTH-1:0] din_real,
	input  signed [DATA_WIDTH-1:0] din_imag,
	output signed [DATA_WIDTH-1:0] dout_rere,
	output signed [DATA_WIDTH-1:0] dout_imim,
	output signed [DATA_WIDTH-1:0] dout_reim,
	output signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;

assign tmp0_rere = din_real - (din_real >>> 4);
assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 6);
assign dout_rere = tmp0_rere + (tmp1_rere >>> 4);

assign tmp0_imim = din_imag >>> 4;
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 2);
assign tmp2_imim = tmp1_imim + (tmp1_imim >>> 6);
assign dout_imim = tmp1_imim + (tmp2_imim >>> 2);

assign tmp0_imre = din_imag - (din_imag >>> 4);
assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 6);
assign dout_imre = tmp0_imre + (tmp1_imre >>> 4);

assign tmp0_reim = din_real >>> 4;
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 2);
assign tmp2_reim = tmp1_reim + (tmp1_reim >>> 6);
assign dout_reim = tmp1_reim + (tmp2_reim >>> 2);

endmodule


module twiddle64_2
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;

assign tmp0_rere = din_real + (din_real >>> 2);
assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 6);
assign dout_rere = din_real - (tmp1_rere >>> 6);

assign tmp0_imim = din_imag >>> 3;
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 4);
assign tmp2_imim = tmp1_imim - (tmp1_imim >>> 4);
assign dout_imim = tmp1_imim + (tmp2_imim >>> 1);

assign tmp0_imre = din_imag + (din_imag >>> 2);
assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 6);
assign dout_imre = din_imag - (tmp1_imre >>> 6);

assign tmp0_reim = din_real >>> 3;
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 4);
assign tmp2_reim = tmp1_reim - (tmp1_reim >>> 4);
assign dout_reim = tmp1_reim + (tmp2_reim >>> 1);

endmodule


module twiddle64_3
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;
wire signed [DATA_WIDTH:0] tmp3_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;
wire signed [DATA_WIDTH:0] tmp3_reim;

assign tmp0_rere = din_real - (din_real >>> 5);
assign tmp1_rere = tmp0_rere + (tmp0_rere >>> 8);
assign dout_rere = tmp1_rere - (din_real >>> 6);

assign tmp0_imim = din_imag >>> 2;
assign tmp1_imim = tmp0_imim - (tmp0_imim >>> 2);
assign tmp2_imim = tmp1_imim + (tmp1_imim >>> 5);
assign tmp3_imim = tmp1_imim - (tmp2_imim >>> 3);
assign dout_imim = tmp3_imim + (tmp0_imim >>> 1);

assign tmp0_imre = din_imag - (din_imag >>> 5);
assign tmp1_imre = tmp0_imre + (tmp0_imre >>> 8);
assign dout_imre = tmp1_imre - (din_imag >>> 6);

assign tmp0_reim = din_real >>> 2;
assign tmp1_reim = tmp0_reim - (tmp0_reim >>> 2);
assign tmp2_reim = tmp1_reim + (tmp1_reim >>> 5);
assign tmp3_reim = tmp1_reim - (tmp2_reim >>> 3);
assign dout_reim = tmp3_reim + (tmp0_reim >>> 1);

endmodule


module twiddle64_4
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;

assign tmp0_rere = din_real - (din_real >>> 3);
assign tmp1_rere = din_real + (tmp0_rere >>> 2);
assign dout_rere = din_real - (tmp1_rere >>> 4);

assign tmp0_imim = din_imag >>> 2;
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 1);
assign tmp2_imim = tmp0_imim - (tmp0_imim >>> 7);
assign dout_imim = tmp1_imim + (tmp2_imim >>> 5);

assign tmp0_imre = din_imag - (din_imag >>> 3);
assign tmp1_imre = din_imag + (tmp0_imre >>> 2);
assign dout_imre = din_imag - (tmp1_imre >>> 4);

assign tmp0_reim = din_real >>> 2;
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 1);
assign tmp2_reim = tmp0_reim - (tmp0_reim >>> 7);
assign dout_reim = tmp1_reim + (tmp2_reim >>> 5);

endmodule


module twiddle64_5
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;
wire signed [DATA_WIDTH:0] tmp3_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;
wire signed [DATA_WIDTH:0] tmp3_reim;

assign tmp0_rere = din_real + (din_real >>> 7);
assign tmp1_rere = tmp0_rere + (tmp0_rere >>> 4);
assign dout_rere = din_real - (tmp1_rere >>> 3);

assign tmp0_imim = din_imag >>> 1;
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 2);
assign tmp2_imim = tmp1_imim + (tmp1_imim >>> 3);
assign tmp3_imim = (tmp2_imim >>> 6) - tmp1_imim;
assign dout_imim = (tmp3_imim >>> 2) + tmp1_imim;

assign tmp0_imre = din_imag + (din_imag >>> 7);
assign tmp1_imre = tmp0_imre + (tmp0_imre >>> 4);
assign dout_imre = din_imag - (tmp1_imre >>> 3);

assign tmp0_reim = din_real >>> 1;
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 2);
assign tmp2_reim = tmp1_reim + (tmp1_reim >>> 3);
assign tmp3_reim = (tmp2_reim >>> 6) - tmp1_reim;
assign dout_reim = (tmp3_reim >>> 2) + tmp1_reim;

endmodule


module twiddle64_6
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;
wire signed [DATA_WIDTH:0] tmp2_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;
wire signed [DATA_WIDTH:0] tmp2_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;

assign tmp0_rere = din_real + (din_real >>> 2);
assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 5);
assign tmp2_rere = tmp0_rere + (tmp1_rere >>> 4);
assign dout_rere = (din_real >>> 1) + (tmp2_rere >>> 2);

assign tmp0_imim = din_imag >>> 1;
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 6);
assign tmp2_imim = tmp1_imim - (tmp1_imim >>> 3);
assign dout_imim = tmp0_imim + (tmp2_imim >>> 3);

assign tmp0_imre = din_imag + (din_imag >>> 2);
assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 5);
assign tmp2_imre = tmp0_imre + (tmp1_imre >>> 4);
assign dout_imre = (din_imag >>> 1) + (tmp2_imre >>> 2);

assign tmp0_reim = din_real >>> 1;
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 6);
assign tmp2_reim = tmp1_reim - (tmp1_reim >>> 3);
assign dout_reim = tmp0_reim + (tmp2_reim >>> 3);

endmodule


module twiddle64_7
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;
wire signed [DATA_WIDTH:0] tmp2_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;
wire signed [DATA_WIDTH:0] tmp2_reim;

assign tmp0_rere = din_real - (din_real >>> 5);
assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 4);
assign dout_rere = din_real - (tmp1_rere >>> 2);

assign tmp0_imim = din_imag + (din_imag >>> 4);
assign tmp1_imim = din_imag + (tmp0_imim >>> 7);
assign tmp2_imim = tmp1_imim + (tmp1_imim >>> 3);
assign dout_imim = tmp2_imim - (din_imag >>> 1);

assign tmp0_imre = din_imag - (din_imag >>> 5);
assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 4);
assign dout_imre = din_imag - (tmp1_imre >>> 2);

assign tmp0_reim = din_real + (din_real >>> 4);
assign tmp1_reim = din_real + (tmp0_reim >>> 7);
assign tmp2_reim = tmp1_reim + (tmp1_reim >>> 3);
assign dout_reim = tmp2_reim - (din_real >>> 1);

endmodule


module twiddle64_8
#(
	parameter DATA_WIDTH = 14
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

wire signed [DATA_WIDTH:0] tmp0_rere;
wire signed [DATA_WIDTH:0] tmp1_rere;

wire signed [DATA_WIDTH:0] tmp0_imim;
wire signed [DATA_WIDTH:0] tmp1_imim;

wire signed [DATA_WIDTH:0] tmp0_imre;
wire signed [DATA_WIDTH:0] tmp1_imre;

wire signed [DATA_WIDTH:0] tmp0_reim;
wire signed [DATA_WIDTH:0] tmp1_reim;

assign tmp0_rere = din_real - (din_real >>> 4);
assign tmp1_rere = tmp0_rere + (tmp0_rere >>> 2);
assign dout_rere = din_real - (tmp1_rere >>> 2);

assign tmp0_imim = din_imag - (din_imag >>> 4);
assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 2);
assign dout_imim = din_imag - (tmp1_imim >>> 2);

assign tmp0_imre = din_imag - (din_imag >>> 4);
assign tmp1_imre = tmp0_imre + (tmp0_imre >>> 2);
assign dout_imre = din_imag - (tmp1_imre >>> 2);

assign tmp0_reim = din_real - (din_real >>> 4);
assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 2);
assign dout_reim = din_real - (tmp1_reim >>> 2);

endmodule