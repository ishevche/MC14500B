module MC14516B_tests;

logic reset = '0;
logic pe = '0;
logic ud = '0;
logic clk = '0;
logic ci = '0;
logic [3:0] preset = '0;
logic [3:0] result;
logic co;

MC14516B counter(.reset(reset),
					  .preset_enable(pe),
					  .up_down(ud),
					  .clock(clk),
					  .carry_in(ci),
					  .preset(preset),
					  .result(result),
					  .carry_out(co));

initial begin
	for (logic [4:0] i = '0; !i[4]; ++i) begin
		preset = i[3:0];
		pe = 1;
		#(1);
		pe = 0;
		#(1);
		if (result != preset) begin
			$display("Failed to preset %d, result = %d", i, result);
			break;
		end
		ci = 1;
		clk = 1;
		#(1);
		clk = 0;
		#(1);
		if (result != preset) begin
			$display("Change while ci = 1, result = %d", result);
			break;
		end
		ci = 0;
		ud = 1;
		clk = 1;
		#(1);
		if (result != preset + 1'b1) begin
			$display("Unable to add, result = %d", result);
			break;
		end
		clk = 0;
		#(1);
		if (result != preset + 1'b1) begin
			$display("Changed on negedge, result = %d", result);
			break;
		end
		
		pe = 1;
		#(1);
		pe = 0;
		#(1)
		
		ud = 0;
		clk = 1;
		#(1);
		if (result != preset - 1'b1) begin
			$display("Unable to sub, result = %d", result);
			break;
		end
		clk = 0;
		#(1);
		if (result != preset - 1'b1) begin
			$display("Changed on negefge, result = %d", result);
			break;
		end
	end
	$display("reset = %d", reset);
	$display("preset_enable = %d", pe);
	$display("up_down = %d", ud);
	$display("carry_in = %d", ci);
	$display("preset = %d", preset);
end

endmodule