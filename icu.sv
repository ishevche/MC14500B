import instructions::*;

module ICU (
    input logic         clk,
    input logic         data_in,
    input logic         rst,
    input instruction_t instruction,
    output logic        write,
    output logic        data_out,
    output logic        jmp,
    output logic        rtn,
    output logic        flag_o,
    output logic        flag_f,
    output logic        rr_out
  );

  logic result_register = '0;
  instruction_t instruction_register = NOPO;
  
  logic ien_register  = '0;
  logic oen_register  = '0;
  logic skip_register = '0;
  
  logic out_register = '0;
  always_comb data_out <= out_register;
  
  always_comb flag_o  <= !rst && instruction_register == NOPO;
  always_comb flag_f  <= !rst && instruction_register == NOPF;
  always_comb rtn     <= !rst && instruction_register == RTN;
  always_comb jmp     <= !rst && instruction_register == JMP;
  
  always_comb rr_out <= result_register;
  always_comb write <=  !rst &&
                        !skip_register &&
                        oen_register &&
                        !clk &&
                        (instruction_register == STO || instruction_register == STOC) &&
                        (instruction == STO || instruction == STOC);
  
  always_ff @(negedge clk) begin
    if (!rst) begin
      instruction_register <= instruction;
      
      if (skip_register)
        skip_register = '0;
      else
        skip_register = instruction == RTN | (instruction == SKZ & ~result_register);
      
      if (!rst & !skip_register & oen_register) begin
        if (instruction == STO)
          out_register <=  result_register;
        else if (instruction == STOC)
          out_register <= ~result_register;
      end
    end else
      skip_register <= '0;
  end
  
  logic data_in_masked;
  always_comb data_in_masked <= data_in & ien_register;
  
  always_ff @(posedge clk) begin
    if (rst) begin
      ien_register    <= '0;
      oen_register    <= '0;
      result_register <= '0;
    end else if (!skip_register) begin
      case (instruction_register)
        AND:  result_register <=  result_register &  data_in_masked;
        ANDC: result_register <=  result_register & ~data_in_masked;
        OR:   result_register <=  result_register |  data_in_masked;
        ORC:  result_register <=  result_register | ~data_in_masked;
        XNOR: result_register <=  result_register ^ ~data_in_masked;
        LD:   result_register <=  data_in_masked;
        LDC:  result_register <=  ~data_in_masked;
        IEN:  ien_register    <=  data_in;
        OEN:  oen_register    <=  data_in_masked;
      endcase
    end
  end

endmodule
