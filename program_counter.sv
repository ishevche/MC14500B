module ProgramCounter 
  #(parameter ADDR_WIDTH)
  ( input  logic reset,
    input  logic write,
    input  logic [ADDR_WIDTH - 1:0] address_in,
    output logic [ADDR_WIDTH - 1:0] address_out,
    input  logic req_prev,
    output logic ack_prev,
    output logic req_next,
    input  logic ack_next
  );
    
  logic [ADDR_WIDTH - 1:0] counter = '0;
  
  always_comb ack_prev <= req_prev;
  
  always_ff @)posedge req_prev or posedge ack_next)
    req_next <= !ack_next;
  
  always_comb address_out <= counter;
  
  always_ff @(posedge req_prev) begin
    if (reset)
      counter <= '1;
    else if (write)
      counter <= address_in;
    else 
      counter += 1'b1;
  end
  
endmodule
