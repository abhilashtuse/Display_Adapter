module test_DataPath;
  integer i;
  wire [31:0]WData;
  reg [9:0]VBOut_PD;
  reg [9:0]HBOut_PD;
  reg [9:0]AIPOut_PD;
  reg [9:0]AILOut_PD;
  reg CSDisplay, clk, reset;
  reg signal, write;
  reg [2:0]imageNumber;
  reg [15:0]FrameWInd;

  wire [0:2639]FrameDataOut;
  reg readFrame, FrameReadIncLine, FrameReadResetLine;
  ReadImage read (.clk(clk),.fout(WData),.imageNumber(imageNumber),.signal(signal));
  DataPath dataPath(.WData(WData), .HBOut_PD(HBOut_PD), .VBOut_PD(VBOut_PD), .AIPOut_PD(AIPOut_PD), .AILOut_PD(AILOut_PD), .CSDisplay(CSDisplay), .clk(clk), .reset(reset) , .readFrame(readFrame), .FrameDataOut(FrameDataOut), .FrameWInd(FrameWInd));
  WriteImage write_im(.FrameDataOut(FrameDataOut), .write(write), .clk(clk));

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
          #2 reset = 0; CSDisplay= 0; signal = 1; imageNumber = 1;
          repeat(9999)#2; // Fill Buffer 0

          #2  CSDisplay= 1;
          repeat(40000)#2; // Transfer from buffer 0 to Frame
          #2 CSDisplay= 0; readFrame = 1; FrameReadResetLine = 1;FrameReadIncLine = 0; write = 1;
          #2 FrameWInd = FrameWInd + 1;
          repeat(99) #2; // Write Frame data to output file

          write = 0; FrameReadIncLine = 0;
          repeat(10) #2;
          $finish;
        end

    initial
        begin
            $dumpfile("test_DataPath.vcd");
            $dumpvars;
        end
endmodule
