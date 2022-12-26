module MC14599B
 #(parameter WIDTH = 3,
	parameter SIZE = 2 ** WIDTH)
  (input  logic [WIDTH-1:0]	address,
	input  logic 					write,
	input  logic					write_disable,
	input  logic					chip_enable,
	input  logic					input_data,
	input  logic					reset,
	output logic					output_data);

logic [SIZE-1:0] data = '0;
	
always_comb output_data <= data[address];

always_ff @(negedge write_disable or posedge reset) begin
	if (reset)
		data = '0;
	else if (write && chip_enable)
		data[address] <= input_data;
end
	
endmodule