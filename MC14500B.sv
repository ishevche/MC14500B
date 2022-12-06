import instructions::instruction_t;
module MC14500B
		#(parameter ADDR = 8,
		  parameter CODE = 4,
		  parameter WORD = ADDR+CODE)
		(input logic 				clk,
		 input logic 				rst,
		 input logic 				program_write,
		 input logic [WORD-1:0]	program_cmd, 
		 output instruction_t	opcode);
	
	logic [ADDR-1:0] 			counter = '0;
	logic [WORD-1:0]		 	cmd = '0;
	logic [ADDR-1:0] 			address = '0;
	logic [ADDR-1:0] 			address_copy = '0;
	logic 						JMP_FLAG = '0;
	logic			 				RTN_FLAG = '0;
	logic 						FLAG_O = '0;
	logic			 				FLAG_F = '0;
	logic 						data_out = '0;
	logic 						data_write = '0;
	logic							rr_out = '0;
	logic	 						data_in = '0;
	logic	 						data_from_ram = '0;
	
	always_comb opcode <= instruction_t'(cmd[WORD-1:ADDR]);
	always_comb data_in = address_copy == '1 ? rr_out : data_from_ram;
	always_comb address = cmd[ADDR-1:0];
	
	RAM #(.SIZE_LOG(ADDR)) 			ram 	(!data_write, 
															data_write, 
															address_copy, 
															data_out, 
															data_from_ram);
	ROM #(.WORD(WORD), .SIZE_LOG(ADDR))	rom 	(!program_write,
															program_write,
															counter, 
															program_cmd, 
															cmd);
	ProgramCounter #(.SIZE_LOG(ADDR))	cnt	(!clk, 
															rst,
															JMP_FLAG, 
															address, 
															counter);
	ICU 											icu	(clk, 
															data_in, 
															rst, 
															opcode, 
															data_write, 
															data_out, 
															JMP_FLAG, 
															RTN_FLAG, 
															FLAG_O, 
															FLAG_F, 
															rr_out);
															
	always_ff @(negedge clk)
		address_copy <= address;
	
endmodule
