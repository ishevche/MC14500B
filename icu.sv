typedef enum logic [3:0] {
  NOPO,  // 0x0
  LD,  // 0x1
  LDC,  // 0x2
  AND,  // 0x3
  ANDC,  // 0x4
  OR,  // 0x5
  ORC,  // 0x6
  XNOR,  // 0x7
  STO,  // 0x8
  STOC,  // 0x9
  IEN,  // 0xA
  OEN,  // 0xB
  JMP,  // 0xC
  RTN,  // 0xD
  SKZ,  // 0xE
  NOPF  // 0xF
} instruction_t;

module MC14500B (
  input logic clk,
  input logic data_in,
  input logic rst,
  input instruction_t instruction,
  output logic write,
  output logic data_out,
  output logic jmp,
  output logic rtn,
  output logic flag_o,
  output logic flag_f,
  output logic rr_out
  );


logic result_register;
instruction_t instruction_register;

logic ien_register;
logic oen_register;
logic skip_register;

always_comb flag_o <= instruction_register == NOPO;
always_comb flag_f <= instruction_register == NOPF;
always_comb rtn <= instruction_register == RTN;
always_comb jmp <= instruction_register == JMP;

always_comb rr_out <= result_register;

always @(negedge clk) begin
  instruction_register <= instruction;
  
  if (skip_register | rst)
    skip_register = '0;
  else
    skip_register = instruction == RTN | (instruction == SKZ & ~result_register);
  
  if (!rst) begin
    if (!skip_register & oen_register) begin
      if (instruction == STO) begin
        data_out <= result_register;
        write <= '1;
      end else if (instruction == STOC) begin
        data_out <= ~result_register;
        write <= '1;
      end else write <= '0;
    end else write <= '0;
  end else write <= '0;
end

logic data_in_masked;
always_comb data_in_masked <= data_in & ien_register;

always @(posedge clk) begin
  if (rst) begin
    ien_register <= '0;
    oen_register <= '0;
    result_register <= '0;
  end if (!skip_register) begin
    case (instruction_register)
      AND:  result_register <=  result_register & data_in_masked;
      ANDC: result_register <= ~result_register & data_in_masked;
      OR:   result_register <=  result_register | data_in_masked;
      ORC:  result_register <=  ien_register ? (~result_register | data_in_masked) : '1;
      XNOR: result_register <= ~result_register ^ data_in_masked;
      LD:  result_register <=  data_in_masked;
      LDC:  result_register <=  ien_register ? ~data_in_masked : '1;
      IEN:  ien_register   <=  data_in;
      OEN:  oen_register   <=  data_in_masked;
    endcase
  end
end


endmodule
