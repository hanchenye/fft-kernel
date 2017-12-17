//////////////////////////////////////////////////
//
// NOTE:
// fft top
//
//////////////////////////////////////////////////

module dif_radix2_64p_fft
#(
    parameter DATA_WIDTH_IN  = 10,
    parameter DATA_WIDTH_PE5 = 17,
    parameter DATA_WIDTH_PE4 = 17,
    parameter DATA_WIDTH_PE3 = 17,
    parameter DATA_WIDTH_TM  = 17,
    parameter DATA_WIDTH_PE2 = 17,
    parameter DATA_WIDTH_PE1 = 17,
    parameter DATA_WIDTH_PE0 = 17,
    parameter DATA_WIDTH_OUT = 17,
    parameter FFT_NUM = 6
)(
    input                       clk,
    input                       rst_n,
    input  [DATA_WIDTH_IN-1:0]  din_re,
    input  [DATA_WIDTH_IN-1:0]  din_im,
    input                       din_valid,
    output [DATA_WIDTH_OUT-1:0] dout_re,
    output [DATA_WIDTH_OUT-1:0] dout_im,
    output                      dout_valid
);

reg [DATA_WIDTH_IN-1:0] din_re_reg;
reg [DATA_WIDTH_IN-1:0] din_im_reg;

wire       halt_ctrl;
wire       pe5_mux_ctrl;
wire       pe4_mux_ctrl;
wire       pe3_mux_ctrl;
wire       pe2_mux_ctrl;
wire       pe1_mux_ctrl;
wire       pe0_mux_ctrl;

wire [1:0] pe5_tm8_ctrl;
wire [1:0] pe4_tm4_ctrl;
wire [1:0] pe2_tm8_ctrl;
wire [1:0] pe1_tm4_ctrl;

wire [3:0] da_wen_ctrl;
wire [3:0] da_ren_ctrl;
wire [2:0] da_waddr_ctrl;
wire [2:0] da_raddr_ctrl;
wire [5:0] tm64_ctrl;

wire [DATA_WIDTH_PE5-1:0] pe5_dout_real;
wire [DATA_WIDTH_PE5-1:0] pe5_dout_imag;
wire [DATA_WIDTH_PE4-1:0] pe4_dout_real;
wire [DATA_WIDTH_PE4-1:0] pe4_dout_imag;
wire [DATA_WIDTH_PE3-1:0] pe3_dout_real;
wire [DATA_WIDTH_PE3-1:0] pe3_dout_imag;
wire [DATA_WIDTH_TM-1:0] tm_dout_real;
wire [DATA_WIDTH_TM-1:0] tm_dout_imag;
wire [DATA_WIDTH_PE2-1:0] pe2_dout_real;
wire [DATA_WIDTH_PE2-1:0] pe2_dout_imag;
wire [DATA_WIDTH_PE1-1:0] pe1_dout_real;
wire [DATA_WIDTH_PE1-1:0] pe1_dout_imag;
wire [DATA_WIDTH_PE0-1:0] pe0_dout_real;
wire [DATA_WIDTH_PE0-1:0] pe0_dout_imag;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        din_re_reg <= 0;
        din_im_reg <= 0;
    end
    else if(din_valid)
    begin
        din_re_reg <= din_re;
        din_im_reg <= din_im;
    end
    else
    begin
        din_re_reg <= din_re_reg;
        din_im_reg <= din_im_reg;
    end
end

dif_radix2_ctrl
#(
    .FFT_NUM(6),
    .TM_DELAY(2)
) ctrl (
    .clk(clk),
    .rst_n(rst_n),
    .din_valid(din_valid),
    .dout_valid(dout_valid),
    .halt_ctrl(halt_ctrl),

    .pe5_mux_ctrl(pe5_mux_ctrl),
    .pe4_mux_ctrl(pe4_mux_ctrl),
    .pe3_mux_ctrl(pe3_mux_ctrl),
    .pe2_mux_ctrl(pe2_mux_ctrl),
    .pe1_mux_ctrl(pe1_mux_ctrl),
    .pe0_mux_ctrl(pe0_mux_ctrl),

    .pe5_tm8_ctrl(pe5_tm8_ctrl),
    .pe4_tm4_ctrl(pe4_tm4_ctrl),
    .pe2_tm8_ctrl(pe2_tm8_ctrl),
    .pe1_tm4_ctrl(pe1_tm4_ctrl),

    .tm64_ctrl(tm64_ctrl),
    .da_wen_ctrl(da_wen_ctrl),
    .da_ren_ctrl(da_ren_ctrl),
    .da_waddr_ctrl(da_waddr_ctrl),
    .da_raddr_ctrl(da_raddr_ctrl)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_IN),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE5),
    .TWIDDLE_RANK(8),
    .FIFO_DEPTH(32)
) pe5 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe5_mux_ctrl),
    .tm_ctrl(pe5_tm8_ctrl),
    .din_real(din_re_reg),
    .din_imag(din_im_reg),
    .dout_real(pe5_dout_real),
    .dout_imag(pe5_dout_imag)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_PE5),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE4),
    .TWIDDLE_RANK(4),
    .FIFO_DEPTH(16)
) pe4 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe4_mux_ctrl),
    .tm_ctrl(pe4_tm4_ctrl),
    .din_real(pe5_dout_real),
    .din_imag(pe5_dout_imag),
    .dout_real(pe4_dout_real),
    .dout_imag(pe4_dout_imag)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_PE4),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE3),
    .TWIDDLE_RANK(2),
    .FIFO_DEPTH(8)
) pe3 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe3_mux_ctrl),
    .tm_ctrl(0),
    .din_real(pe4_dout_real),
    .din_imag(pe4_dout_imag),
    .dout_real(pe3_dout_real),
    .dout_imag(pe3_dout_imag)
);

dif_radix2_64p_tm
#(
    .DATA_WIDTH_IN(DATA_WIDTH_PE3),
    .DATA_WIDTH_OUT(DATA_WIDTH_TM)
) tm (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .tm64_ctrl(tm64_ctrl),
    .din_real(pe3_dout_real),
    .din_imag(pe3_dout_imag),
    .dout_real(tm_dout_real),
    .dout_imag(tm_dout_imag)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_TM),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE2),
    .TWIDDLE_RANK(8),
    .FIFO_DEPTH(4)
) pe2 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe2_mux_ctrl),
    .tm_ctrl(pe2_tm8_ctrl),
    .din_real(tm_dout_real),
    .din_imag(tm_dout_imag),
    .dout_real(pe2_dout_real),
    .dout_imag(pe2_dout_imag)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_PE2),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE1),
    .TWIDDLE_RANK(4),
    .FIFO_DEPTH(2)
) pe1 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe1_mux_ctrl),
    .tm_ctrl(pe1_tm4_ctrl),
    .din_real(pe2_dout_real),
    .din_imag(pe2_dout_imag),
    .dout_real(pe1_dout_real),
    .dout_imag(pe1_dout_imag)
);

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_PE1),
    .DATA_WIDTH_OUT(DATA_WIDTH_PE0),
    .TWIDDLE_RANK(2),
    .FIFO_DEPTH(1)
) pe0 (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(pe0_mux_ctrl),
    .tm_ctrl(0),
    .din_real(pe1_dout_real),
    .din_imag(pe1_dout_imag),
    .dout_real(pe0_dout_real),
    .dout_imag(pe0_dout_imag)
);

dif_radix2_64p_da
#(
    .DATA_WIDTH(DATA_WIDTH_OUT)
) da (
    .clk(clk),
    .rst_n(rst_n),
    .wen_ctrl(da_wen_ctrl),
    .ren_ctrl(da_ren_ctrl),
    .waddr_ctrl(da_waddr_ctrl),
    .raddr_ctrl(da_raddr_ctrl),
    .din_real(pe0_dout_real),
    .din_imag(pe0_dout_imag),
    .dout_real(dout_re),
    .dout_imag(dout_im)
);

endmodule