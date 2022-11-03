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
		$readmemh("out.txt", program_code);
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
