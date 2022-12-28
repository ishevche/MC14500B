import instructions::instruction_t;

module Wrapper
  #(parameter ADDR_WIDTH = 8,
    parameter INSTRUCTION_WIDTH = 4,
    parameter DATA_WIDTH = ADDR_WIDTH + INSTRUCTION_WIDTH,
    parameter INPUT_SIZE = 5,
    parameter OUTPUT_SIZE = 5)
  ( input  logic clk,
    input  logic reset,
    input  logic program_write,
    input  logic [DATA_WIDTH - 1:0] program_cmd,
    input  logic [INPUT_SIZE - 1:0] input_pins,
    output logic [OUTPUT_SIZE - 1:0] output_pins);
    
  logic [ADDR_WIDTH - 1:0] address = '0;
  logic data_in = '0;
  
  wire logic [ADDR_WIDTH - 1:0] counter;
  wire logic [DATA_WIDTH - 1:0] cmd;
  wire logic jmp_flag;
  wire logic rtn_flag;
  wire logic flag_o;
  wire logic flag_f;
  wire logic data_out;
  wire logic data_write;
  wire logic rr_out;
  wire logic data_from_ram;
  wire logic data_from_io;
  logic      data_from_ram_register = '0;
  
  always_comb data_from_ram_register <= data_from_ram;
  
  instruction_t opcode;
  always_comb opcode <= instruction_t'(cmd[DATA_WIDTH - 1:ADDR_WIDTH]);
  always_comb address <= cmd[ADDR_WIDTH - 1:0];
  
  always_ff @(negedge clk)
    data_in <= address == '1 ? rr_out : ((address < INPUT_SIZE + OUTPUT_SIZE) ? data_from_io : data_from_ram_register);
  
  logic data_write_register = '0;
  always_comb data_write_register <= data_write;
  
  logic pc_reset;
  logic icu_reset;
  
  ResetModule reset_module (
    .clk(clk),
    .reset(~reset),
    .pc_reset(pc_reset),
    .icu_reset(icu_reset));
  
  RAM #(.DATA_WIDTH(1),
        .ADDR_WIDTH(ADDR_WIDTH)) ram (
    .write(data_write_register & (address > INPUT_SIZE + OUTPUT_SIZE)),
    .address(address),
    .data_in(data_out),
    .data_out(data_from_ram));
  
  RAM #(.DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .INIT_FILE("program.mem")) text (
    .write(program_write),
    .address(counter),
    .data_in(program_cmd),
    .data_out(cmd));
  
  IOBlock #(.ADDR_WIDTH(ADDR_WIDTH),
            .INPUT_SIZE(INPUT_SIZE),
            .OUTPUT_SIZE(OUTPUT_SIZE)) io (
    .write(data_write & (address < INPUT_SIZE + OUTPUT_SIZE)),
    .data_in(data_out),
    .data_out(data_from_io),
    .address(address),
    .input_pins(input_pins),
    .output_pins(output_pins)
  );
                             
  ProgramCounter #(.ADDR_WIDTH(ADDR_WIDTH)) cnt (
    .clk(clk),
    .reset(pc_reset),
    .write(jmp_flag),
    .address_in(address),
    .address_out(counter));

  ICU icu (
    .clk(clk),
    .data_in(data_in),
    .rst(icu_reset),
    .instruction(opcode),
    .write(data_write),
    .data_out(data_out),
    .jmp(jmp_flag),
    .rtn(rtn_flag),
    .flag_o(flag_o),
    .flag_f(flag_f),
    .rr_out(rr_out));

endmodule