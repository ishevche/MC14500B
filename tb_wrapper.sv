import instructions::*;

module Wrapper_tests 
  #(parameter ADDR_WIDTH = 8,
    parameter INPUT_SIZE = 5,
    parameter OUTPUT_SIZE = 5) ();
  
	logic clk = '0;
	logic reset = '0;
  logic [INPUT_SIZE - 1:0] input_pins = '0;
  logic [OUTPUT_SIZE - 1:0] output_pins;
 
	Wrapper #(.ADDR_WIDTH(ADDR_WIDTH),
            .INPUT_SIZE(INPUT_SIZE),
            .OUTPUT_SIZE(OUTPUT_SIZE)) wrapper (
    .clk(clk),
    .reset(reset),
    .input_pins(input_pins),
    .output_pins(output_pins),
    .program_write('0),
    .program_cmd('0));
                                      
	always
		#(50) clk = ~clk;
    
  initial begin
    #(25) reset = '1;
    #(50) reset = '0;
    #(1700) $display(output_pins);
  end
endmodule
