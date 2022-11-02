import instructions::instruction_t;

module MC14500B_tests();
	logic 			clk = 1'd0;
	logic 			rst;
	logic 			program_write;
	logic [11:0] 	program_cmd;
	instruction_t	opcode;
	
	MC14500B 		subject (clk,
									rst,
									program_write,
									program_cmd,
									opcode);
									
	always
		#(50) clk = ~clk;
		
	logic [11:0] program_code [0:255];

	integer i;
	initial begin
		program_code[0] = 12'h6ff;
		program_code[1] = 12'hAff;
		program_code[2] = 12'hBff;
		program_code[3] = 12'h800;
		program_code[4] = 12'h700;
		program_code[5] = 12'h2ff;
		program_code[6] = 12'h800;
		program_code[7] = 12'h801;
		program_code[8] = 12'h802;
		program_code[9] = 12'hC04;
		#(20);
		rst = '1;
		#(50);
		rst = '0;
		for (i=0; i<10; i=i+1) begin
			program_cmd = program_code[i];
			program_write = '1;
			#(50) program_write = '0;
			#(50);
		end
		rst = '1;
		#(100) rst = '0;
	end
endmodule
