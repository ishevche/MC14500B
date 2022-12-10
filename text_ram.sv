module TextRAM 
  #(parameter WORD = 1, 
    parameter SIZE_LOG = 8,
    parameter SIZE = 2 ** SIZE_LOG,
    parameter INIT_FILE = "")
  ( input  logic                    write,
    input  logic   [SIZE_LOG - 1:0] address,
    input  logic   [WORD - 1:0]     data_in,
    output logic   [WORD - 1:0]     data_out
  );
  
  logic [WORD - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};
  
  initial begin
    if (INIT_FILE != "")
      $readmemh(INIT_FILE, memory);
  end
  
  logic [WORD - 1:0] out_register = '0;
  always_latch out_register <= write ? out_register : memory[address]; // read-while-write protection
  
  always_comb data_out <= out_register;

  always_ff @(posedge write)
    memory[address] <= data_in;
endmodule
