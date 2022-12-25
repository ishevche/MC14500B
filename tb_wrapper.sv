import instructions::*;

module Wrapper_tests 
  #(parameter ADDR_WIDTH = 12,
    parameter INPUT_SIZE = 5,
    parameter OUTPUT_SIZE = 5) ();
  
	logic clk = '0;
	logic reset = '1;
  logic [INPUT_SIZE - 1:0] input_pins = '0;
  logic [OUTPUT_SIZE - 1:0] output_pins;
 
	Wrapper #(.ADDR_WIDTH(ADDR_WIDTH),
            .INPUT_SIZE(INPUT_SIZE),
            .OUTPUT_SIZE(OUTPUT_SIZE)) wrapper (
    clk,
    reset,
    input_pins,
    output_pins);
                                      
	always
		#(50) clk = ~clk;
    
  initial begin
    #(1700) $display(output_pins);
  end
endmodule
