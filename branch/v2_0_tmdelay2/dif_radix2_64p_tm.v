//////////////////////////////////////////////////
//
// NOTE:
// twiddle multiplier
//
//////////////////////////////////////////////////

module dif_radix2_64p_tm
#(
    parameter DATA_WIDTH_IN = 10,
    parameter DATA_WIDTH_OUT = DATA_WIDTH_IN + 1
)(
    input wire                      clk,
    input wire                      rst_n,
    input wire                      halt_ctrl,
    input wire [5:0]                tm64_ctrl,
    input wire [DATA_WIDTH_IN-1:0]  din_real,
    input wire [DATA_WIDTH_IN-1:0]  din_imag,
    output reg [DATA_WIDTH_OUT-1:0] dout_real,
    output reg [DATA_WIDTH_OUT-1:0] dout_imag
);

localparam NOTOUCH  = 7'b000_0000,
           ORIGIN   = 7'b000_0001,
           SW_RN_IN = 7'b000_0010,
           SW_RN    = 7'b000_0100,
           SW_IN    = 7'b000_1000,
           SW       = 7'b001_0000,
           RN_IN    = 7'b010_0000,
           RN       = 7'b100_0000;

reg [6:0] cal_type;
reg [3:0] twiddle;

always @(tm64_ctrl)
begin
    casex(tm64_ctrl)
        6'b000xxx: twiddle = 0;
        6'bxxx000: twiddle = 0;

        // column 4
        6'b001001: twiddle = 4;
        6'b001010: twiddle = 8;
        6'b001011: twiddle = 4;
        6'b001100: twiddle = 0;
        6'b001101: twiddle = 4;
        6'b001110: twiddle = 8;
        6'b001111: twiddle = 4;

        // column 2
        6'b010001: twiddle = 2;
        6'b010010: twiddle = 4;
        6'b010011: twiddle = 6;
        6'b010100: twiddle = 8;
        6'b010101: twiddle = 6;
        6'b010110: twiddle = 4;
        6'b010111: twiddle = 2;

        // column 6
        6'b011001: twiddle = 6;
        6'b011010: twiddle = 4;
        6'b011011: twiddle = 2;
        6'b011100: twiddle = 8;
        6'b011101: twiddle = 2;
        6'b011110: twiddle = 4;
        6'b011111: twiddle = 6;

        // column 1
        6'b100001: twiddle = 1;
        6'b100010: twiddle = 2;
        6'b100011: twiddle = 3;
        6'b100100: twiddle = 4;
        6'b100101: twiddle = 5;
        6'b100110: twiddle = 6;
        6'b100111: twiddle = 7;

        // column 5
        6'b101001: twiddle = 5;
        6'b101010: twiddle = 6;
        6'b101011: twiddle = 1;
        6'b101100: twiddle = 4;
        6'b101101: twiddle = 7;
        6'b101110: twiddle = 2;
        6'b101111: twiddle = 3;

        // column 3
        6'b110001: twiddle = 3;
        6'b110010: twiddle = 6;
        6'b110011: twiddle = 7;
        6'b110100: twiddle = 4;
        6'b110101: twiddle = 1;
        6'b110110: twiddle = 2;
        6'b110111: twiddle = 5;

        // column 7
        6'b111001: twiddle = 7;
        6'b111010: twiddle = 2;
        6'b111011: twiddle = 5;
        6'b111100: twiddle = 4;
        6'b111101: twiddle = 3;
        6'b111110: twiddle = 6;
        6'b111111: twiddle = 1;

        default:   twiddle = 0;
  endcase
end

always @(tm64_ctrl)
begin
    casex(tm64_ctrl)
        6'b000xxx: cal_type = NOTOUCH;
        6'bxxx000: cal_type = NOTOUCH;
        6'b100xxx: cal_type = ORIGIN;
        6'bxxx001: cal_type = ORIGIN;

        // column 4
        6'b001010: cal_type = ORIGIN;
        6'b001011: cal_type = SW_RN_IN;
        6'b001100: cal_type = SW_RN_IN;
        6'b001101: cal_type = SW_IN;
        6'b001110: cal_type = SW_IN;
        6'b001111: cal_type = RN;

        // column 2
        6'b010010: cal_type = ORIGIN;
        6'b010011: cal_type = ORIGIN;
        6'b010100: cal_type = ORIGIN;
        6'b010101: cal_type = SW_RN_IN;
        6'b010110: cal_type = SW_RN_IN;
        6'b010111: cal_type = SW_RN_IN;

        // column 6
        6'b011010: cal_type = SW_RN_IN;
        6'b011011: cal_type = SW_IN;
        6'b011100: cal_type = SW_IN;
        6'b011101: cal_type = RN;
        6'b011110: cal_type = RN_IN;
        6'b011111: cal_type = SW;

        // column 5
        6'b101010: cal_type = SW_RN_IN;
        6'b101011: cal_type = SW_RN_IN;
        6'b101100: cal_type = SW_IN;
        6'b101101: cal_type = RN;
        6'b101110: cal_type = RN;
        6'b101111: cal_type = RN_IN;

        // column 3
        6'b110010: cal_type = ORIGIN;
        6'b110011: cal_type = SW_RN_IN;
        6'b110100: cal_type = SW_RN_IN;
        6'b110101: cal_type = SW_RN_IN;
        6'b110110: cal_type = SW_IN;
        6'b110111: cal_type = SW_IN;

        // column 7
        6'b111010: cal_type = SW_RN_IN;
        6'b111011: cal_type = SW_IN;
        6'b111100: cal_type = RN;
        6'b111101: cal_type = RN_IN;
        6'b111110: cal_type = SW;
        6'b111111: cal_type = SW_RN;

        default:   cal_type = NOTOUCH;
    endcase 
end

//////////////////////////////////////////////////
//
// Interconnect wires define
//
//////////////////////////////////////////////////

reg [6:0] delay_cal_type;
reg [3:0] delay_twiddle;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        delay_cal_type <= 0;
        delay_twiddle <= 0;
    end
    else if(halt_ctrl)
    begin
        delay_cal_type <= cal_type;
        delay_twiddle <= twiddle;
    end
    else
    begin
        delay_cal_type <= delay_cal_type;
        delay_twiddle <= delay_twiddle;
    end
end

/* for tm part1 input & output */
wire signed [DATA_WIDTH_IN-1:0] tw_din_real [8:0];
wire signed [DATA_WIDTH_IN-1:0] tw_din_imag [8:0];

wire signed [DATA_WIDTH_IN:0]   tw_tmp0_rere [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp0_imim [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp0_reim [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp0_imre [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp1_rere [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp1_imim [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp1_reim [8:0];
wire signed [DATA_WIDTH_IN:0]   tw_tmp1_imre [8:0];

/* for tm part2 input & output */
reg  signed [DATA_WIDTH_IN-1:0] reg_din_real [8:0];
reg  signed [DATA_WIDTH_IN-1:0] reg_din_imag [8:0];

reg  signed [DATA_WIDTH_IN:0]   reg_tmp0_rere;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp0_imim;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp0_reim;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp0_imre;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp1_rere;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp1_imim;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp1_reim;
reg  signed [DATA_WIDTH_IN:0]   reg_tmp1_imre;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        reg_tmp0_rere = 0;
        reg_tmp0_imim = 0;
        reg_tmp0_reim = 0;
        reg_tmp0_imre = 0;
        reg_tmp1_rere = 0;
        reg_tmp1_imim = 0;
        reg_tmp1_reim = 0;
        reg_tmp1_imre = 0;
    end
    else if(halt_ctrl)
    begin
        reg_tmp0_rere <= tw_tmp0_rere[twiddle];
        reg_tmp0_imim <= tw_tmp0_imim[twiddle];
        reg_tmp0_reim <= tw_tmp0_reim[twiddle];
        reg_tmp0_imre <= tw_tmp0_imre[twiddle];
        reg_tmp1_rere <= tw_tmp1_rere[twiddle];
        reg_tmp1_imim <= tw_tmp1_imim[twiddle];
        reg_tmp1_reim <= tw_tmp1_reim[twiddle];
        reg_tmp1_imre <= tw_tmp1_imre[twiddle];
    end
    else
    begin
        reg_tmp0_rere <= reg_tmp0_rere;
        reg_tmp0_imim <= reg_tmp0_imim;
        reg_tmp0_reim <= reg_tmp0_reim;
        reg_tmp0_imre <= reg_tmp0_imre;
        reg_tmp1_rere <= reg_tmp1_rere;
        reg_tmp1_imim <= reg_tmp1_imim;
        reg_tmp1_reim <= reg_tmp1_reim;
        reg_tmp1_imre <= reg_tmp1_imre;
    end
end

/* for top output */
wire signed [DATA_WIDTH_IN-1:0] tw_dout_rere [8:0];
wire signed [DATA_WIDTH_IN-1:0] tw_dout_imim [8:0];
wire signed [DATA_WIDTH_IN-1:0] tw_dout_reim [8:0];
wire signed [DATA_WIDTH_IN-1:0] tw_dout_imre [8:0];

wire signed [DATA_WIDTH_IN-1:0] const_dout_rere;
wire signed [DATA_WIDTH_IN-1:0] const_dout_imim;
wire signed [DATA_WIDTH_IN-1:0] const_dout_reim;
wire signed [DATA_WIDTH_IN-1:0] const_dout_imre;

assign const_dout_rere = tw_dout_rere[delay_twiddle];
assign const_dout_imim = tw_dout_imim[delay_twiddle];
assign const_dout_reim = tw_dout_reim[delay_twiddle];
assign const_dout_imre = tw_dout_imre[delay_twiddle];

//////////////////////////////////////////////////
//
// const twiddle multiply
//
//////////////////////////////////////////////////

generate
    genvar i;
    for(i = 0; i < 9; i = i + 1)
    begin: gen
        assign tw_din_real[i] = (twiddle == i) ? din_real : 0;
        assign tw_din_imag[i] = (twiddle == i) ? din_imag : 0;

        always @(posedge clk)
        begin
            if(!rst_n)
            begin
                reg_din_real[i] <= 0;
                reg_din_imag[i] <= 0;
            end
            else if(halt_ctrl)
            begin
                reg_din_real[i] <= tw_din_real[i];
                reg_din_imag[i] <= tw_din_imag[i];
            end
            else
            begin
                reg_din_real[i] <= reg_din_real[i];
                reg_din_imag[i] <= reg_din_imag[i];
            end
        end

        twiddle64_part1
        #(
            .DATA_WIDTH(DATA_WIDTH_IN),
            .TWIDDLE(i)
        ) twiddle64_part1 (
            .din_real(tw_din_real[i]),
            .din_imag(tw_din_imag[i]),
            .tmp0_rere(tw_tmp0_rere[i]),
            .tmp0_imim(tw_tmp0_imim[i]),
            .tmp0_reim(tw_tmp0_reim[i]),
            .tmp0_imre(tw_tmp0_imre[i]),
            .tmp1_rere(tw_tmp1_rere[i]),
            .tmp1_imim(tw_tmp1_imim[i]),
            .tmp1_reim(tw_tmp1_reim[i]),
            .tmp1_imre(tw_tmp1_imre[i])
        );
        
        twiddle64_part2
        #(
            .DATA_WIDTH(DATA_WIDTH_IN),
            .TWIDDLE(i)
        ) twiddle64_part2 (
            .din_real(reg_din_real[i]),
            .din_imag(reg_din_imag[i]),
            .tmp0_rere(reg_tmp0_rere),
            .tmp0_imim(reg_tmp0_imim),
            .tmp0_reim(reg_tmp0_reim),
            .tmp0_imre(reg_tmp0_imre),
            .tmp1_rere(reg_tmp1_rere),
            .tmp1_imim(reg_tmp1_imim),
            .tmp1_reim(reg_tmp1_reim),
            .tmp1_imre(reg_tmp1_imre),
            .dout_rere(tw_dout_rere[i]),
            .dout_imim(tw_dout_imim[i]),
            .dout_reim(tw_dout_reim[i]),
            .dout_imre(tw_dout_imre[i])
        );
    end
endgenerate


always @(posedge clk)
begin
    if(!rst_n)
    begin
        dout_real <= 0;
        dout_imag <= 0;
    end
    else if(halt_ctrl)
    begin
        case(delay_cal_type)
            NOTOUCH:
            begin
                dout_real <= const_dout_rere;
                dout_imag <= const_dout_imre;
            end
            ORIGIN:
            begin
                dout_real <= const_dout_rere + const_dout_imim;
                dout_imag <= const_dout_imre - const_dout_reim;
            end

            SW_RN_IN:
            begin
                dout_real <= const_dout_imre + const_dout_reim;
                dout_imag <= const_dout_imim - const_dout_rere;
            end

            SW_RN:
            begin
                dout_real <= const_dout_reim - const_dout_imre;
                dout_imag <= const_dout_rere + const_dout_imim;
            end

            SW_IN:
            begin
                dout_real <= const_dout_imre - const_dout_reim;
                dout_imag <= - const_dout_imim - const_dout_rere;
            end

            SW:
            begin
                dout_real <= - const_dout_reim - const_dout_imre;
                dout_imag <= const_dout_rere - const_dout_imim;
            end

            RN_IN:
            begin
                dout_real <= - const_dout_imim - const_dout_rere;
                dout_imag <= const_dout_reim - const_dout_imre;
            end

            RN:
            begin
                dout_real <= const_dout_imim - const_dout_rere;
                dout_imag <= - const_dout_reim - const_dout_imre;
            end
        endcase
    end
    else
    begin
        dout_real <= dout_real;
        dout_imag <= dout_imag;
    end
end

endmodule