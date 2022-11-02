module ROM 
		#(parameter WORD = 1, 
		  parameter SIZE_LOG = 8,
		  parameter SIZE = 2 ** SIZE_LOG)
		(input logic 						read,
		 input logic 						write,
		 input logic [SIZE_LOG-1:0]	address,
		 input logic [WORD-1:0]			data_in,
		 output logic [WORD-1:0]		data_out
		);
	
	logic [WORD-1:0] rom [0:SIZE-1];
	
	always_latch begin
		if (write) rom[address] = data_in;
		if (read)  data_out = rom[address];
	end
endmodule
