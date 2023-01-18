module ProgramCounter 
  #(parameter ADDR_WIDTH,
    parameter STACK_ADDR_WIDTH,
    parameter STACK_SIZE = 2 ** STACK_ADDR_WIDTH)
  ( input  logic reset,
    input  logic write,
    input  logic [1:0] instruction,
    input  logic [ADDR_WIDTH - 1:0] address_in,
    output logic [ADDR_WIDTH - 1:0] address_out,
    input  logic req_prev,
    output logic ack_prev,
    output logic req_next,
    input  logic ack_next
  );
  
  always_comb ack_prev <= req_prev;
  
  always_ff @(posedge req_prev or posedge ack_next) begin
    if (ack_next)
      req_next <= '0;
    else
      req_next <= '1;
  end
  
  logic [ADDR_WIDTH - 1:0] stack [0: STACK_SIZE - 1] = '{STACK_SIZE{'0}};
  logic [STACK_ADDR_WIDTH - 1:0] stack_pointer = '0;
  
  always_comb address_out <= stack[stack_pointer];
  
  always_ff @(posedge req_prev or posedge reset) begin
    if (reset) begin
      stack[0] <= '0;
      stack_pointer <= '0;
    end
    else if (instruction == 2'b00) // INC
      stack[stack_pointer] += 1'b1;
    else if (instruction == 2'b01) // JMP
      stack[stack_pointer] <= address_in;
    else if (instruction == 2'b10) // RTN
      stack_pointer -= 1'b1;
    else if (instruction == 2'b11) begin // NOPF (CALL)
      stack_pointer += 1'b1;
      stack[stack_pointer] <= address_in;
    end
  end
  
endmodule
