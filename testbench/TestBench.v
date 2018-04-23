`timescale 1fs/1fs
module test_DataPath;

  wire [7:0]FrameDataOut;
  wire Buf1Empty,Buf0Empty;
  wire [31:0]WData;

  reg [9:0]VBOut_PD;
  reg [9:0]HBOut_PD;
  reg [9:0]AIPOut_PD;
  reg [9:0]AILOut_PD;
  reg CSDisplay, clk, reset,write;
  reg [2:0]imageNumber;
  reg [15:0]FrameWInd;
  reg readFrame, FrameReadIncLine, FrameReadResetLine;

  integer i;

  //Instantiate modules
  ReadImage read (.clk(clk),.fout(WData),.imageNumber(imageNumber),.Buf1Empty(Buf1Empty),.Buf0Empty(Buf0Empty));
  DataPath dataPath(.WData(WData), .HBOut_PD(HBOut_PD), .VBOut_PD(VBOut_PD), .AIPOut_PD(AIPOut_PD),
   .AILOut_PD(AILOut_PD), .CSDisplay(CSDisplay), .clk(clk), .reset(reset) , .readFrame(readFrame),
  .FrameWInd(FrameWInd),.Buf1Empty(Buf1Empty),.Buf0Empty(Buf0Empty));

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
            clk = 1;
            forever #1 clk= !clk;
        end

    initial
        begin
          reset = 1; // Initial Reset

          // Fill Buffer 0
          #2 reset = 0; CSDisplay= 0; imageNumber = 1;
          repeat(9999)#2;

          #2  CSDisplay= 1;
          #2  imageNumber = 2;

          repeat(36300) #2; //Transfer from buffer 0 to Frame, and Fill Buffer1
          repeat(36300) #2; //Transfer from buffer 1 to Frame, and Fill Buffer0
          repeat(36300) #2; //Transfer from buffer 0 to Frame, and Fill Buffer1

           // Write Frame data to output file
          #2 readFrame = 1; write = 1; CSDisplay= 0;
          repeat(30000) #2 FrameWInd = FrameWInd + 1;
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
