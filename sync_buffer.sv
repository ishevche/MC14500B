module SB (
	input logic clk,
  input logic reset,
	input logic inp,
	output logic out
);
	logic out_reg = '0;
  always_comb out <= out_reg;
  
	always_ff @(posedge clk)
    out_reg <= inp & ~reset;
endmodule