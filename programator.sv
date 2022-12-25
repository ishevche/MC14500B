module Programator (
	input logic				clk,
	input logic 			enable,
	input logic 			uart_rx,
	output logic [11:0] 	address,
	output logic [15:0]	data,
	output logic			write
);

logic data_ready		= 1;
logic [15:0] result 	= '0;
logic data_recieved;
logic [7:0] uart_data;
logic [11:0] counter = '0;

UARTReciever #(.CLKS_PER_BIT(50000000 / 115200)) uart (.clock(clk),
																		 .serial(uart_rx),
																		 .done(data_recieved),
																		 .data(uart_data));

always_ff @(posedge data_recieved) begin
	if (data_ready) begin
		data_ready = 1'b0;
		counter <= counter + 1;
		result[15:8] <= uart_data;
	end
	else begin
		result[7:0] = uart_data;
		data_ready <= 1'b1;
	end
end

always_comb begin
	address 	<= counter;
	data 		<= result;
	write		<= data_ready;
end

endmodule