module number_test();

reg signed [9:0] da;
reg signed [9:0] db;
wire signed [15:0] dout;

initial
begin
	da = 100;
	db = -100;
end

sub sub_inst
(
	.da(da),
	.db(db),
	.dout(dout)
);

endmodule


module sub
(
	input wire signed [9:0] da,
	input wire signed [9:0] db,
	output wire signed [15:0] dout
);

assign dout = db - da;

endmodule