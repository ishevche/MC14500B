module UART_RX 
  #(parameter CLKS_PER_BIT)
  (
   input        clock,
   input        serial,
   output       done,
   output [7:0] result
   );
    
  localparam state_wait      = 3'b000;
  localparam state_start_bit = 3'b001;
  localparam state_data_bit  = 3'b010;
  localparam state_stop_bit  = 3'b011;
  localparam state_done      = 3'b100;
   
  reg [7:0]     clock_count = 0;
  reg [2:0]     bit_index   = 0;
  reg [2:0]     cur_state   = 0;
   
  always_ff @(posedge clock) begin      
    case (cur_state)

      state_wait : begin
          done	       <= 1'b0;
          clock_count <= 0;
          bit_index   <= 0;
           
          if (serial == 1'b0)       
            cur_state <= state_start_bit;
          else
            cur_state <= state_wait;
      end
       
      state_start_bit : begin
          if (clock_count == (CLKS_PER_BIT-1)/2) begin
              if (serial == 1'b0) begin
                  clock_count <= 0;
                  cur_state   <= state_data_bit;
              end else
                cur_state <= state_wait;
          end
          else begin
              clock_count <= clock_count + 1;
              cur_state   <= state_start_bit;
          end
      end
       
      state_data_bit : begin
          if (clock_count < CLKS_PER_BIT-1) begin
              clock_count <= clock_count + 1;
              cur_state   <= state_data_bit;
          end else begin
              clock_count          <= 0;
              result[bit_index] <= serial;
              
              if (bit_index < 7) begin
                  bit_index <= bit_index + 1;
                  cur_state <= state_data_bit;
              end else begin
                  bit_index <= 0;
                  cur_state <= state_stop_bit;
              end
          end
      end
   
      state_stop_bit : begin
          if (clock_count < CLKS_PER_BIT-1) begin
              clock_count <= clock_count + 1;
              cur_state   <= state_stop_bit;
          end else begin
              done        <= 1'b1;
              clock_count <= 0;
              cur_state   <= state_done;
          end
      end
   
      state_done : begin
          cur_state <= state_wait;
          done   	  <= 1'b0;
      end
        
      default :
        cur_state <= state_wait;
       
    endcase
  end   
   
endmodule