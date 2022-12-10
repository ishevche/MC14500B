module ProgramCounter 
  #(parameter SIZE = 8)
  ( input  logic              clk,
    input  logic              reset,
    input  logic              write,
    input  logic [SIZE - 1:0] address_in,
    output logic [SIZE - 1:0] address_out);
     
  logic [SIZE - 1:0] counter = '0;
  
  always_comb address_out <= counter;
  
  always_ff @(posedge clk) begin
    if (reset)
      counter <= '1;
    else if (write)
      counter <= address_in;
    else 
      counter += 1'b1;
  end
endmodule
