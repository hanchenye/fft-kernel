//////////////////////////////////////////////////
//
// NOTE:
// data arranger
//
//////////////////////////////////////////////////

module dif_radix2_64p_da
#(
	parameter DATA_WIDTH = 17,
	parameter RF_DEPTH = 8
)(
	input wire                   clk,
	input wire                   rst_n,
	input wire  [RF_DEPTH-1:0]   wen_ctrl,
	input wire  [RF_DEPTH-1:0]   ren_ctrl,
	input wire  [2:0]            waddr_ctrl,
	input wire  [2:0]            raddr_ctrl,
	input wire  [DATA_WIDTH-1:0] din_real,
	input wire  [DATA_WIDTH-1:0] din_imag,
	output wire [DATA_WIDTH-1:0] dout_real,
	output wire [DATA_WIDTH-1:0] dout_imag
);

wire [DATA_WIDTH-1:0] rf_dout_real [RF_DEPTH-1:0];
wire [DATA_WIDTH-1:0] rf_dout_imag [RF_DEPTH-1:0];

assign dout_real = rf_dout_real[0] | rf_dout_real[1] | rf_dout_real[2] | rf_dout_real[3] |
                   rf_dout_real[4] | rf_dout_real[5] | rf_dout_real[6] | rf_dout_real[7];
assign dout_imag = rf_dout_imag[0] | rf_dout_imag[1] | rf_dout_imag[2] | rf_dout_imag[3] |
                   rf_dout_imag[4] | rf_dout_imag[5] | rf_dout_imag[6] | rf_dout_imag[7];

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_0 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[0]),
    .ren(ren_ctrl[0]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[0]),
    .dout_imag(rf_dout_imag[0])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_1 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[4]),
    .ren(ren_ctrl[1]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[1]),
    .dout_imag(rf_dout_imag[1])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_2 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[2]),
    .ren(ren_ctrl[2]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[2]),
    .dout_imag(rf_dout_imag[2])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_3 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[6]),
    .ren(ren_ctrl[3]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[3]),
    .dout_imag(rf_dout_imag[3])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_4 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[1]),
    .ren(ren_ctrl[4]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[4]),
    .dout_imag(rf_dout_imag[4])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_5 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[5]),
    .ren(ren_ctrl[5]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[5]),
    .dout_imag(rf_dout_imag[5])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_6 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[3]),
    .ren(ren_ctrl[6]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[6]),
    .dout_imag(rf_dout_imag[6])
);

da_regfile
#(
    .DATA_WIDTH(DATA_WIDTH)
) da_regfile_7 (
    .clk(clk),
    .rst_n(rst_n),
    .wen(wen_ctrl[7]),
    .ren(ren_ctrl[7]),
    .waddr(waddr_ctrl),
    .raddr(raddr_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(rf_dout_real[7]),
    .dout_imag(rf_dout_imag[7])
);

endmodule