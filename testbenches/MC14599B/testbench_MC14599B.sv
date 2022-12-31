`timescale 1ns / 1ps
module testbench_MC14599B
#(parameter WIDTH = 3,
	parameter SIZE = 2 ** WIDTH)
();

	logic clk;
	logic write, write_disable, chip_enable, input_data, reset, output_data;
	logic [WIDTH-1:0] address;
	logic [SIZE-1:0] expected_inside_state, previous_expected_state;
	logic expected_data;
	logic [31:0] vectornum, errors;
	logic [16:0] testvectors[10000:0];

	// instantiate device under test
	MC14599B #(WIDTH, SIZE) dut(.address(address), .write(write), .write_disable(write_disable), .chip_enable(chip_enable), .input_data(input_data), .reset(reset), .output_data(output_data));
	
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
			$readmemb("../../testbenches/MC14599B/tb_cases_MC14599B.txt", testvectors);
			clk = 0;
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
		
		if (input_data !== expected_data) begin // check result
			$display("-----------");
			$display("Error: inputs - chip_enable = %b, write_disable = %b, reset = %b, input_data = %b, address = %b", chip_enable, write_disable, reset, input_data, address);
			$display("previous expected state = %b", {previous_expected_state});
			$display("outputs - output_data = %b (%b expected)", output_data, expected_data);
			$display("-----------");
			errors = errors + 1;
			end
		
		if (testvectors[vectornum] === 'x) begin
			$display("%d tests completed with %d errors", vectornum, errors);
			#2;
			$finish;
		end
		{chip_enable, write_disable, reset, input_data, address, expected_inside_state, expected_data} = testvectors[vectornum];
		vectornum = vectornum + 1;
		previous_expected_state = expected_inside_state;
		end
endmodule