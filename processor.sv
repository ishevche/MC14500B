import instructions::instruction_t;
module processor
  ( input  logic        clk,
    input  logic        reset,
    input  logic        program_write,
    input  logic [7:0]	program_cmd,
    input  logic [6:0]	input_pins,
    output logic [1:0] 	output_pins);
    
  logic [2:0]      		  address  = '0;
  logic                   data_in  = '0;
  logic [7:0]				  input_data	;
  
  wire logic [7:0] 		  counter      ;
  wire logic [7:0] 		  cmd          ;
  wire logic              JMP_FLAG     ;
  wire logic              RTN_FLAG     ;
  wire logic              FLAG_O       ;
  wire logic              FLAG_F       ;
  wire logic              data_out     ;
  wire logic              data_write   ;
  wire logic              rr_out       ;
  
  instruction_t opcode;
  always_comb opcode <= instruction_t'(cmd[7:4]);
  always_comb address <= cmd[3:0];
  
  logic counter_carry;
  
  MC14516B lower_counter  (.reset('0),
									.preset_enable('0),
									.up_down('1),
									.clock(clk),
									.carry_in('0),
									.preset('0),
									.result(counter[3:0]),
									.carry_out(counter_carry));
	
  MC14516B upper_counter  (.reset('0),
									.preset_enable('0),
									.up_down('1),
									.clock(clk),
									.carry_in(counter_carry),
									.preset('0),
									.result(counter[7:4]));
									
  ProgramMemory memory	  (.address(counter),
									.data_in('0),
									.write('0),
									.data_out(cmd));

  MC14500B icu   (.clk(clk),
						.data_in(data_in),
						.rst(reset),
						.instruction(opcode),
						.write(data_write),
						.data_out(data_out),
						.jmp(JMP_FLAG),
						.rtn(RTN_FLAG),
						.flag_o(FLAG_O),
						.flag_f(FLAG_F),
						.rr_out(rr_out));

  MC145998 lower_output	  (.address(address[2:0]),
									.write(data_write),
									.write_disable(clk),
									.chip_enable(!address[3]),
									.input_data(data_out),
									.reset(reset),
									.output_data(output_pins[0]));
  
  MC145998 upper_output	  (.address(address[2:0]),
									.write(data_write),
									.write_disable(clk),
									.chip_enable(address[3]),
									.input_data(data_out),
									.reset(reset),
									.output_data(output_pins[1]));
  
  always_comb data_in <= input_data[address[2:0]];
  always_comb input_data[0] <= rr_out;
  always_comb input_data[7:1] <= input_pins;
  
endmodule
