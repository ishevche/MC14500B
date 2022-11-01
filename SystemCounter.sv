module SystemCounter 
		# (parameter SIZE_LOG = 12)
		(input logic 	clk,
		 input logic 	write,
		 input logic 	address_in,
		 output logic 	address_out);
		 
	logic [SIZE_LOG-1:0] counter;
	
	assign address_out = counter;
	
	always @(posedge clk) begin
		if (write)
			counter <= address_in;
		else 
			counter += 1;
	end
endmodule