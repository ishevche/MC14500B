import instructions::instruction_t;
module MC14500B
  #(parameter ADDR = 8,
    parameter CODE = 4,
    parameter WORD = ADDR + CODE,
    parameter INPUT = 5,
    parameter OUTPUT = 5)
  ( input  logic                clk,
    input  logic                rst,
    input  logic                program_write,
    input  logic [WORD - 1:0]   program_cmd,
    input  logic [INPUT - 1:0]  input_pins,
    output logic [OUTPUT - 1:0] output_pins);
    
  logic [ADDR - 1:0]      address       = '0;
  logic [ADDR - 1:0]      address_copy  = '0;
  logic                   data_in       = '0;
  
  wire logic [ADDR - 1:0] counter      ;
  wire logic [WORD - 1:0] cmd          ;
  wire logic              JMP_FLAG     ;
  wire logic              RTN_FLAG     ;
  wire logic              FLAG_O       ;
  wire logic              FLAG_F       ;
  wire logic              data_out     ;
  wire logic              data_write   ;
  wire logic              rr_out       ;
  wire logic              data_from_ram;
  logic                   data_from_ram_register = '0;
  
  always_comb data_from_ram_register <= data_from_ram;
  
  instruction_t opcode;
  always_comb opcode <= instruction_t'(cmd[WORD - 1:ADDR]);
  always_comb data_in <= address_copy == '1 ? rr_out : data_from_ram_register;
  always_comb address <= cmd[ADDR - 1:0];
  
  logic data_write_register = '0;
  always_comb data_write_register <= data_write;
  
  RAM #(.SIZE_LOG(ADDR),
        .INPUT(INPUT),
        .OUTPUT(OUTPUT)) ram (data_write_register,
                              address_copy,
                              data_out,
                              data_from_ram,
                              input_pins,
                              output_pins);
  RAM #(.WORD(WORD),
        .SIZE_LOG(ADDR),
        .INIT_FILE("out.txt")) text (program_write,
                               counter,
                               program_cmd,
                               cmd);
                             
  ProgramCounter #(.SIZE_LOG(ADDR)) cnt ( clk, // !clk
                                          !rst, // rst
                                          JMP_FLAG,
                                          address,
                                          counter);
  ICU icu (!clk, // clk
           data_in,
           !rst, // rst
           opcode,
           data_write,
           data_out,
           JMP_FLAG,
           RTN_FLAG,
           FLAG_O,
           FLAG_F,
           rr_out);
                              
  always_ff @(posedge clk) //negedge
    address_copy <= address;
  
endmodule
