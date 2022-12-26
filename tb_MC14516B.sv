module MC14516B_tests;

logic 		reset 	= '0;
logic 		pe 		= '0;
logic 		ud 		= '0;
logic 		clk 		= '1;
logic 		ci 		= '0;
logic [3:0] preset 	= '0;
logic [3:0] result;
logic 		co;
logic [3:0] stored	= '0;
logic			carry_o	= '0;
logic 		failed 	= '0;

MC14516B counter(.reset(reset),
					  .preset_enable(pe),
					  .up_down(ud),
					  .clock(clk),
					  .carry_in(ci),
					  .preset(preset),
					  .result(result),
					  .carry_out(co));

initial begin
	for (logic [13:0] iter = '0; !iter[13]; ++iter) begin
		preset = iter[12:9];
		pe = 1; #(1); 
		pe = 0; #(1);
		stored = preset;
		
		reset = iter[8];
		pe = iter[7];
		ud = iter[6];
		ci = iter[5];
		preset = iter[4:1];
		clk = iter[0];
		carry_o 	 = !(stored == '1 && ud && !ci) && 
						!(stored == '0 && !ud && !ci);
		#(1);
		
		if (reset) begin
			pe = '0;
			reset = '0; #(1);
			if (result != '0) begin
				$display("Failed to reset, iter = %d, result = %d, co = %d", iter, result, co);
				failed = '1;
			end
		end
		
		else if (pe) begin
			pe = '0; #(1);
			if (result != preset) begin
				$display("Failed to preset, iter = %d, result = %d, co = %d", iter, result, co);
				failed = '1;
			end
		end
		
		else if (ci || !clk) begin
			if (result != stored) begin
				$display("Unnecessary change, iter = %d, result = %d, co = %d", iter, result, co);
				failed = '1;
			end
		end
		
		else if (ud) begin
			if (result != stored + 1'b1 || carry_o != co) begin
				$display("Wrong addition, iter = %d, result = %d, co = %d", iter, result, co);
				failed = '1;
			end
		end
		
		else begin
			if (result != stored - 1'b1 || carry_o != co) begin
				$display("Wrong substraction, iter = %d, result = %d, co = %d", iter, result, co);
				failed = '1;
			end
		end
		
	end
end

endmodule