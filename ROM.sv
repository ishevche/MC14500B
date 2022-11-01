module ROM
		#(parameter WORD = 16, 
		  parameter SIZE_LOG = 12,
		  parameter SIZE = 2 ** SIZE_LOG)
		(input logic 						clk,
		 input logic [SIZE_LOG-1:0]	address,
		 output logic [WORD-1:0]		data_out
		);
	
	logic [WORD-1:0] ram [SIZE-1:0];
	
	always @(posedge clk) begin
		data_out <= ram[address];
	end
endmodule