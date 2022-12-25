module MC14516B 
 #(parameter SIZE = 4)
  (input  logic 					reset,
	input  logic					preset_enable,
	input  logic					up_down,
	input  logic					clock,
	input  logic 					carry_in,
	input  logic [SIZE-1:0] 	preset,
	output logic [SIZE-1:0] 	result,
	output logic 					carry_out);

logic [SIZE-1:0] counter = '0;

always_ff @(posedge clock or posedge reset or posedge preset_enable) begin
	if (up_down) 
		carry_out <= |(counter^'1) | carry_in;
	else
		carry_out <= |counter | carry_in;
	if (reset)
		counter <= '0;
	else if (preset_enable)
		counter <= preset;
	else if (!carry_in) begin
		if (up_down)
			counter <= counter + 1'b1;
		else
			counter <= counter - 1'b1;
	end
end

always_comb begin
	result <= counter;
end
	
endmodule
	