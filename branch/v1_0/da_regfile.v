module da_regfile
#(
    parameter DATA_WIDTH = 17
)(
    input wire                  clk,
    input wire                  rst_n,
    input wire                  wen,
    input wire                  ren,
    input wire [2:0]            waddr,
    input wire [2:0]            raddr,
    input wire [DATA_WIDTH-1:0] din_real,
    input wire [DATA_WIDTH-1:0] din_imag,
    output reg [DATA_WIDTH-1:0] dout_real,
    output reg [DATA_WIDTH-1:0] dout_imag
);

reg [DATA_WIDTH-1:0] reg_real [7:0];
reg [DATA_WIDTH-1:0] reg_imag [7:0];

always @(posedge clk)
begin
    if(!rst_n)
    begin
        dout_real <= 0;
        dout_imag <= 0;
    end
    else if(ren)
    begin
        dout_real <= reg_real[raddr];
        dout_imag <= reg_imag[raddr];
    end
    else
    begin
        dout_real <= 0;
        dout_imag <= 0;
    end
end

always @(posedge clk)
begin
    if(!rst_n)
    begin
        reg_real[0] <= 0;
        reg_real[1] <= 0;
        reg_real[2] <= 0;
        reg_real[3] <= 0;
        reg_real[4] <= 0;
        reg_real[5] <= 0;
        reg_real[6] <= 0;
        reg_real[7] <= 0;
        reg_imag[0] <= 0;
        reg_imag[1] <= 0;
        reg_imag[2] <= 0;
        reg_imag[3] <= 0;
        reg_imag[4] <= 0;
        reg_imag[5] <= 0;
        reg_imag[6] <= 0;
        reg_imag[7] <= 0;
    end
    else if(wen)
    begin
        case(waddr)
        0:
        begin
            reg_real[0] <= din_real;
            reg_imag[0] <= din_imag;
        end

        1:
        begin
            reg_real[4] <= din_real;
            reg_imag[4] <= din_imag;
        end

        2:
        begin
            reg_real[2] <= din_real;
            reg_imag[2] <= din_imag;
        end

        3:
        begin
            reg_real[6] <= din_real;
            reg_imag[6] <= din_imag;
        end

        4:
        begin
            reg_real[1] <= din_real;
            reg_imag[1] <= din_imag;
        end

        5:
        begin
            reg_real[5] <= din_real;
            reg_imag[5] <= din_imag;
        end

        6:
        begin
            reg_real[3] <= din_real;
            reg_imag[3] <= din_imag;
        end

        7:
        begin
            reg_real[7] <= din_real;
            reg_imag[7] <= din_imag;
        end
        endcase
    end
end

endmodule