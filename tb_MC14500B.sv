import instructions::instruction_t;

module MC14500B_tests();
	logic 			clk = 1'd0;
	logic 			rst;
	logic 			program_write;
	logic [16:0] 	program_cmd;
	instruction_t	opcode;
	
	MC14500B 		subject (clk,
									rst,
									program_write,
									program_cmd,
									opcode);
									
	always
		#(50) clk = ~clk;
endmodule