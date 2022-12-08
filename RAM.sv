module RAM 
	#(parameter WORD = 1, 
	  parameter SIZE_LOG = 8,
	  parameter SIZE = 2 ** SIZE_LOG,
    parameter INPUT = 0,
    parameter OUTPUT = 0,
    parameter INIT_FILE = "")
  ( input  logic 						        write,
    input  logic   [SIZE_LOG - 1:0]	address,
    input  logic   [WORD - 1:0]			data_in,
    output logic   [WORD - 1:0]		  data_out,
    input  logic   [INPUT - 1:0]    input_pins,
    output logic   [OUTPUT - 1:0]   output_pins
  );
	
  logic [WORD - 1:0] memory [0:SIZE - 1] = '{SIZE{'0}};
  
  genvar idx;
  generate
    for (idx = 0; idx < OUTPUT; idx++) begin: id
      always_comb output_pins[idx] <= memory[idx][0];
    end
  endgenerate
  
  initial begin
    if (INIT_FILE != "")
      $readmemh(INIT_FILE, memory);
  end
  
  logic [WORD - 1:0] out_register;
  always_latch out_register <= write ? out_register : memory[address];
  
  always_comb data_out <= out_register;

  always_ff @(negedge write)
    memory[address] <= data_in;
endmodule
