module Wrapper
  #(parameter WIDTH = 25,
	 parameter DISPLAY_WIDTH = 8)
  (input logic start_btn,
	output logic [DISPLAY_WIDTH - 1:0] output_pins);
  
  logic req1;
  logic ack1;
  logic req2;
  logic ack2;
  logic req3;
  logic ack3;
  
  logic [WIDTH - 1:0] cnt1;
  logic [WIDTH - 1:0] cnt2;
  logic [WIDTH - 1:0] cnt3;

  logic start_reg = '0;
  logic start_reg_use = '1;
  
  always_ff @(negedge start_btn) begin
	start_reg <= '1;
  end
  
  always_ff @(posedge ack1) begin
	start_reg_use <= '0;
  end
  
  logic req1_trace = '0;
  always_comb req1_trace = req1_trace | req1;
  
  logic req2_trace = '0;
  always_comb req2_trace = req2_trace | req2;
  
  logic req3_trace = '0;
  always_comb req3_trace = req3_trace | req3;
  
  logic ack1_trace = '0;
  always_comb ack1_trace = ack1_trace | ack1;
  
  logic ack2_trace = '0;
  always_comb ack2_trace = ack2_trace | ack2;
  
  logic ack3_trace = '0;
  always_comb ack3_trace = ack3_trace | ack3;

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
		.req_r(req3),
		.ack_r(ack3),
		.input_pins(cnt2),
		.output_pins(cnt3));
	
	Adder #(.WIDTH(WIDTH)) adder3 (
		.req_l(req3),
		.ack_l(ack3),
		.req_r(req1),
		.ack_r(ack1),
		.input_pins(cnt3),
		.output_pins(cnt1));
	
	/*always_comb output_pins[0] <= req1_trace;
	always_comb output_pins[1] <= req2_trace;
	always_comb output_pins[2] <= req3_trace;
	always_comb output_pins[3] <= ack1_trace;
	always_comb output_pins[4] <= ack2_trace;
	always_comb output_pins[5] <= ack3_trace;*/
	
	logic req1_posedge_trace = '0;
	
	always_ff @(posedge req1)
		req1_posedge_trace <= '1;
	always_comb output_pins[0] <= req1_posedge_trace;
	always_comb output_pins[1] <= req1;
	always_comb output_pins[2] <= req1_trace;
	always_comb output_pins[3] <= start_reg2_use;

endmodule