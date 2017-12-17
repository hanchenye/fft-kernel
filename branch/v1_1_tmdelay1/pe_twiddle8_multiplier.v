module twiddle8_multiplier
#(
    parameter DATA_WIDTH_IN = 10,
    parameter DATA_WIDTH_OUT = DATA_WIDTH_IN + 1,
    parameter TWIDDLE_RANK = 8
)(
    input wire        [1:0]                twiddle,
    input wire signed [DATA_WIDTH_IN-1:0]  din_real,
    input wire signed [DATA_WIDTH_IN-1:0]  din_imag,
    output reg signed [DATA_WIDTH_OUT-1:0] dout_real,
    output reg signed [DATA_WIDTH_OUT-1:0] dout_imag
);

generate
    case(TWIDDLE_RANK)
        2:
        begin:rank2
            always @(din_real, din_imag)
            begin
                dout_real = din_real;
                dout_imag = din_imag;
            end
        end

        4:
        begin: rank4
            always @(twiddle, din_real, din_imag)
            begin
                if(twiddle == 1)
                begin
                    dout_real = din_imag;
                    dout_imag = - din_real;
                end
                else
                begin
                    dout_real = din_real;
                    dout_imag = din_imag;
                end
            end
        end

        8:
        begin: rank8
            reg signed [DATA_WIDTH_OUT-1:0] const_din_real;
            reg signed [DATA_WIDTH_OUT-1:0] const_din_imag;
            wire signed [DATA_WIDTH_OUT-1:0] const_dout_real;
            wire signed [DATA_WIDTH_OUT-1:0] const_dout_imag;

            twiddle_45degree
            #(
                .DATA_WIDTH(DATA_WIDTH_OUT)
            ) twiddle_45degree (
                .din_real(const_din_real),
                .din_imag(const_din_imag),
                .dout_real(const_dout_real),
                .dout_imag(const_dout_imag)
            );

            always @(twiddle, din_real, din_imag, const_dout_real, const_dout_imag)
            begin
                if(twiddle == 3)
                begin
                    const_din_real = din_imag - din_real;
                    const_din_imag = - din_imag - din_real;
                    dout_real = const_dout_real;
                    dout_imag = const_dout_imag;
                end
                else if(twiddle == 2)
                begin
                    dout_real = din_imag;
                    dout_imag = - din_real;
                end
                else if(twiddle == 1)
                begin
                    const_din_real = din_real + din_imag;
                    const_din_imag = din_imag - din_real;
                    dout_real = const_dout_real;
                    dout_imag = const_dout_imag;
                end
                else
                begin
                    dout_real = din_real;
                    dout_imag = din_imag;
                end
            end
        end
    endcase
endgenerate

endmodule


module twiddle_45degree
#(
    parameter DATA_WIDTH = 10
)(
    input  wire signed [DATA_WIDTH-1:0] din_real,
    input  wire signed [DATA_WIDTH-1:0] din_imag,
    output wire signed [DATA_WIDTH-1:0] dout_real,
    output wire signed [DATA_WIDTH-1:0] dout_imag
);

wire signed [DATA_WIDTH-1:0] tmp1_real;
wire signed [DATA_WIDTH-1:0] tmp2_real;
assign tmp1_real = din_real - (din_real >>> 4);
assign tmp2_real = tmp1_real + (tmp1_real >>> 2);
assign dout_real = din_real - (tmp2_real >>> 2);

wire signed [DATA_WIDTH-1:0] tmp1_imag;
wire signed [DATA_WIDTH-1:0] tmp2_imag;
assign tmp1_imag = din_imag - (din_imag >>> 4);
assign tmp2_imag = tmp1_imag + (tmp1_imag >>> 2);
assign dout_imag = din_imag - (tmp2_imag >>> 2);

endmodule