`timescale 1fs/1fs
module Buf0(R0,B0,G0,RE0,WE0,Addr0,WData, clk, reset,Buffer0Full, Buf0Empty);
  input RE0,WE0, clk, reset, Buf0Empty;
  input [19:0]Addr0;
  input [31:0] WData;

  wire RE0,WE0, clk, reset, Buf0Empty;
  wire [19:0]Addr0;
  wire [31:0] WData;

  output [7:0]R0;
  output [7:0]B0;
  output [7:0]G0;
  output Buffer0Full;

  reg [7:0]R0;
  reg [7:0]B0;
  reg [7:0]G0;
  reg [23:0] buff0[9999:0];
  reg [23:0]result;
  reg Buffer0Full;

  always @ (posedge clk)
    begin
        if(WE0 == 1 && Buf0Empty == 1) begin
          //$display("Writing to buffer1");
            buff0[0] <= 24'hffffff;
            buff0[Addr0 + 1] <= WData[23:0];
          //  buff0[Addr0] = WData[23:0];
            //$display("Addr: %d Buffer0: %h   Wdata:%h", Addr0, buff0[Addr0],WData[23:0]);
            if(Addr0 == 9999)begin
              Buffer0Full = 1;
              //$display("Before dumping buf0");
              //$writememh("Buf0Dump.bmp",buff0);
            end
            else begin
              Buffer0Full = 0;
            end
        end
  end
  always @ (posedge clk)
    begin
    if(reset == 1) begin
      G0 = 0;
      B0 = 0;
      R0 = 0;
    end
    else if(RE0 == 1) begin
          result = buff0[Addr0];
          R0 = result[7:0];
          G0 = result[15:8];
          B0 = result[23:16];
      end
  end
endmodule
