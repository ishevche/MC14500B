module MCM7641 (
	input logic [8:0] address,
	input logic cs1,
	input logic cs2,
	input logic cs3,
	input logic cs4,
	output logic [7:0] out_data
);

logic [127:0] data [0:31] = '{'0};

endmodule