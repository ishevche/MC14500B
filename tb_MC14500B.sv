import instructions::instruction_t;

module MC14500B_tests();
	logic clk = '0;
	logic rst = '1;
	
	MC14500B subject (clk,
                    rst,
                    '0,
                    '0);
									
	always
		#(50) clk = ~clk;
endmodule
