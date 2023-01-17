module SB (
	input logic clk,
	input logic inp,
	output logic out
);
	
	always_ff @(posedge clk) begin
    out <= inp;
  end
endmodule