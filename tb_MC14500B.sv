import instructions::*;

module MC14500B_tests 
  #(parameter INPUT = 5,
    parameter OUTPUT = 5) ();
	logic clk = '0;
	logic rst = '1;
  logic [INPUT - 1:0]  input_pins  = '0;
  logic [OUTPUT - 1:0] output_pins;
	
	MC14500B #(.INPUT(INPUT),
             .OUTPUT(OUTPUT)) subject (clk,
                                  rst,
                                  '0,
                                  '0,
                                  input_pins,
                                  output_pins);
									
	always
		#(50) clk = ~clk;
  
  initial begin
    #(1700) $display(output_pins);
  end
endmodule
