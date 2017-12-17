module twiddle64_part1
#(
	parameter DATA_WIDTH = 14,
	parameter TWIDDLE = 0
)(
	input  wire signed [DATA_WIDTH-1:0] din_real,
	input  wire signed [DATA_WIDTH-1:0] din_imag,
	output wire signed [DATA_WIDTH:0]   tmp0_rere,
	output wire signed [DATA_WIDTH:0]   tmp0_imim,
	output wire signed [DATA_WIDTH:0]   tmp0_reim,
	output wire signed [DATA_WIDTH:0]   tmp0_imre,
	output wire signed [DATA_WIDTH:0]   tmp1_rere,
	output wire signed [DATA_WIDTH:0]   tmp1_imim,
	output wire signed [DATA_WIDTH:0]   tmp1_reim,
	output wire signed [DATA_WIDTH:0]   tmp1_imre
);

generate
	case(TWIDDLE)
		0:
		begin: const0
			assign tmp0_rere = 0;
			assign tmp0_imim = 0;
			assign tmp0_reim = 0;
			assign tmp0_imre = 0;
			
			assign tmp1_rere = din_real;
			assign tmp1_imim = 0;
			assign tmp1_reim = 0;
			assign tmp1_imre = din_imag;
		end
		
		1:
		begin: const1
			assign tmp0_rere = din_real - (din_real >>> 4);
			assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 6);
			
			assign tmp0_imim = (din_imag >>> 4) + (din_imag >>> 6);
			assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 6);
			
			assign tmp0_imre = din_imag - (din_imag >>> 4);
			assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 6);
			
			assign tmp0_reim = (din_real >>> 4) + (din_real >>> 6);
			assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 6);
		end
		
		2:
		begin: const2
			assign tmp0_rere = din_real + (din_real >>> 2);
			assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 6);
			
			assign tmp0_imim = (din_imag >>> 3) + (din_imag >>> 7);
			assign tmp1_imim = tmp0_imim - (tmp0_imim >>> 4);
			
			assign tmp0_imre = din_imag + (din_imag >>> 2);
			assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 6);
			
			assign tmp0_reim = (din_real >>> 3) + (din_real >>> 7);
			assign tmp1_reim = tmp0_reim - (tmp0_reim >>> 4);
		end
		
		3:
		begin: const3
			assign tmp0_rere = din_real - (din_real >>> 5);
			assign tmp1_rere = tmp0_rere + (tmp0_rere >>> 8);
			
			assign tmp0_imim = din_imag + (din_imag >>> 2);
			assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 5);
			
			assign tmp0_imre = din_imag - (din_imag >>> 5);
			assign tmp1_imre = tmp0_imre + (tmp0_imre >>> 8);
			
			assign tmp0_reim = din_real + (din_real >>> 2);
			assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 5);
		end
		
		4:
		begin: const4
			assign tmp0_rere = din_real - (din_real >>> 3);
			assign tmp1_rere = din_real + (tmp0_rere >>> 2);
			
			assign tmp0_imim = din_imag + (din_imag >>> 1);
            assign tmp1_imim = tmp0_imim - (tmp0_imim >>> 11);
			
			assign tmp0_imre = din_imag - (din_imag >>> 3);
			assign tmp1_imre = din_imag + (tmp0_imre >>> 2);
			
			assign tmp0_reim = din_real + (din_real >>> 1);
            assign tmp1_reim = tmp0_reim - (tmp0_reim >>> 11);
		end
		
		5:
		begin: const5
			assign tmp0_rere = din_real + (din_real >>> 7);
			assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 3);
			
			assign tmp0_imim = (din_imag >>> 1) + (din_imag >>> 3);
			assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 3);
			
			assign tmp0_imre = din_imag + (din_imag >>> 7);
			assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 3);
			
			assign tmp0_reim = (din_real >>> 1) + (din_real >>> 3);
			assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 3);
		end
		
		6:
		begin: const6
			assign tmp0_rere = din_real + (din_real >>> 2);
			assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 5);
			
			assign tmp0_imim = (din_imag >>> 1) + (din_imag >>> 7);
			assign tmp1_imim = tmp0_imim - (tmp0_imim >>> 3);
			
			assign tmp0_imre = din_imag + (din_imag >>> 2);
			assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 5);
			
			assign tmp0_reim = (din_real >>> 1) + (din_real >>> 7);
			assign tmp1_reim = tmp0_reim - (tmp0_reim >>> 3);
		end
		
		7:
		begin: const7
			assign tmp0_rere = din_real - (din_real >>> 5);
			assign tmp1_rere = tmp0_rere - (tmp0_rere >>> 4);
			
			assign tmp0_imim = din_imag + (din_imag >>> 4);
			assign tmp1_imim = din_imag + (tmp0_imim >>> 7);
			
			assign tmp0_imre = din_imag - (din_imag >>> 5);
			assign tmp1_imre = tmp0_imre - (tmp0_imre >>> 4);
			
			assign tmp0_reim = din_real + (din_real >>> 4);
			assign tmp1_reim = din_real + (tmp0_reim >>> 7);
		end
		
		8:
		begin: const8
			assign tmp0_rere = din_real + (din_real >>> 6);
			assign tmp1_rere = tmp0_rere + (tmp0_rere >>> 8);
			
			assign tmp0_imim = din_imag + (din_imag >>> 6);
			assign tmp1_imim = tmp0_imim + (tmp0_imim >>> 8);
			
			assign tmp0_imre = din_imag + (din_imag >>> 6);
			assign tmp1_imre = tmp0_imre + (tmp0_imre >>> 8);
			
			assign tmp0_reim = din_real + (din_real >>> 6);
			assign tmp1_reim = tmp0_reim + (tmp0_reim >>> 8);
		end
	endcase
endgenerate

endmodule