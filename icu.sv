import instructions::*;

module ICU (
    input  logic req_prev,
    output logic ack_prev,
    output logic req_next,
    input  logic ack_next,
    input  logic data_in,
    input  logic rst,
    input  instruction_t instruction,
    output logic write,
    output logic data_out,
    output logic jmp,
    output logic rtn,
    output logic flag_o,
    output logic flag_f,
    output logic rr_out
  );
  
  always_comb ack_prev <= req_prev;
  logic req_next_buf = '0;
  always_comb req_next <= req_next_buf;
  always_ff @(posedge req_prev or posedge ack_next) begin
    if (ack_next)
      req_next_buf <= '0;
    else
      req_next_buf <= '1;
  end

  logic result_register = '0;
  logic ien_register    = '0;
  logic oen_register    = '0;
  logic old_skip_register = '0;
  logic skip_register   = '0;
  logic out_register    = '0;
  
  instruction_t instruction_register = NOPO;
  
  logic enabled;
 
  always_comb flag_o  <= enabled & instruction_register == NOPO;
  always_comb flag_f  <= enabled & instruction_register == NOPF;
  always_comb rtn     <= enabled & instruction_register == RTN;
  always_comb jmp     <= enabled & instruction_register == JMP;
  
  always_comb rr_out   <= result_register;
  always_comb data_out <= write & out_register;
  
  always_comb write <= enabled &
                       oen_register &
                       (instruction_register == STO | instruction_register == STOC);

  logic data_in_masked;
  always_comb data_in_masked <= data_in & ien_register;
  
  always_ff @(posedge req_prev or posedge rst) begin
    if (rst) begin
      instruction_register <= NOPO;
      result_register <= '0;
      ien_register <= '0;
      oen_register <= '0;
      skip_register <= '0;
      enabled <= '0;
    end else if (req_prev) begin
      old_skip_register <= skip_register;
      if (enabled) begin
        instruction_register <= instruction;
        case (instruction)
          AND:  result_register <= result_register &  data_in_masked;
          ANDC: result_register <= result_register & ~data_in_masked;
          OR:   result_register <= result_register |  data_in_masked;
          ORC:  result_register <= result_register | ~data_in_masked;
          XNOR: result_register <= result_register ^ ~data_in_masked;
          LD:   result_register <= data_in_masked;
          LDC:  result_register <= ~data_in_masked;
          IEN:  ien_register    <= data_in;
          OEN:  oen_register    <= data_in_masked;
          RTN:  skip_register   <= '1;
          SKZ:  skip_register   <= ~result_register;
          STO:  out_register    <= result_register;
          STOC: out_register    <= ~result_register;
        endcase
      end else if (skip_register)
        skip_register <= '0;
      
      enabled = ~skip_register & ~old_skip_register;
      if (!enabled) begin
        instruction_register <= NOPO;
        result_register <= '0;
        ien_register <= '0;
        oen_register <= '0;
      end
    end
  end

endmodule
