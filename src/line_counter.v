`timescale 1fs/1fs
module line_counter(LineOut, clk, ResetLine, IncLine,);
  input clk, ResetLine, IncLine ;

  wire clk, ResetLine, IncLine ;
  output [9:0] LineOut;
  reg [9:0] LineOut = 0;

  initial
  begin
    LineOut = 0;
  end

  always @(posedge clk )
  begin
    if(ResetLine == 1) begin
      LineOut <= 0;
    end
    else begin
      LineOut <= LineOut + IncLine;
    end
  end
endmodule
