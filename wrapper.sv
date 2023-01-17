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
  wire logic [ADDR_WIDTH - 1:0] uart_address;
  wire logic [DATA_WIDTH - 1:0] cmd;
  wire logic jmp_flag;
  wire logic rtn_flag;
  wire logic flag_o;
  wire logic flag_f;
  wire logic data_out;
  wire logic data_write;
  wire logic io_write;
  wire logic rr_out;
  wire logic data_from_io;
  
  instruction_t opcode;
  always_comb opcode <= instruction_t'(cmd[DATA_WIDTH - 1:ADDR_WIDTH]);
  always_comb address <= cmd[ADDR_WIDTH - 1:0];
  logic [ADDR_WIDTH - 1:0] address_register = '0;
  
  always_comb
    data_in <= address == '1 ? rr_out : data_from_io;
  
  always_comb
    address_register <= address;
  
  logic pc_reset;
  logic icu_reset;
  
  logic req_out_icu;
  logic req_out_cnt;
  logic req_out_text;
  logic req_out_ram;
  
  logic req_in_icu;
  logic req_in_cnt;
  logic req_in_text;
  logic req_in_ram;
  
  logic ack_out_icu;
  logic ack_out_cnt;
  logic ack_out_text;
  logic ack_out_ram;
  
  logic starter = '0;
  logic [2:0] starter_counter = '0;
  always_comb starter <= starter_counter == 2'b10;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset)
      starter_counter <= '0;
    else if (starter_counter <= 3)
      starter_counter += 1'b1;
  end
  
  SB sb_ram_icu (
    .clk(!clk),
    .reset(reset),
    .inp(req_out_ram),
    .out(req_in_icu)
  );
  
  SB sb_icu_cnt(
    .clk(clk),
    .reset(reset),
    .inp(req_out_icu),
    .out(req_in_cnt)
  );
  
  SB sb_cnt_text(
    .clk(!clk),
    .reset(reset),
    .inp(req_out_cnt),
    .out(req_in_text)
  );
  
  SB sb_text_ram(
    .clk(clk),
    .reset(reset),
    .inp(req_out_text),
    .out(req_in_ram)
  );
  
  SB sb_write(
    .clk(clk),
    .reset(reset),
    .inp(data_write),
    .out(io_write)
  );
  
  RAM #(.DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .INIT_FILE("program.mem")) text (
    .write(program_write),
    .reset(reset),
    .read_address(counter),
	  .write_address(uart_address),
    .data_in(program_cmd),
    .data_out(cmd),
    .req_prev(req_in_text | starter),
    .req_next(req_out_text),
    .ack_prev(ack_out_cnt),
    .ack_next(ack_out_text));
  
  IOBlock #(.ADDR_WIDTH(ADDR_WIDTH),
            .INPUT_SIZE(INPUT_SIZE),
            .OUTPUT_SIZE(OUTPUT_SIZE)) io (
    .write(io_write),
    .reset(reset),
    .data_in(data_out),
    .data_out(data_from_io),
    .address(address_register),
    .input_pins(input_pins),
    .output_pins(output_pins),
    .req_prev(req_in_ram),
    .req_next(req_out_ram), 
    .ack_prev(ack_out_text),
    .ack_next(ack_out_ram)
  );
                             
  ProgramCounter #(.ADDR_WIDTH(ADDR_WIDTH)) cnt (
    .reset(reset),
    .write(jmp_flag),
    .address_in(address),
    .address_out(counter), 
    .req_prev(req_in_cnt),
    .req_next(req_out_cnt),
    .ack_prev(ack_out_icu),
    .ack_next(ack_out_cnt));

  ICU icu (
    .data_in(data_in),
    .rst(reset),
    .instruction(opcode),
    .write(data_write),
    .data_out(data_out),
    .jmp(jmp_flag),
    .rtn(rtn_flag),
    .flag_o(flag_o),
    .flag_f(flag_f),
    .rr_out(rr_out),
    .req_prev(req_in_icu),
    .req_next(req_out_icu),
    .ack_prev(ack_out_ram),
    .ack_next(ack_out_icu));

endmodule