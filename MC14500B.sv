import instructions::instruction_t;
module MC14500B
		#(parameter ADDR = 12,
		  parameter CODE = 4,
		  parameter WORD = ADDR+CODE)
		(input logic 				clk, 
		 input logic 				rst,
		 input logic 				program_write,
		 input logic [WORD-1:0]	program_cmd, 
		 output instruction_t	opcode);
	
	wire [ADDR-1:0] 			counter;
	wire [WORD-1:0]		 	cmd;
	wire [ADDR-1:0] 			address;
	wire 							JMP_FLAG;
	wire			 				RTN_FLAG;
	wire 							FLAG_O;
	wire			 				FLAG_F;
	wire 							data;
	wire 							data_write;
	wire 							rr_out;
	
	
	RAM #(.SIZE_LOG(ADDR)) 					ram 	(clk, 
															!data_write, 
															data_write, 
															address, 
															data, 
															data);
	RAM #(.WORD(WORD), .SIZE_LOG(ADDR))	rom 	(clk, 
															!program_write, 
															program_write, 
															counter, 
															program_cmd, 
															cmd);
	ProgramCounter #(.SIZE_LOG(ADDR))	cnt	(clk, 
															JMP_FLAG, 
															address, 
															counter);
	ICU 											icu	(clk, 
															data, 
															rst, 
															opcode, 
															data_write, 
															data, 
															JMP_FLAG, 
															RTN_FLAG, 
															FLAG_O, 
															FLAG_F, 
															rr_out);
	
	always_comb opcode <= instruction_t'(cmd[ADDR+CODE-1:ADDR]);
	always_comb address <= cmd[ADDR-1:0];
	always_comb data <= address == -1 ? rr_out : data;
endmodule
	