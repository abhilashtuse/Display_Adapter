module pixel_counter(PxOut, clk, ResetPx, IncPx,);
  input clk, ResetPx, IncPx ;
  output [9:0] PxOut;
  reg [9:0] PxOut = 0;

  initial
  begin
    PxOut = 0;
  end

  always @(posedge clk or ResetPx)
  begin
    if(ResetPx==1) begin
      PxOut <= 0;
    end
    else begin
      PxOut <= PxOut + IncPx;
    end
  end
endmodule
