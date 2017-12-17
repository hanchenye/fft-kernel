//////////////////////////////////////////////////
//
// NOTE:
// 1. Data arranger delay is 64 cycles
//
//////////////////////////////////////////////////

module dif_radix2_ctrl
#(
    parameter FFT_NUM = 6,
    parameter TM_DELAY = 1,
    parameter DA_DELAY = 64
)(
    input wire                clk,
    input wire                rst_n,
    input wire                din_valid,
    output reg                dout_valid,
    output reg                halt_ctrl,

    output wire [FFT_NUM-1:0] pe_mux_ctrl,
    output wire [1:0]         pe5_tm8_ctrl,
    output wire               pe4_tm4_ctrl,
    output wire [1:0]         pe2_tm8_ctrl,
    output wire               pe1_tm4_ctrl,

    output reg  [7:0]         da_wen_ctrl,
    output reg  [7:0]         da_ren_ctrl,
    output reg  [2:0]         da_waddr_ctrl,
    output reg  [2:0]         da_raddr_ctrl,

    output wire [5:0]         tm64_ctrl
);

localparam IDLE  = 4'b0000,
           FLUSH = 4'b0001,
           DELAY1 = 4'b0010,
           DELAY2 = 4'b0100,
           VALID = 4'b1000;

reg [3:0] state;
reg [FFT_NUM-1:0] cnt;
wire [FFT_NUM-1:0] delay_cnt;

//////////////////////////////////////////////////
//
// State Machine
//
//////////////////////////////////////////////////

always @(posedge clk)
begin
    if(!rst_n)
    begin
        cnt <= {FFT_NUM{1'b1}};
        halt_ctrl <= 0;
    end
    else if(din_valid)
    begin
        cnt <= cnt + 1;
        halt_ctrl <= 1;
    end
    else
    begin
        cnt <= cnt;
        halt_ctrl <= 0;
    end
end

always @(posedge clk)
begin
    if(!rst_n)
    begin
        state <= IDLE;
    end
    else if(din_valid)
    begin
        case(state)
            IDLE:
            begin
                state <= FLUSH;
            end

            FLUSH: //fill the pipeline
            begin
                if(cnt == {FFT_NUM{1'b1}})
                begin
                    state <= DELAY1;
                end
            end

            DELAY1: //for twiddle multiplier delay
            begin
                if(cnt == TM_DELAY - 1)
                begin
                    state <= DELAY2;
                end
            end

            DELAY2: //for data arranger delay
            begin
                if(cnt == TM_DELAY + DA_DELAY / 2 - 1)
                begin
                    state <= VALID;
                end
            end

            VALID: ; //pipeline is full

            default: ;
        endcase
    end
end

//////////////////////////////////////////////////
//
// Delay Control Logic
//
//////////////////////////////////////////////////

reg [FFT_NUM-1:0] tmp_cnt [TM_DELAY-1:0];

generate
    genvar i;
    for(i = 0; i < TM_DELAY - 1; i = i + 1)
    begin: delay
        always @(posedge clk)
        begin
            if(!rst_n)
            begin
                tmp_cnt[i] <= 0;
            end
            else
            begin
                tmp_cnt[i] <= tmp_cnt[i+1];
            end
        end
    end
endgenerate

always @(posedge clk)
begin
    if(!rst_n)
    begin
        tmp_cnt[TM_DELAY-1] <= {FFT_NUM{1'b1}};
    end
    else
    begin
        tmp_cnt[TM_DELAY-1] <= cnt;
    end
end

assign delay_cnt = tmp_cnt[0];

//always @(posedge clk)
//begin
//    if(!rst_n)
//    begin
//        delay_cnt <= {FFT_NUM{1'b1}};
//    end
//    else
//    begin
//        delay_cnt <= cnt;
//    end
//end

//////////////////////////////////////////////////
//
// PE Control Logic
//
//////////////////////////////////////////////////

assign pe_mux_ctrl = {cnt[5:3], delay_cnt[2:0]};
assign pe5_tm8_ctrl = cnt[4:3];
assign pe4_tm4_ctrl = cnt[3];
assign pe2_tm8_ctrl = delay_cnt[1:0];
assign pe1_tm4_ctrl = delay_cnt[0];

//////////////////////////////////////////////////
//
// DA Control Logic
//
//////////////////////////////////////////////////

always @(delay_cnt, halt_ctrl, state)
begin
    if(halt_ctrl && (state == DELAY2 || state == VALID))
    begin
        da_wen_ctrl = 1'b1 << {delay_cnt[5:3]};
        da_waddr_ctrl = {delay_cnt[2:0]};
    end
    else
    begin
        da_wen_ctrl = 0;
        da_waddr_ctrl = 0;
    end
end

always @(delay_cnt, halt_ctrl, state)
begin
    if(halt_ctrl && (state == VALID))
    begin
        da_ren_ctrl = 1'b1 << {{~{delay_cnt[5]}}, {delay_cnt[4:3]}};
        da_raddr_ctrl = {delay_cnt[2:0]};
    end
    else
    begin
        da_ren_ctrl = 0;
        da_raddr_ctrl = 0;
    end
end

//////////////////////////////////////////////////
//
// TM Control Logic
//
//////////////////////////////////////////////////

assign tm64_ctrl = cnt + 8;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        dout_valid <= 0;
    end
    else
    begin
        dout_valid <= |da_ren_ctrl;
    end
end

endmodule