module RAM 
		#(parameter WORD = 1, 
		  parameter SIZE_LOG = 8,
		  parameter SIZE = 2 ** SIZE_LOG)
		(input logic 						clk,
		 input logic 						read,
		 input logic 						write,
		 input logic [SIZE_LOG-1:0]	address,
		 input logic [WORD-1:0]			data_in,
		 output logic [WORD-1:0]		data_out
		);
	
	logic [WORD-1:0] ram [0:SIZE-1];
	
	always @(posedge clk) begin
		if (write)
			ram[address] <= data_in;
		if (read)
			data_out <= ram[address];
	end
endmodule
