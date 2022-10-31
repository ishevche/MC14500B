module blink (
  input logic btn,
  input logic reset_btn,
  input logic [3:0] switch,
  output logic [7:0] LED
);

logic [7:0] cnt;

always @(negedge btn or negedge reset_btn) begin
  if (!reset_btn) // actually in this case reset_btn is pressed
    cnt = 0;
  else
    cnt += switch;
end

assign LED = cnt[7:0];

endmodule