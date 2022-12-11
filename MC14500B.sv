import instructions::instruction_t;
module MC14500B
  #(parameter ADDR = 8,
    parameter CODE = 4,
    parameter WORD = ADDR + CODE,
    parameter INPUT = 5,
    parameter OUTPUT = 5)
  ( input  logic                clk,
    input  logic                reset,
    input  logic                program_write,
    input  logic [WORD - 1:0]   program_cmd,
    input  logic [INPUT - 1:0]  input_pins,
    output logic [OUTPUT - 1:0] output_pins);
    
  logic [ADDR - 1:0]      address       = '0;
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
  always_comb address <= cmd[ADDR - 1:0];
  
  always_ff @(negedge clk)
    data_in <= address == '1 ? rr_out : data_from_ram_register;
  
  logic data_write_register = '0;
  always_comb data_write_register <= data_write;
  
  logic pc_reset;
  logic icu_reset;
  
  ResetModule reset_module (clk,
                            !reset,
                            pc_reset,
                            icu_reset);
  
  DataRAM #(.SIZE_LOG(ADDR),
            .INPUT(INPUT),
            .OUTPUT(OUTPUT)) ram (data_write_register,
                                  address,
                                  data_out,
                                  data_from_ram,
                                  input_pins,
                                  output_pins);
  TextRAM #(.WORD(WORD),
            .SIZE_LOG(ADDR),
            .INIT_FILE("text.txt")) text (program_write,
                                          counter,
                                          program_cmd,
                                          cmd);
                             
  ProgramCounter #(.SIZE(ADDR)) cnt (clk,
                                     pc_reset,
                                     JMP_FLAG,
                                     address,
                                     counter);
  ICU icu (clk,
           data_in,
           icu_reset,
           opcode,
           data_write,
           data_out,
           JMP_FLAG,
           RTN_FLAG,
           FLAG_O,
           FLAG_F,
           rr_out);

endmodule
