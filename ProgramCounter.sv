module ProgramCounter 
		# (parameter SIZE_LOG = 8)
		(input logic 							clk,
		 input logic							rst,
		 input logic 							write,
		 input logic [SIZE_LOG-1:0]		address_in,
		 output logic [SIZE_LOG-1:0]		address_out);
		 
	logic [SIZE_LOG-1:0] counter = '0;
	
	always_comb address_out <= counter;
	
	always @(negedge clk) begin
		if (rst)
			counter = '0;
		else if (write)
			counter <= address_in;
		else 
			counter += 1'd1;
	end
endmodule
