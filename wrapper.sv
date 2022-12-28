import instructions::instruction_t;

module Wrapper
  #(parameter ADDR_WIDTH = 12,
    parameter INSTRUCTION_WIDTH = 4,
    parameter DATA_WIDTH = ADDR_WIDTH + INSTRUCTION_WIDTH,
    parameter INPUT_SIZE = 8,
    parameter OUTPUT_SIZE = 8)
  ( input  logic clk,
    input  logic reset,
    input  logic [INPUT_SIZE - 1:0] input_pins,
    output logic [OUTPUT_SIZE - 1:0] output_pins);
  
  logic [ADDR_WIDTH - 1:0] data_address = '0;
  
  logic data_in = '0;
  
  wire logic [ADDR_WIDTH - 1:0] instruction_pointer;
  wire logic [DATA_WIDTH - 1:0] instruction_block;
  wire logic jmp_flag;
  wire logic rtn_flag;
  wire logic flag_o;
  wire logic flag_f;
  wire logic data_out;
  wire logic write;
  wire logic rr_out;
  wire logic data_ram;
  wire logic data_io;
  wire logic pc_reset;
  wire logic icu_reset;
  
  logic data_mux = '0;
  logic ram_enable = '0;
  logic io_enable = '0;
  always_comb begin
    if (data_address == '1) begin
      data_mux <= rr_out;
      ram_enable <= '0;
      io_enable <= '0;
    end else if (data_address < INPUT_SIZE + OUTPUT_SIZE) begin
      data_mux <= data_io;
      ram_enable <= '0;
      io_enable <= '1;
    end else begin
      data_mux <= data_ram;
      ram_enable <= '1;
      io_enable <= '0;
    end
  end
  
  instruction_t instruction;
  always_comb instruction <= instruction_t'(instruction_block[DATA_WIDTH - 1:ADDR_WIDTH]);
  always_comb data_address <= instruction_block[ADDR_WIDTH - 1:0];
  
  always_ff @(negedge clk)
    data_in <= data_mux;
  
  ResetModule reset_module (
    .clk(clk),
    .reset(~reset),
    .pc_reset(pc_reset),
    .icu_reset(icu_reset));
  
  RAM #(.DATA_WIDTH(1),
        .ADDR_WIDTH(ADDR_WIDTH)) ram (
    .write(ram_enable & write),
    .address(data_address),
    .data_in(data_out),
    .data_out(data_ram));
  
  RAM #(.DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .INIT_FILE("program.mem")) program_code (
    .write('0),
    .data_in('0),
    .data_out(instruction_block),
    .address(instruction_pointer));
  
  IOBlock #(.ADDR_WIDTH(ADDR_WIDTH),
            .INPUT_SIZE(INPUT_SIZE),
            .OUTPUT_SIZE(OUTPUT_SIZE)) io (
    .write(io_enable & write),
    .data_in(data_out),
    .data_out(data_io),
    .address(data_address),
    .input_pins(input_pins),
    .output_pins(output_pins)
  );
                             
  ProgramCounter #(.ADDR_WIDTH(ADDR_WIDTH)) cnt (
    .clk(clk),
    .reset(pc_reset),
    .write(jmp_flag),
    .address_in(data_address),
    .address_out(instruction_pointer));
     
  ICU icu (
    .clk(clk),
    .data_in(data_in),
    .rst(icu_reset),
    .instruction(instruction),
    .write(write),
    .data_out(data_out),
    .jmp(jmp_flag),
    .rtn(rtn_flag),
    .flag_o(flag_o),
    .flag_f(flag_f),
    .rr_out(rr_out));
    
endmodule
