module twiddle64_part2
#(
	parameter DATA_WIDTH = 14,
	parameter TWIDDLE = 0
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	input  wire signed [DATA_WIDTH:0]   tmp0_rere,
	input  wire signed [DATA_WIDTH:0]   tmp0_imim,
	input  wire signed [DATA_WIDTH:0]   tmp0_reim,
	input  wire signed [DATA_WIDTH:0]   tmp0_imre,
	input  wire signed [DATA_WIDTH:0]   tmp1_rere,
	input  wire signed [DATA_WIDTH:0]   tmp1_imim,
	input  wire signed [DATA_WIDTH:0]   tmp1_reim,
	input  wire signed [DATA_WIDTH:0]   tmp1_imre,
	output wire signed [DATA_WIDTH-1:0] dout_rere,
	output wire signed [DATA_WIDTH-1:0] dout_imim,
	output wire signed [DATA_WIDTH-1:0] dout_reim,
	output wire signed [DATA_WIDTH-1:0] dout_imre
);

generate
	case(TWIDDLE)
		0:
		begin: const0
			assign dout_rere = tmp1_rere;
			assign dout_imim = tmp1_imim;
			assign dout_reim = tmp1_reim;
			assign dout_imre = tmp1_imre;
		end
		
		1:
		begin: const1
			assign dout_rere = tmp0_rere + (tmp1_rere >>> 4);
			assign dout_imim = tmp0_imim + (tmp1_imim >>> 2);
			assign dout_imre = tmp0_imre + (tmp1_imre >>> 4);
			assign dout_reim = tmp0_reim + (tmp1_reim >>> 2);
		end
		
		2:
		begin: const2
			assign dout_rere = din_real - (tmp1_rere >>> 6);
			assign dout_imim = tmp0_imim + (tmp1_imim >>> 1);
			assign dout_imre = din_imag - (tmp1_imre >>> 6);
			assign dout_reim = tmp0_reim + (tmp1_reim >>> 1);
		end
		
		3:
		begin: const3
			assign dout_rere = tmp1_rere - (din_real >>> 6);
			assign dout_imim = (din_imag >>> 2) + (tmp1_imim >>> 5);
			assign dout_imre = tmp1_imre - (din_imag >>> 6);
			assign dout_reim = (din_real >>> 2) + (tmp1_reim >>> 5);
		end
		
		4:
		begin: const4
			assign dout_rere = din_real - (tmp1_rere >>> 4);
			assign dout_imim = (din_imag >>> 7) + (tmp1_imim >>> 2);
			assign dout_imre = din_imag - (tmp1_imre >>> 4);
			assign dout_reim = (din_real >>> 7) + (tmp1_reim >>> 2);
		end
		
		5:
		begin: const5
			wire signed [DATA_WIDTH:0] tmp2_imim;
			wire signed [DATA_WIDTH:0] tmp2_reim;
			
			assign dout_rere = tmp1_rere + (din_real >>> 14);
			
			assign tmp2_imim = (tmp1_imim >>> 6) - tmp0_imim;
			assign dout_imim = (tmp2_imim >>> 2) + tmp0_imim;
			
			assign dout_imre = tmp1_imre + (din_imag >>> 14);
			
			assign tmp2_reim = (tmp1_reim >>> 6) - tmp0_reim;
			assign dout_reim = (tmp2_reim >>> 2) + tmp0_reim;
		end
		
		6:
		begin: const6
			wire signed [DATA_WIDTH:0] tmp2_rere;
			wire signed [DATA_WIDTH:0] tmp2_imre;
			
			assign tmp2_rere = tmp0_rere + (tmp1_rere >>> 4);
			assign dout_rere = (din_real >>> 1) + (tmp2_rere >>> 2);
			
			assign dout_imim = (din_imag >>> 1) + (tmp1_imim >>> 3);
			
			assign tmp2_imre = tmp0_imre + (tmp1_imre >>> 4);
			assign dout_imre = (din_imag >>> 1) + (tmp2_imre >>> 2);
			
			assign dout_reim = (din_real >>> 1) + (tmp1_reim >>> 3);
		end
		
		7:
		begin: const7
			wire signed [DATA_WIDTH:0] tmp2_imim;
			wire signed [DATA_WIDTH:0] tmp2_reim;
			
			assign dout_rere = din_real - (tmp1_rere >>> 2);
			
			assign tmp2_imim = tmp1_imim + (tmp1_imim >>> 3);
			assign dout_imim = tmp2_imim - (din_imag >>> 1);
			
			assign dout_imre = din_imag - (tmp1_imre >>> 2);
			
			assign tmp2_reim = tmp1_reim + (tmp1_reim >>> 3);
			assign dout_reim = tmp2_reim - (din_real >>> 1);
		end
		
		8:
		begin: const8
			wire signed [DATA_WIDTH:0] tmp2_rere;
			wire signed [DATA_WIDTH:0] tmp2_imim;
			wire signed [DATA_WIDTH:0] tmp2_imre;
			wire signed [DATA_WIDTH:0] tmp2_reim;

			assign tmp2_rere = (din_real >>> 4) + (din_real >>> 2);
			assign dout_rere = tmp1_rere - tmp2_rere;

			assign tmp2_imim = (din_imag >>> 4) + (din_imag >>> 2);
			assign dout_imim = tmp1_imim - tmp2_imim;

			assign tmp2_imre = (din_imag >>> 4) + (din_imag >>> 2);
			assign dout_imre = tmp1_imre - tmp2_imre;

			assign tmp2_reim = (din_real >>> 4) + (din_real >>> 2);
			assign dout_reim = tmp1_reim - tmp2_reim;
		end
	endcase
endgenerate

endmodule