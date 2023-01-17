module Adder
  #(parameter WIDTH)
  (input logic req_l,
	output logic ack_l,
	output logic req_r,
	input logic ack_r,
	input logic [WIDTH - 1:0] input_pins,
	output logic [WIDTH - 1:0] output_pins);
	
	logic ack_l_reg = '0;
	always_comb ack_l <= ack_l_reg;
	
	logic req_r_reg = '0;
	always_comb req_r <= req_r_reg;
	
	logic r_req_l = '0;
	
	wire w_r_req_l = r_req_l ^ req_l;
	
	always_ff @(posedge w_r_req_l or posedge ack_r) begin
		if (ack_r)
			req_r_reg = '0;
		else begin
			r_req_l = ~r_req_l;
			if (r_req_l) begin
				ack_l_reg = '1;
			
				// do processing
				output_pins = input_pins + 1'b1;
				// end processing
				
				req_r_reg = '1;
			end else
				ack_l_reg = '0;
		end
	end
	
endmodule