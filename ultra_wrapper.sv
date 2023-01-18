module UltraWrapper
  ( input  logic clk,
    input  logic uart_rx,
    input  logic rst_btn,
    input  logic [7:0] input_pins,
    output logic [7:0] output_pins
  );
  
  logic reset_reg;
  logic reset_uart;
  logic program_write;
  logic [7:0] program_address;
  logic [11:0] program_cmd;
  
  always_comb reset_reg <= ~rst_btn |reset_uart;
  
  Wrapper #(.INPUT_SIZE(8),
            .OUTPUT_SIZE(8)) wrapper (
    .clk(clk),
    .reset(reset_reg),
    .program_write(program_write),
    //.program_address(program_address),
    .program_cmd(program_cmd),
    .input_pins(input_pins),
    .output_pins(output_pins)
  );
  
  Programator programator (
    .clock(clk),
    .uart_serial_rx(uart_rx),
    .address(program_address),
    .write(program_write),
    .result(program_cmd),
    .reset(reset_uart)
  );
    
  
endmodule