module shift_register
#(
    parameter DATA_WIDTH = 10,
    parameter DEPTH = 32
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  halt_ctrl,
    input  wire [DATA_WIDTH-1:0] din_real,
    input  wire [DATA_WIDTH-1:0] din_imag,
    output wire [DATA_WIDTH-1:0] dout_real,
    output wire [DATA_WIDTH-1:0] dout_imag
);

reg [DATA_WIDTH-1:0] reg_real [DEPTH-1:0];
reg [DATA_WIDTH-1:0] reg_imag [DEPTH-1:0];

generate
    genvar i;
    for(i = 1; i < DEPTH; i = i + 1)
    begin: con
        always @(posedge clk)
        begin
            if(!rst_n)
            begin
                reg_real[i] <= 0;
                reg_imag[i] <= 0;
            end
            else if(halt_ctrl)
            begin
                reg_real[i] <= reg_real[i-1];
                reg_imag[i] <= reg_imag[i-1];
            end
            else
            begin
                reg_real[i] <= reg_real[i];
                reg_imag[i] <= reg_imag[i];
            end
        end
    end
endgenerate

always @(posedge clk)
begin
    if(!rst_n)
    begin
        reg_real[0] <= 0;
        reg_imag[0] <= 0;
//        dout_real <= dout_real;
//        dout_imag <= dout_imag;
    end
    else if(halt_ctrl)
    begin
        reg_real[0] <= din_real;
        reg_imag[0] <= din_imag;
//        dout_real <= gen[DEPTH-1].reg_real;
//        dout_imag <= gen[DEPTH-1].reg_imag;
    end
    else
    begin
        reg_real[0] <= reg_real[0];
        reg_imag[0] <= reg_imag[0];
//        dout_real <= dout_real;
//        dout_imag <= dout_imag;
    end
end

assign dout_real = reg_real[DEPTH-1];
assign dout_imag = reg_imag[DEPTH-1];

endmodule