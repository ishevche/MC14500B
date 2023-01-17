module Wrapper_tests();

	logic start_btn = '0;
	logic [7:0] output_pins;
	
	Wrapper wrapper(start_btn, output_pins);
	
	initial begin
		#10 start_btn = '1;
	end
endmodule
