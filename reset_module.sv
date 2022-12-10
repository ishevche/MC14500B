module ResetModule
  ( input  logic clk,
    input  logic reset,
    output logic pc_reset,
    output logic icu_reset);
  
  logic pc_reset_register  = '0;
  logic icu_reset_register = '0;
  
  logic [2:0] counter = '0;

  always_ff @(negedge clk or posedge reset) begin
    if (reset)
      counter = 0;
    else begin
      pc_reset_register <= (2 <= counter && counter < 4);
      if (counter < 4)
        counter = counter + 1'b1;
    end
  end
  
  always_ff @(posedge clk) begin
    icu_reset_register <= pc_reset_register;
  end
  
  always_comb pc_reset <= pc_reset_register;
  always_comb icu_reset <= icu_reset_register;

endmodule
