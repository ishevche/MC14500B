module RAM 
  #(parameter DATA_WIDTH,
    parameter ADDR_WIDTH,
    parameter SIZE = 2 ** ADDR_WIDTH,
    parameter INIT_FILE = "")
  ( input  logic write,
    input  logic [ADDR_WIDTH - 1:0] write_address,
    input  logic [ADDR_WIDTH - 1:0] read_address,
    input  logic [DATA_WIDTH - 1:0] data_in,
    output logic [DATA_WIDTH - 1:0] data_out,
    input  logic req_prev,
    output logic ack_prev,
    output logic req_next,
    input  logic ack_next
  );
  
  logic [DATA_WIDTH - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};
  
  always_comb ack_prev <= req_prev;
  
  always_ff @)posedge req_prev or posedge ack_next)
    req_next <= !ack_next;
  
  initial
    if (INIT_FILE != "")
      $readmemh(INIT_FILE, memory);

  logic [DATA_WIDTH - 1:0] out_register = '0;
  always_latch out_register <= write ? out_register : memory[read_address];
  
  always_ff @(posedge req_prev)
    data_out <= out_register;
  
  always_ff @(posedge write)
    memory[write_address] <= data_in;
endmodule