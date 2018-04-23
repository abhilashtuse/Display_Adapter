`timescale 1fs/1fs
module pixel_counter(PxOut, clk, ResetPx, IncPx,);
  //inputs
  input clk, ResetPx, IncPx ;
  wire clk, ResetPx, IncPx ;

  //outputs
  output [9:0] PxOut;
  reg [9:0] PxOut;

  initial
  begin
    PxOut = 0;
  end

  always @(posedge clk)
  begin
    if(ResetPx == 1) begin
      PxOut <= 0;
    end
    else begin
      PxOut <= PxOut + IncPx;
    end
  end
endmodule
