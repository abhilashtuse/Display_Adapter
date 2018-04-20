module test_DataPath;
  wire [31:0]WData;
  reg [9:0]VBOut_PD;
  reg [9:0]HBOut_PD;
  reg [9:0]AIPOut_PD;
  reg [9:0]AILOut_PD;
  reg CSDisplay, clk, reset;
  reg signal;
  reg [2:0]imageNumber;

  ReadImage read (.clk(clk),.fout(WData),.imageNumber(imageNumber),.signal(signal));
  DataPath dataPath(.WData(WData), .HBOut_PD(HBOut_PD), .VBOut_PD(VBOut_PD), .AIPOut_PD(AIPOut_PD), .AILOut_PD(AILOut_PD), .CSDisplay(CSDisplay), .clk(clk), .reset(reset));

    initial
        begin
            imageNumber = 0;
            clk = 1;
            forever #1 clk= !clk;
        end

    initial
        begin
            /*  reset = 1;
            #2 reset = 0;
            #2;
            #2 reset = 1;
            #2; reset = 0;*/

            reset = 1;
            #2 reset = 0; signal = 1; imageNumber = 1;
            repeat(20)
              #2;
            $finish;
        end

    initial
        begin
            $dumpfile("test_DataPath.vcd");
            $dumpvars;
        end
endmodule
