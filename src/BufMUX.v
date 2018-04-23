`timescale 1fs/1fs
module BufMUX(Buf, R, G, B, SelR, SelG, SelB);
  //inputs
  input  SelR, SelG, SelB;
  input [7:0]R, G, B;

  wire  SelR, SelG, SelB;
  wire [7:0]R, G, B;

  //outputs
  output [7:0]Buf;
  reg [7:0]Buf;

  //Select RGB according to signals
  always @ (R or B or G or SelR or SelG or SelB)
  begin
    if(SelR == 1 && SelG == 0 && SelB == 0)
        Buf <= R;
    else if(SelR == 0 && SelG == 1 && SelB == 0)
        Buf <= G;
    else if(SelR == 0 && SelG == 0 && SelB == 1)
        Buf <= B;
  end
endmodule
