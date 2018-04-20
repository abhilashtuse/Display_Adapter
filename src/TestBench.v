module test_DataPath;
  reg [31:0]WData;
  reg [9:0]VBOut;
  reg [9:0]HBOut;
  reg [9:0]AIPOut;
  reg [9:0]AILOut;
  reg CSDisplay, clk, reset;

  DataPath dataPath(.WData(WData), .HBOut_PD(HBOut_PD), .VBOut_PD(VBOut_PD), .AIPOut_PD(AIPOut_PD), .AILOut_PD(AILOut_PD), .CSDisplay(CSDisplay), .clk(clk), .reset(reset));

    initial
        begin
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
            #2 reset = 0;
            repeat(70)
              #1;
            $finish;
        end

    initial
        begin
            $dumpfile("test_DataPath.vcd");
            $dumpvars;
        end
endmodule
