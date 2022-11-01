module ProgramCounter 
		# (parameter SIZE_LOG = 12)
		(input logic 							clk,
		 input logic 							write,
		 input logic [SIZE_LOG-1:0]		address_in,
		 output logic [SIZE_LOG-1:0]		address_out);
		 
	logic [SIZE_LOG-1:0] counter;
	
	always_comb address_out <= counter;
	
	always @(posedge clk) begin
		if (write)
			counter <= address_in;
		else 
			counter += 1'd1;
	end
endmodule