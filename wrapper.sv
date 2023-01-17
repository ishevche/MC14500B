module Wrapper
  #(parameter WIDTH = 25,
	 parameter DISPLAY_WIDTH = 8)
  (input logic start_btn,
	output logic [DISPLAY_WIDTH - 1:0] output_pins);
  
  logic req1;
  logic ack1;
  logic req2;
  logic ack2;
  
  logic [WIDTH - 1:0] cnt1;
  logic [WIDTH - 1:0] cnt2;

  logic start_reg = '0;
  logic start_reg_use = '1;
  
  always_ff @(posedge start_btn) begin
	start_reg <= '1;
  end
  
  always_ff @(posedge ack1) begin
	start_reg_use <= '0;
  end

	Adder #(.WIDTH(WIDTH)) adder1 (
		.req_l(req1 | (start_reg & start_reg_use)),
		.ack_l(ack1),
		.req_r(req2),
		.ack_r(ack2),
		.input_pins(cnt1),
		.output_pins(cnt2));

	Adder #(.WIDTH(WIDTH)) adder2 (
		.req_l(req2),
		.ack_l(ack2),
		.req_r(req1),
		.ack_r(ack1),
		.input_pins(cnt2),
		.output_pins(cnt1));
	
	always_comb output_pins <= cnt1[7:0];

endmodule