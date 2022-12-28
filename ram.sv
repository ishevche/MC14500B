module RAM 
  #(parameter DATA_WIDTH,
    parameter ADDR_WIDTH,
    parameter SIZE = 2 ** ADDR_WIDTH,
    parameter INIT_FILE = "")
  ( input  logic write,
    input  logic [ADDR_WIDTH - 1:0] address,
    input  logic [DATA_WIDTH - 1:0] data_in,
    output logic [DATA_WIDTH - 1:0] data_out
  );
  
  logic [DATA_WIDTH - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};
  
  initial
    if (INIT_FILE != "")
      $readmemh(INIT_FILE, memory);
  
  logic [DATA_WIDTH - 1:0] out_register = '0;
  always_latch out_register <= write ? out_register : memory[address];
  always_comb data_out <= out_register;
  
  always_ff @(posedge write)
    memory[address] <= data_in;
endmodule