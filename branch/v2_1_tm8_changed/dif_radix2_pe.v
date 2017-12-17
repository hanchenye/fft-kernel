//////////////////////////////////////////////////
//
// NOTE:
// 1. every parameter is REQUIRED.
// 2. mux_ctrl: 0-output sub results, 1-output add results.
// 3. halt_ctrl: 0-halt, 1-run.
// 4. no stage registers in this module.
//
//////////////////////////////////////////////////

module dif_radix2_pe
#(
    parameter DATA_WIDTH_IN = 10,
    parameter DATA_WIDTH_OUT = 12,
    parameter TWIDDLE_RANK = 8,
    parameter FIFO_DEPTH = 32
)(
    input wire                             clk,
    input wire                             rst_n,
    input wire                             halt_ctrl,
    input wire                             mux_ctrl,
    input wire [1:0]                       tm_ctrl,
    input wire signed [DATA_WIDTH_IN-1:0]  din_real,
    input wire signed [DATA_WIDTH_IN-1:0]  din_imag,
    output reg signed [DATA_WIDTH_OUT-1:0] dout_real,
    output reg signed [DATA_WIDTH_OUT-1:0] dout_imag
);

wire signed [DATA_WIDTH_OUT-1:0] bf_aout_real;
wire signed [DATA_WIDTH_OUT-1:0] bf_aout_imag;
wire signed [DATA_WIDTH_OUT-1:0] bf_bout_real;
wire signed [DATA_WIDTH_OUT-1:0] bf_bout_imag;

wire signed [DATA_WIDTH_OUT-1:0] sr_din_real;
wire signed [DATA_WIDTH_OUT-1:0] sr_din_imag;
wire signed [DATA_WIDTH_OUT-1:0] sr_dout_real;
wire signed [DATA_WIDTH_OUT-1:0] sr_dout_imag;

wire signed [DATA_WIDTH_OUT-1:0] tm_dout_real;
wire signed [DATA_WIDTH_OUT-1:0] tm_dout_imag;

radix2_butterfly
#(
    .DATA_WIDTH_IN(DATA_WIDTH_IN),
    .DATA_WIDTH_OUT(DATA_WIDTH_OUT)
) radix2_butterfly (
    .ain_real(sr_dout_real),
    .ain_imag(sr_dout_imag),
    .bin_real(din_real),
    .bin_imag(din_imag),
    .aout_real(bf_aout_real),
    .aout_imag(bf_aout_imag),
    .bout_real(bf_bout_real),
    .bout_imag(bf_bout_imag)
);

shift_register
#(
    .DATA_WIDTH(DATA_WIDTH_OUT),
    .DEPTH(FIFO_DEPTH)
) shift_register (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .din_real(sr_din_real),
    .din_imag(sr_din_imag),
    .dout_real(sr_dout_real),
    .dout_imag(sr_dout_imag)
);

twiddle8_multiplier
#(
    .DATA_WIDTH_IN(DATA_WIDTH_OUT),
    .DATA_WIDTH_OUT(DATA_WIDTH_OUT),
    .TWIDDLE_RANK(TWIDDLE_RANK)
) twiddle8_multiplier (
    .twiddle(tm_ctrl),
    .din_real(sr_dout_real),
    .din_imag(sr_dout_imag),
    .dout_real(tm_dout_real),
    .dout_imag(tm_dout_imag)
);

assign sr_din_real = mux_ctrl ? bf_bout_real : {{{DATA_WIDTH_OUT-DATA_WIDTH_IN}{din_real[DATA_WIDTH_IN-1]}}, din_real};
assign sr_din_imag = mux_ctrl ? bf_bout_imag : {{{DATA_WIDTH_OUT-DATA_WIDTH_IN}{din_imag[DATA_WIDTH_IN-1]}}, din_imag};

//assign dout_real = mux_ctrl ? bf_aout_real : tm_dout_real;
//assign dout_imag = mux_ctrl ? bf_aout_imag : tm_dout_imag;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        dout_real <= 0;
        dout_imag <= 0;
    end
    else if(halt_ctrl)
    begin
        if(mux_ctrl)
        begin
            dout_real <= bf_aout_real;
            dout_imag <= bf_aout_imag;
        end
        else
        begin
            dout_real <= tm_dout_real;
            dout_imag <= tm_dout_imag;
        end
    end
    else
    begin
        dout_real <= dout_real;
        dout_imag <= dout_imag;
    end
end

endmodule