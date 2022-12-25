module MC14516B (
	input logic reset,
	input logic preset_enable,
	input logic up_down,
	input logic clock,
	input logic carry_in,
	input logic [3:0] preset,
	output logic [3:0] result,
	output logic carry_out
);

logic [3:0] counter = '0;

always_ff @(posedge clock or posedge reset or posedge preset_enable) begin
	if (reset)
		counter <= '0;
	else if (preset_enable)
		counter <= preset;
	else if (!carry_in) begin
		if (up_down)
			counter ++;
		else
			counter --;
	end
end

always_comb begin
	result <= counter;
	if (up_down)
		carry_out <= |(counter^'1) | carry_in;
	else
		carry_out <= |counter | carry_in;
end
	
endmodule
	