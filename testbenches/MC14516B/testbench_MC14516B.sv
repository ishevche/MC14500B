`timescale 1ns / 1ps
module testbench_MC14516B
 #(parameter size = 4) ();
	logic clk;
	logic reset, preset_enable, up_down, carry_in, expected_carry_out;
	logic carry_out;
	logic [31:0] vectornum, errors;
	logic [16:0] testvectors[10000:0];
	logic [(size-1):0] previous_state, preset, result, expected_result;

	// instantiate device under test
	MC14516B #(size) dut(.reset(reset), .preset_enable(preset_enable), .up_down(up_down), .clock(clk), .carry_in(carry_in), .preset(preset), .result(result), .carry_out(carry_out));
	
	localparam [11:0] clk_half_period=5; 
	// generate clock
	always
		begin
			#clk_half_period; clk = ~clk;
		end

	// at start of test, load vectors
	// and pulse reset

	initial
		begin
			$readmemb("../../testbenches/MC14516B/tb_cases_MC14516B.txt", testvectors);
			expected_result <= 4'b0000;
			expected_carry_out <= 1'b1;
			clk = 0;
			
			//preset_enable = 0;
			//up_down = 0;
			//carry_in = 0; 
			//expected_carry_out = 0;
			//carry_out = 0;
			//expected_previous_state = (size)'b0000;
			//preset = (size)'b0000;
			//result = (size)'b0000;
			
			vectornum = 0; errors = 0;
			#(clk_half_period-1);
			
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
				
		end
		
	// check results on falling edge of clk
	always @(negedge clk)
		begin
		
		if (result !== expected_result | carry_out !== expected_carry_out) begin // check result
			$display("-----------");
			$display("Error: inputs - reset = %b, preset_enable = %b, preset = %b, up_down = %b, carry_in = %b", reset, preset_enable, preset, up_down, carry_in);
			$display("previous state = %b", {previous_state});
			$display("outputs - result = %b (%b expected), carry_out = %b (%b expected)", result, expected_result, carry_out, expected_carry_out);
			$display("-----------");
			errors = errors + 1;
			end
		
		if (testvectors[vectornum] === 'x) begin
			$display("%d tests completed with %d errors", vectornum, errors);
			#2;
			$finish;
		end
		{reset, preset_enable, preset, up_down, carry_in, expected_result, expected_carry_out} = testvectors[vectornum];
		vectornum = vectornum + 1;
		previous_state = result;
		end
endmodule