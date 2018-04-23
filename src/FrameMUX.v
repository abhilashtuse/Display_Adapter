`timescale 1fs/1fs
module FrameMUX(FrameIn, Buf0, Buf1, SelBuf0, SelBlank, SelBuf1);
  //inputs
  input SelBuf0, SelBlank, SelBuf1;
  input [7:0]Buf0;
  input [7:0]Buf1;

  wire SelBuf0, SelBlank, SelBuf1;
  wire [7:0]Buf0;
  wire [7:0]Buf1;

  //outputs
  output [7:0]FrameIn;
  reg [7:0]FrameIn;

  always @ (Buf0 or Buf1 or SelBuf0 or SelBlank or SelBuf1)
  begin
    if(SelBuf0 == 1 && SelBlank == 0 && SelBuf1 == 0)
      FrameIn <= Buf0; // Buffer 0 Data
    else if(SelBuf0 == 0 && SelBlank == 1 && SelBuf1 == 0)
      FrameIn <= 0; //Blank Pixels for Vertical/Horizontal blankings
    else if(SelBuf0 == 0 && SelBlank == 0 && SelBuf1 == 1)
      FrameIn <= Buf1; // Buffer 1 Data
  end
endmodule
