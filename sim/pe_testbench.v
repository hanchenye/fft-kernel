module pe_testbench();

localparam DATA_WIDTH_IN = 10;
localparam DATA_WIDTH_OUT = 12;
localparam TWIDDLE_RANK = 8;
localparam FIFO_DEPTH = 4;

reg                       clk;
reg                       rst_n;
reg                       halt_ctrl;
reg                       mux_ctrl;
reg  [1:0]                tm_ctrl;
reg  [DATA_WIDTH_IN-1:0]  din_real;
reg  [DATA_WIDTH_IN-1:0]  din_imag;
wire [DATA_WIDTH_OUT-1:0] dout_real;
wire [DATA_WIDTH_OUT-1:0] dout_imag;

always
begin
    #5 clk = ~clk;
end

initial
begin
    clk = 1;
    rst_n = 1;
    halt_ctrl = 0;
    mux_ctrl = 0;
    tm_ctrl = 0;
    din_real = 0;
    din_imag = 0;

    #20 rst_n = 0;
    #20 rst_n = 1;

//////////////////////////////

    #40 mux_ctrl <= 0;
        tm_ctrl <= 0;
        din_real <= 100;
        din_imag <= 200;
        halt_ctrl <= 1;

    #10 mux_ctrl <= 0;
        tm_ctrl <= 0;
        din_real <= 90;
        din_imag <= 180;
//        halt_ctrl = 1;

    #10 mux_ctrl <= 0;
        tm_ctrl <= 0;
        din_real <= 80;
        din_imag <= 160;

    #10 mux_ctrl <= 0;
        tm_ctrl <= 0;
        din_real <= 70;
        din_imag <= 140;

///////////////////////////////////

    #10 mux_ctrl <= 1;
        tm_ctrl <= 0;
        din_real <= 60;
        din_imag <= 120;

    #10 mux_ctrl <= 1;
        tm_ctrl <= 0;
        din_real <= 50;
        din_imag <= 100;

    #10 mux_ctrl <= 1;
        tm_ctrl <= 0;
        din_real <= 40;
        din_imag <= 80;

    #10 mux_ctrl <= 1;
        tm_ctrl <= 0;
        din_real <= 30;
        din_imag <= 60;
        
//////////////////////////////
        
            #10 mux_ctrl <= 0;
                tm_ctrl <= 0;
                din_real <= 10;
                din_imag <= 10;
                halt_ctrl <= 1;
        
            #10 mux_ctrl <= 0;
                tm_ctrl <= 1;
                din_real <= 9;
                din_imag <= 9;
        //        halt_ctrl = 1;
        
            #10 mux_ctrl <= 0;
                tm_ctrl <= 2;
                din_real <= 8;
                din_imag <= 8;
        
            #10 mux_ctrl <= 0;
                tm_ctrl <= 3;
                din_real <= 7;
                din_imag <= 7;
        
        ///////////////////////////////////
        
            #10 mux_ctrl <= 1;
                tm_ctrl <= 0;
                din_real <= 6;
                din_imag <= 6;
        
            #10 mux_ctrl <= 1;
                tm_ctrl <= 0;
                din_real <= 5;
                din_imag <= 5;
        
            #10 mux_ctrl <= 1;
                tm_ctrl <= 0;
                din_real <= 4;
                din_imag <= 4;
        
            #10 mux_ctrl <= 1;
                tm_ctrl <= 0;
                din_real <= 3;
                din_imag <= 3;
end

dif_radix2_pe
#(
    .DATA_WIDTH_IN(DATA_WIDTH_IN),
    .DATA_WIDTH_OUT(DATA_WIDTH_OUT),
    .TWIDDLE_RANK(TWIDDLE_RANK),
    .FIFO_DEPTH(FIFO_DEPTH)
) dif_radix_pe (
    .clk(clk),
    .rst_n(rst_n),
    .halt_ctrl(halt_ctrl),
    .mux_ctrl(mux_ctrl),
    .tm_ctrl(tm_ctrl),
    .din_real(din_real),
    .din_imag(din_imag),
    .dout_real(dout_real),
    .dout_imag(dout_imag)
);

endmodule
