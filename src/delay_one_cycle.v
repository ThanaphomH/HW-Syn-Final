module delay_one_cycle(
  input clk,
  input original_signal,
  output reg delayed_signal
);

  always @(posedge clk) begin
    delayed_signal <= original_signal;
  end


endmodule