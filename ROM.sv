module ROM 
  #(parameter WORD = 1, 
    parameter SIZE_LOG = 8,
    parameter SIZE = 2 ** SIZE_LOG)
  ( input logic                     read,
    input logic                     write,
    input logic   [SIZE_LOG - 1:0]  address,
    input logic   [WORD - 1:0]      data_in,
    output logic  [WORD - 1:0]      data_out
  );
  
  logic [WORD - 1:0] rom [0:SIZE - 1];
  logic [SIZE_LOG - 1:0] address_buff = '0;
  
  initial begin
    for (integer i = 0; i < SIZE; i = i + 1)
      rom[i] = '0;
    $readmemh("out.txt", rom);
  end
  
		
  always_ff @(posedge write or posedge read) address_buff <= address;
	
	always_latch begin
		if (write) rom[address_buff] <= data_in;
		if (read)  data_out <= rom[address_buff];
	end
endmodule
