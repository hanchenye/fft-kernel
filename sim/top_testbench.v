module top_testbench();

reg               start;
reg               stop;

reg               clk;
reg               rst_n;
reg signed [9:0]  din_re;
reg signed [9:0]  din_im;
reg               din_valid;

wire signed [16:0] dout_re;
wire signed [16:0] dout_im;
wire               dout_valid;

always
begin
	#5 clk = ~clk;
end

always @(posedge clk)
begin
    if (!rst_n)
    begin
        din_re <= 0;
        din_im <= 0;
        din_valid <= 0;
    end
    else if(start)
    begin
        din_re <= 100;
        din_im <= -100;
        din_valid <= 1;
    end
    else if(!stop)
    begin
        if (din_re == 163)
        begin
            din_re <= 100;
            din_im <= -100;
            din_valid <= 1;
        end
        else
        begin
            din_re <= din_re + 1;
            din_im <= din_im - 1;
            din_valid <= 1;
        end
    end
    else
    begin
        din_re <= din_re;
        din_im <= din_im;
        din_valid <= 0;
    end
end
        

initial
begin
	clk = 1;
	rst_n = 1;
	din_re = 0;
	din_im = 0;
	din_valid = 0;
	
	start = 0;
	stop = 1;

	#20 rst_n = 0;
	#20 rst_n = 1;

	#20 start <= 1;
	    stop <= 0;
	#10 start <= 0;
	
	#500 stop <= 1;
	#50 stop <= 0;
	
	#500 stop <= 1;
	#10 stop <= 0;
	#10 stop <= 1;
	#10 stop <= 0;
end

dif_radix2_64p_fft
#() fft (
	.clk(clk),
	.rst_n(rst_n),
	.din_re(din_re),
	.din_im(din_im),
	.din_valid(din_valid),
	.dout_re(dout_re),
	.dout_im(dout_im),
	.dout_valid(dout_valid)
);

endmodule