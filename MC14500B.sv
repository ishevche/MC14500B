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
	
	logic [ADDR-1:0] 			counter;
	logic [WORD-1:0]		 	cmd;
	logic [ADDR-1:0] 			address;
	logic [ADDR-1:0] 			address_copy;
	logic 						JMP_FLAG;
	logic			 				RTN_FLAG;
	logic 						FLAG_O;
	logic			 				FLAG_F;
	logic 						data_out;
	logic 						data_write;
	logic							rr_out;
	logic	 						data_in;
	logic	 						data_from_ram;
	
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
															
	always @(negedge clk)
		address_copy <= address;
	
endmodule
