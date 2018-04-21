module Addr1_counter(Addr1, clk, ResetAddr1, IncAddr1,);
  input clk, ResetAddr1, IncAddr1 ;
  wire clk, ResetAddr1, IncAddr1 ;
  output [19:0] Addr1;
  reg [19:0] Addr1 = 0;

  initial
  begin
    Addr1 = 0;
  end

  always @(posedge clk)
  begin
    if(ResetAddr1==1) begin
      Addr1 <= 0;
    end
    else begin
      Addr1 <= Addr1 + IncAddr1;
    end
  end
endmodule
