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
	input wire  [3:0]            wen_ctrl,
	input wire  [3:0]            ren_ctrl,
	input wire  [2:0]            waddr_ctrl,
	input wire  [2:0]            raddr_ctrl,
	input wire  [DATA_WIDTH-1:0] din_real,
	input wire  [DATA_WIDTH-1:0] din_imag,
	output wire [DATA_WIDTH-1:0] dout_real,
	output wire [DATA_WIDTH-1:0] dout_imag
);

wire [RF_DEPTH-1:0] wen_shift;
wire [RF_DEPTH-1:0] ren_shift;

assign wen_shift = 1'b1 << wen_ctrl;
assign ren_shift = 1'b1 << ren_ctrl;


wire [DATA_WIDTH-1:0] rf_dout_real [RF_DEPTH-1:0];
wire [DATA_WIDTH-1:0] rf_dout_imag [RF_DEPTH-1:0];

assign dout_real = rf_dout_real[0] | rf_dout_real[1] | rf_dout_real[2] | rf_dout_real[3] |
                   rf_dout_real[4] | rf_dout_real[5] | rf_dout_real[6] | rf_dout_real[7];
assign dout_imag = rf_dout_imag[0] | rf_dout_imag[1] | rf_dout_imag[2] | rf_dout_imag[3] |
                   rf_dout_imag[4] | rf_dout_imag[5] | rf_dout_imag[6] | rf_dout_imag[7];


generate
    genvar i;
    for(i = 0; i < RF_DEPTH; i = i + 1)
    begin: gen
        da_regfile
        #(
            .DATA_WIDTH(DATA_WIDTH)
        ) da_regfile_0 (
            .clk(clk),
            .rst_n(rst_n),
            .wen(wen_shift[i]),
            .ren(ren_shift[i]),
            .waddr(waddr_ctrl),
            .raddr(raddr_ctrl),
            .din_real(din_real),
            .din_imag(din_imag),
            .dout_real(rf_dout_real[i]),
            .dout_imag(rf_dout_imag[i])
        );
    end
endgenerate

endmodule