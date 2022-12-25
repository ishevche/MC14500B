module UARTReciever #(parameter CLKS_PER_BIT)
(
  input logic			clock,
  input logic			serial,
  output logic			done,
  output logic [7:0]	data
);
    
const logic [2:0] state_wait			 = 3'b000;
const logic [2:0] state_start_bit	 = 3'b001;
const logic [2:0] state_data_bit		 = 3'b010;
const logic [2:0] state_stop_bit		 = 3'b011;
const logic [2:0] state_done			 = 3'b100;
   
int				 clock_count	 = 0;
logic [2:0]     bit_index		 = '0;
logic [2:0]     state			 = '0;
   
always_ff @(posedge clock) begin
	case (state)
		state_wait : begin
          done			<= 1'b0;
          bit_index   <= '0;
          clock_count <= 0;
           
          if (serial == 1'b0)
            state <= state_start_bit;
          else
            state <= state_wait;
      end
       
      state_start_bit : begin
          if (clock_count == CLKS_PER_BIT/2) begin
		  
              if (serial == 1'b0) begin
                  clock_count <= 0;
                  state       <= state_data_bit;
              end
              else
                state <= state_wait;
				
          end
          else begin
              clock_count <= clock_count + 1;
              state       <= state_start_bit;
          end
      end
       
      state_data_bit : begin
          if (clock_count < CLKS_PER_BIT) begin
              clock_count <= clock_count + 1;
              state       <= state_data_bit;
          end
		
          else begin
              clock_count     <= 0;
              data[bit_index] <= serial;
			 
              if (bit_index < 7) begin
                  bit_index <= bit_index + 1'b1;
                  state     <= state_data_bit;
              end
              else begin
                  bit_index <= '0;
                  state		 <= state_stop_bit;
              end
          end
      end
   
      state_stop_bit : begin
          if (clock_count < CLKS_PER_BIT) begin
              clock_count <= clock_count + 1;
              state       <= state_stop_bit;
          end
          else begin
              done        <= 1'b1;
              clock_count <= 0;
              state       <= state_done;
          end
      end
   
      state_done : begin
          state  <= state_wait;
          done   <= 1'b0;
      end         
     
      default :
        state <= state_wait;
       
    endcase
end
   
endmodule