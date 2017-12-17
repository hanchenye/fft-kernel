//////////////////////////////////////////////////
//
// NOTE:
// 1. Data arranger delay is 64 cycles
//
//////////////////////////////////////////////////

module dif_radix2_ctrl
#(
    parameter FFT_NUM = 6,
    parameter TM_DELAY = 1
)(
    input wire        clk,
    input wire        rst_n,
    input wire        din_valid,
    output reg        dout_valid,
    output reg        halt_ctrl,

    output wire       pe5_mux_ctrl,
    output wire       pe4_mux_ctrl,
    output wire       pe3_mux_ctrl,
    output wire       pe2_mux_ctrl,
    output wire       pe1_mux_ctrl,
    output wire       pe0_mux_ctrl,
    
    output wire [1:0] pe5_tm8_ctrl,
    output wire [1:0] pe4_tm4_ctrl,
    output wire [1:0] pe2_tm8_ctrl,
    output wire [1:0] pe1_tm4_ctrl,

    output reg  [3:0] da_wen_ctrl,
    output reg  [3:0] da_ren_ctrl,
    output reg  [3:0] da_waddr_ctrl,
    output reg  [3:0] da_raddr_ctrl,

    output wire [5:0] tm64_ctrl
);

localparam IDLE   = 5'b00000,
           FLUSH  = 5'b00001,
           DELAY1 = 5'b00010,
           DELAY2 = 5'b00100,
           VALID1 = 5'b01000,
           VALID2 = 5'b10000;

reg  [4:0] state;
reg  [FFT_NUM-1:0] cnt;
wire [FFT_NUM-1:0] pe4_delay_cnt;
wire [FFT_NUM-1:0] pe3_delay_cnt;
wire [FFT_NUM-1:0] tm_delay_cnt;
wire [FFT_NUM-1:0] pe2_delay_cnt;
wire [FFT_NUM-1:0] pe1_delay_cnt;
wire [FFT_NUM-1:0] pe0_delay_cnt;

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

            DELAY1: //for pe & twiddle multiplier delay
            begin
                if(cnt == TM_DELAY + 5 - 1)
                begin
                    state <= DELAY2;
                end
            end

            DELAY2: //for data arranger delay
            begin
                if(cnt == TM_DELAY + 5 - 1)
                begin
                    state <= VALID1;
                end
            end

            VALID1: //ping valid
            begin
                if(cnt == TM_DELAY + 5 - 1)
                begin
                    state <= VALID2;
                end
            end

            VALID2: //pong valid
            begin
                if(cnt == TM_DELAY + 5 - 1)
                begin
                    state <= VALID1;
                end
            end

            default: ;
        endcase
    end
end

//////////////////////////////////////////////////
//
// Delay Control Logic
//
//////////////////////////////////////////////////

assign pe4_delay_cnt = cnt - 1;
assign pe3_delay_cnt = cnt - 2;
assign tm_delay_cnt = cnt - (2 + TM_DELAY);
assign pe2_delay_cnt = cnt - (3 + TM_DELAY);
assign pe1_delay_cnt = cnt - (4 + TM_DELAY);
assign pe0_delay_cnt = cnt - (5 + TM_DELAY);

//////////////////////////////////////////////////
//
// PE Control Logic
//
//////////////////////////////////////////////////

assign pe5_mux_ctrl = cnt[5];
assign pe4_mux_ctrl = pe4_delay_cnt[4];
assign pe3_mux_ctrl = pe3_delay_cnt[3];
assign pe2_mux_ctrl = pe2_delay_cnt[2];
assign pe1_mux_ctrl = pe1_delay_cnt[1];
assign pe0_mux_ctrl = pe0_delay_cnt[0];

assign pe5_tm8_ctrl = cnt[4:3];
assign pe4_tm4_ctrl = {0, pe4_delay_cnt[3]};
assign pe2_tm8_ctrl = pe2_delay_cnt[1:0];
assign pe1_tm4_ctrl = {0, pe1_delay_cnt[0]};

//////////////////////////////////////////////////
//
// DA Control Logic
//
//////////////////////////////////////////////////

wire [2:0] pe0_delay_cnt_coded;

da_coder da_coder_inst
(
    .origin(pe0_delay_cnt[2:0]),
    .coded(pe0_delay_cnt_coded)
);

always @(pe0_delay_cnt, halt_ctrl, state, pe0_delay_cnt_coded)
begin
    if(halt_ctrl && (state == DELAY2 || state == VALID2))
    begin
        da_wen_ctrl = pe0_delay_cnt[5:3];
        da_waddr_ctrl = pe0_delay_cnt_coded;
    end
    else if(halt_ctrl && (state == VALID1))
    begin
        da_wen_ctrl = pe0_delay_cnt_coded;
        da_waddr_ctrl = pe0_delay_cnt[5:3];
    end
    else
    begin
        da_wen_ctrl = 8;
        da_waddr_ctrl = 8;
    end
end

always @(pe0_delay_cnt, halt_ctrl, state, pe0_delay_cnt_coded)
begin
    if(halt_ctrl && (state == VALID2))
    begin
        da_ren_ctrl = pe0_delay_cnt[5:3];
        da_raddr_ctrl = pe0_delay_cnt_coded;
    end
    else if(halt_ctrl && (state == VALID1))
    begin
        da_ren_ctrl = pe0_delay_cnt_coded;
        da_raddr_ctrl = pe0_delay_cnt[5:3];
    end
    else
    begin
        da_ren_ctrl = 8;
        da_raddr_ctrl = 8;
    end
end

//////////////////////////////////////////////////
//
// TM Control Logic
//
//////////////////////////////////////////////////

assign tm64_ctrl = cnt + 5;

always @(posedge clk)
begin
    if(!rst_n)
    begin
        dout_valid <= 0;
    end
    else
    begin
        dout_valid <= !da_ren_ctrl[3];
    end
end

endmodule