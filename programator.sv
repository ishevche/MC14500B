module Programator 
  #(parameter CLOCK_FREQ = 50000000,
	 parameter UART_FREQ = 115200,
	 parameter ADDR_WIDTH = 8)
  ( input 							clock,
    input 							uart_serial_rx,
	 output [ADDR_WIDTH - 1:0] address,
	 output 							write,
	 output [11:0]				result, 
	 output							  reset);
	   
  localparam state_wait_first     = 3'b000;
  localparam state_wait_second    = 3'b001;
  localparam state_data_recieved  = 3'b010;
  localparam state_write_up       = 3'b011;
  localparam state_counter_up     = 3'b100;
  localparam state_stop_recieved  = 3'b110;
  localparam state_reset_up 		  = 3'b101;
	 
  logic [7:0] 					uart_data;
  logic [11:0]					output_data;
  logic 		  					uart_recieved;
  logic [ADDR_WIDTH - 1:0] counter = '0;
  logic							write_reg = '0;
  logic [2:0]					cur_state = '0;
	 
  UART_RX #(.CLKS_PER_BIT(CLOCK_FREQ / UART_FREQ)) reciever (
		.clock(clock),
		.serial(uart_serial_rx),
		.done(uart_recieved),
		.result(uart_data)
	);
	
	always_ff @(posedge clock or posedge uart_recieved) begin
		case (cur_state)
			
			state_wait_first: begin
				if (uart_recieved) begin
					output_data[11:4] <= uart_data;
					cur_state 			<= state_wait_second;
				end else
					cur_state 			<= state_wait_first;
			end
			
			state_wait_second: begin
				if (uart_recieved) begin
					output_data[4:0]  <= uart_data[7:4];
					if (uart_data[3:0] != '0) 
						cur_state		<= state_stop_recieved;
					else
						cur_state		<= state_data_recieved;
				end else
					cur_state 			<= state_wait_second;
			end
			
			state_data_recieved: begin
				write_reg <= '1;
				cur_state <= state_write_up;
			end
			
			state_write_up: begin
				write_reg <= '0;
				cur_state <= state_counter_up;
			end
			
			state_counter_up: begin
				counter   <= counter + 1'b1;
				cur_state <= state_wait_first;
			end
			
			state_stop_recieved: begin
				counter	 <= '0;
				reset		 <= '1;
				cur_state <= state_reset_up;
			end
			
			state_reset_up: begin
				reset		 <= '0;
				cur_state <= state_wait_first;
			end
			
			default:
				cur_state <= state_wait_first;
		endcase	
	end
		
	
	always_comb begin
		result	<= output_data;
		write		<= write_reg;
		address  <= counter;
	end
	
endmodule
	 