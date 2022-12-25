module PS34706
#(parameter WORD = 4, 
  parameter SIZE_LOG = 4,
  parameter SIZE = 2 ** SIZE_LOG,
  parameter INIT_FILE = "")
 (input logic clk,
  input logic reset,
  input logic execute,
  input logic carry_in,
  input logic output_enable,
  input logic [WORD - 1:0] data_in,
  input logic [1:0] instruction,
  output logic [WORD - 1:0] data_out,
  output logic [WORD - 1:0] address_out,
  output logic carry_out,
  output logic stack_full,
  output logic stack_empty);
  
//  logic [WORD - 1:0] ram [0:SIZE - 1] = '{'0};
//  logic [SIZE_LOG - 1:0] stack_pointer = '0;
//  
//  logic ram_write; // ~clk & ~execute
//  
//  always_ff @(negedge clk) begin
//    if (instruction == 2'b00) begin // 
//    end
//  end
//  
//  always_ff @(negedge clk or negedge execute)
//    if (ram_write)
//      ram[stack_pointer] <= input_mux;
//  
//  
//  logic input_mux;
//  always_comb input_mux <= something ? ~data_in : incrementor;
//  
//  
//  logic [WORD - 1] incrementor;
//  always_comb incrementor <= carry_in ? data_out_latch : data_out_latch + 1'b1; 
//  always_comb carry_out <= ~(~carry_in & (data_out_latch == '1));
//  
//  
//  logic [WORD - 1] data_out_latch;
//  always_latch data_out_latch <= reset ? (latch_enable ? ram[stack_pointer] : data_out_latch) : '0;
//  
//  
//  logic [WORD - 1:0] data_out_driver;
//  logic [WORD - 1:0] address_out_driver;
//  always_latch data_out_driver <= output_enable ? data_out_driver : data_out_latch;
//  always_latch address_out_driver <= something ? address_out_latch : address_out_driver;
//  always_comb data_out <= data_out_driver;
//  always_comb address_out <= address_out_driver;
//  
//  
//  always_comb stack_full <= stack_pointer != '1;
//  always_comb stack_empty <= stack_pointer != '0;
endmodule