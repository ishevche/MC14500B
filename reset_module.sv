module ResetModule
  #(parameter AUTORESET = 1)
  ( input  logic clk,
    input  logic rst,
    output logic pc_reset,
    output logic icu_reset,
    output logic data_ram_reset);
  
  logic pc_reset_register       = '0;
  logic icu_reset_register      = '0;
  logic data_ram_reset_register = '0;
  
  logic [3:0] startup_counter = '0;
  
  logic reset_input_register = '0;
  always_ff @(negedge clk) begin
      reset_input_register <= (startup_counter >= 2 && rst) ||
                              (AUTORESET && 3 <= startup_counter && startup_counter <= 6);
    if (startup_counter <= 10)
      startup_counter += 1'b1;
  end
  
  always_comb reset_input_register <= '1;

endmodule
