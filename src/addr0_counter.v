module Addr0_counter(Addr0, clk, ResetAddr0, IncAddr0,);
  input clk, ResetAddr0, IncAddr0 ;
  output [19:0] Addr0;
  reg [19:0] Addr0 = 0;

  initial
  begin
    Addr0 = 0;
  end

  always @(posedge clk or ResetAddr0)
  begin
    if(ResetAddr0==1) begin
      Addr0 <= 0;
    end
    else begin
      Addr0 <= Addr0 + IncAddr0;
    end
  end
endmodule