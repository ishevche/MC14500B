module ProgramMemory 
 #(parameter ADDR = 9,
	parameter WORD = 8,
	parameter SIZE = 2 ** ADDR)
  (input  logic [ADDR-1:0]	address,
	output logic [WORD-1:0]	data_out);

logic [WORD-1:0] data [0:SIZE-1] = '{SIZE{'0}};
	
always_comb data_out <= data[address];
	
endmodule