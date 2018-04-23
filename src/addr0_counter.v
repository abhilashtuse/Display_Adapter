`timescale 1fs/1fs
module Addr0_counter(Addr0, clk, ResetAddr0, IncAddr0,);
  //inputs
  input clk, ResetAddr0, IncAddr0;
  wire clk, ResetAddr0, IncAddr0;

  //outputs
  output [19:0] Addr0;
  reg [19:0] Addr0 = 0;

  initial
  begin
    Addr0 = 0;
  end

  always @(posedge clk)
  begin
    if(ResetAddr0 == 1) begin
      Addr0 <= 0;
    end
    else begin
      Addr0 <= Addr0 + IncAddr0;
    end
  end
endmodule
