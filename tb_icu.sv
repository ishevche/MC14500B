module ICU_test ();
  logic clk = '0;
  logic data_in;
  logic rst;
  logic write;
  logic data_out;
  logic jmp;
  logic rtn;
  logic flag_o;
  logic flag_f;
  logic rr_out;
  instruction_t i;
  ICU cpu(clk, data_in, rst, i, write, data_out, jmp, rtn, flag_o, flag_f, rr_out);
  
  always begin
    #(50) clk = ~clk;
  end
  
  `define run_with_input(instruction, input) #(80); input; #(20); i = instruction; 
  `define run(instruction) #(100); i = instruction;
  
  initial begin
    rst = '1;
    #(190);
    rst = '0;
    
    `run_with_input(IEN, data_in = '1);
    `run(OEN);
    `run(LD);
    `run_with_input(OR, data_in = '0);
    `run_with_input(AND, data_in = '0);
    `run(STO);
    `run(NOPO);
    
    #(200);
  end
endmodule
