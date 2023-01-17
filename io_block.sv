/* IO Block
Handles input-output devices
Always reads from input_pin to data_out
Writes from data_in to output_pin when write is HIGH
*/

module IOBlock
  #(parameter ADDR_WIDTH,
    parameter RAM_WIDTH = ADDR_WIDTH - 1,
    parameter RAM_SIZE = 2 ** (ADDR_WIDTH - 1),
    parameter INPUT_SIZE,
    parameter OUTPUT_SIZE)
  ( input  logic write,
    input  logic reset,
    input  logic data_in,
    output logic data_out,
    input  logic [ADDR_WIDTH - 1:0] address,
    input  logic [INPUT_SIZE - 1:0] input_pins,
    output logic [OUTPUT_SIZE - 1:0] output_pins,
    input  logic req_prev,
    output logic ack_prev,
    output logic req_next,
    input  logic ack_next
  );
  
  logic ram_enable;
  logic ram_out;
  
  always_comb ram_enable <= (address < RAM_SIZE) ? '1 : '0;
  
  RAM #(.DATA_WIDTH(1),
        .ADDR_WIDTH(RAM_WIDTH)) ram (
    .write(write & ram_enable),
    .reset(reset),
    .read_address(address[RAM_WIDTH-1:0]),
    .write_address(address[RAM_WIDTH-1:0]),
    .data_in(data_in),
    .data_out(ram_out),
    .req_prev(req_prev),
    .ack_prev(ack_prev),
    .req_next(req_next),
    .ack_next(ack_next)
  );
  
  logic [OUTPUT_SIZE - 1:0] output_latch = '0;
  always_comb output_pins <= output_latch;
  
  always_ff @(posedge write) begin
    if (RAM_SIZE <= address && address < RAM_SIZE + OUTPUT_SIZE)
      output_latch[address - RAM_SIZE] <= data_in;
   end
  
  always_comb begin
    if (address < RAM_SIZE)
      data_out <= ram_out;
    else if (address < RAM_SIZE + INPUT_SIZE)
      data_out <= input_pins[address - RAM_SIZE];
    else
      data_out <= '0;
   end
  
endmodule
