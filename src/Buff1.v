`timescale 1fs/1fs
module Buf1(R1,B1,G1,RE1,WE1,Addr1,WData, clk, reset, Buffer1Full, Buf1Empty);
  input RE1,WE1, clk, reset, Buf1Empty;
  input [19:0]Addr1;
  input [31:0] WData;

  wire RE1,WE1, clk, reset, Buf1Empty;
  wire [19:0]Addr1;
  wire [31:0] WData;

  output [7:0]R1;
  output [7:0]B1;
  output [7:0]G1;
  output Buffer1Full;

  reg [7:0]R1;
  reg [7:0]B1;
  reg [7:0]G1;
  reg [23:0] buff1[9999:0];
  reg [23:0]result;
  reg Buffer1Full;

  always @ (posedge clk)
    begin
        if(WE1 == 1 && Buf1Empty == 1) begin
            //$display("Writing to buffer1");
            //buff1[0] <= 24'hffffff;
            //buff1[Addr1 + 1] <= WData[23:0];
            buff1[Addr1] = WData[23:0];
            //$display("Addr: %d Buffer1: %h   Wdata:%h", Addr1, buff1[Addr1],WData[23:0]);
            if(Addr1 == 9999)begin
              Buffer1Full = 1; //buffer filled
              $display("Before dumping buf1");
              $writememh("Buf1Dump.bmp",buff1);
            end
            else begin
              Buffer1Full = 0;
            end

        end
  end

  always @ (posedge clk)
    begin
    if(reset == 1) begin
      G1 = 0;
      B1 = 0;
      R1 = 0;
    end
    else if(RE1 == 1) begin
          result = buff1[Addr1];
          R1 = result[7:0];
          G1 = result[15:8];
          B1 = result[23:16];
      end
  end
endmodule
