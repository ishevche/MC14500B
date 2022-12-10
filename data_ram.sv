module DataRAM 
  #(parameter WORD = 1, 
    parameter SIZE_LOG = 8,
    parameter SIZE = 2 ** SIZE_LOG,
    parameter INPUT = 5,
    parameter OUTPUT = 5)
  ( input  logic                    write,
    input  logic   [SIZE_LOG - 1:0] address,
    input  logic   [WORD - 1:0]     data_in,
    output logic   [WORD - 1:0]     data_out,
    input  logic   [INPUT - 1:0]    input_pins,
    output logic   [OUTPUT - 1:0]   output_pins
  );
  
  logic [WORD - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};

  logic [WORD - 1:0] out_register = '0;
  always_latch begin
    if (OUTPUT <= address && address < OUTPUT + INPUT)
      out_register[0] <= write ? out_register[0] : input_pins[address - OUTPUT];
    else
      out_register <= write ? out_register : memory[address]; // read-while-write protection
  end
  
  always_comb data_out <= out_register;
  
  always_ff @(posedge write) begin
    if (address < OUTPUT)
      output_pins[address] <= data_in;
    else if (address >= OUTPUT + INPUT)
      memory[address] <= data_in;
  end
endmodule
