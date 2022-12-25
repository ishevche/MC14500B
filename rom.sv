module ROM
  #(parameter DATA_WIDTH,
    parameter ADDR_WIDTH, 
    parameter SIZE = 2 ** ADDR_WIDTH,
    parameter INIT_FILE = "program.txt")
  ( output logic [DATA_WIDTH - 1:0] data_out,
    input  logic [ADDR_WIDTH - 1:0] address
  );
  
  logic [DATA_WIDTH - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};
  
  initial begin
    if (INIT_FILE != "")
      $readmemh(INIT_FILE, memory);
  end
  
  always_comb data_out <= memory[address];
  
endmodule
