import instructions::*;

module ICU_test ();
  logic clk = '0;
  logic data_in = '0;
  logic rst;
  logic write;
  logic data_out;
  logic jmp;
  logic rtn;
  logic flag_o;
  logic flag_f;
  logic rr_out;
  instruction_t i = NOPO;
  ICU cpu(clk, data_in, rst, i, write, data_out, jmp, rtn, flag_o, flag_f, rr_out);
  
  always begin
    #(50) clk = ~clk;
  end
  
  `define run_with_input(instruction, data) data_in = data; i = instruction; #(100)
  `define run(instruction) i = instruction; #(100)
  `define test(test_name, expected) $display("%s\t TEST %s", test_name, ((expected) ? "PASSED" : "FAILED"));
  
  initial begin
    rst = '1;
    #(280);
    rst = '0;
    #(10);
    
    $display("RESET was successfull. Testing ...");
    
    `run_with_input(IEN, '1);
    `test("IEN", cpu.ien_register == '1);
    
    `run(OEN);
    `test("OEN", cpu.oen_register == '1);
    
    `run(LD);
    `test("LD",  rr_out == '1);
    
    `run_with_input(OR,  '0);
    `test("OR",  rr_out == '1);
    
    `run(STO);
    `test("STO1", data_out == '1);
    
    `run_with_input(AND, '0);
    `test("AND", rr_out == '0);
    
    `run(STO);
    `test("STO2", data_out == '0);
    
    `run(NOPO);
    `test("NOPO", flag_o == '1);
    
    // $display("TESTS PASSED SUCCESSFULLY")
    
    #(200);
  end
endmodule
