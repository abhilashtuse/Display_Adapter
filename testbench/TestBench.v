`timescale 1fs/1fs
module test_DataPath;
  integer i;
  wire [31:0]WData;
  reg [9:0]VBOut_PD;
  reg [9:0]HBOut_PD;
  reg [9:0]AIPOut_PD;
  reg [9:0]AILOut_PD;
  reg CSDisplay, clk, reset,write;
  wire Buf1Empty,Buf0Empty;
  reg [2:0]imageNumber;
  reg [15:0]FrameWInd;

  wire [7:0]FrameDataOut;
  reg readFrame, FrameReadIncLine, FrameReadResetLine;
  ReadImage read (.clk(clk),.fout(WData),.imageNumber(imageNumber),.Buf1Empty(Buf1Empty),.Buf0Empty(Buf0Empty));
  DataPath dataPath(.WData(WData), .HBOut_PD(HBOut_PD), .VBOut_PD(VBOut_PD), .AIPOut_PD(AIPOut_PD),
   .AILOut_PD(AILOut_PD), .CSDisplay(CSDisplay), .clk(clk), .reset(reset) , .readFrame(readFrame),
  .FrameWInd(FrameWInd),.Buf1Empty(Buf1Empty),.Buf0Empty(Buf0Empty));
  //WriteImage write_im(.FrameDataOut(FrameDataOut), .write(write), .clk(clk));

 initial
        begin
            imageNumber = 0;
            CSDisplay = 0;
            VBOut_PD = 10;
            HBOut_PD = 10;
            AIPOut_PD = 100;
            AILOut_PD = 100;
            write = 0;
            readFrame = 0;
            FrameWInd = 0;
            $display("In TestBench HBOut:%d",HBOut_PD);
            clk = 1;
            forever #1 clk= !clk;
        end

    initial
        begin
          reset = 1;
          #2 reset = 0; CSDisplay= 0; imageNumber = 1;
          repeat(9999)#2; // Fill Buffer 0

          #2  CSDisplay= 1;
          #2  imageNumber = 2;
          repeat(39999)#2; // Transfer from buffer 0 to Frame
          repeat(39999) #2;//Transfer from buffer 1 to Frame










          #2 CSDisplay= 0; readFrame = 1; write = 1;

          repeat(30000) #2 FrameWInd = FrameWInd + 1; // Write Frame data to output file

          #2 write = 0; FrameWInd = 0; readFrame = 0;
          #2;
          $finish;
        end

    initial
        begin
            $dumpfile("test_DataPath.vcd");
            $dumpvars;
        end
endmodule
