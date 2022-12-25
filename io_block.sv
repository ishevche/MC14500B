/* IO Block
Handles input-output devices
Always reads from input_pin to data_out
Writes from data_in to output_pin when write is HIGH
*/

module IOBlock
  #(parameter ADDR_WIDTH,
    parameter SIZE = 2 ** (ADDR_WIDTH - 1),
    parameter INPUT_SIZE,
    parameter OUTPUT_SIZE)
  ( input  logic write,
    input  logic data_in,
    output logic data_out,
    input  logic [ADDR_WIDTH - 1:0] address,
    input  logic [INPUT_SIZE - 1:0] input_pins,
    output logic [OUTPUT_SIZE - 1:0] output_pins
  );
  
  (* ramstyle = "logic" *) logic [OUTPUT_SIZE - 1:0] out  /* synthesis ramstyle = "logic" */;
  
  //always_ff @* if (write)
  //  out[address] <= data_in;
  
  always_comb output_pins <= out;
  
  always_comb data_out <= input_pins[address - OUTPUT_SIZE];
endmodule
