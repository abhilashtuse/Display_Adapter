module frameMUX(FrameIn, B0, B1, SelBuf0, SelBlank, SelBuf1);
input SelBuf0, SelBlank, SelBuf1;
input [7:0]B0;
input [7:0]B1;

output [7:0]FrameIn;
reg [7:0]FrameIn;

always @ (B0 or BK or B1 or SelBuf0 or SelBlank or SelBuf1)
begin
  if(SelBuf0 == 1 && SelBlank == 0 && SelBuf1 == 0)
    FrameIn = B0;
  if(SelBuf0 == 0 && SelBlank == 1 && SelBuf1 == 0)
    FrameIn = 0;//BK
  if(SelBuf0 == 0 && SelBlank == 0 && SelBuf1 == 1)
    FrameIn = B1;
end
endmodule
