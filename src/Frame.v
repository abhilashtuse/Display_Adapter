`timescale 1fs/1fs
module Frame(FrameIn, PxOut, LineOut, clk, readFrame, IncIndex, FrameWInd, RE0, RE1);
input [7:0]FrameIn;
input [9:0]PxOut;
input [9:0]LineOut;
input clk, reset, readFrame;
input IncIndex, RE0, RE1;
input [15:0]FrameWInd;

wire [7:0]FrameIn;
wire [9:0]PxOut;
wire [9:0]LineOut;
wire [15:0]FrameWInd;
wire clk, reset, readFrame;
wire IncIndex,RE0, RE1;

reg [7:0]FrameDataOut [29999:0];
reg [7:0]testFrameByte;
reg [31:0] val;

reg [7:0]frame[36299:0];
integer index, temp1, temp2, i;
integer wfileId;

initial
begin
  //regCount = 0;
  index = 0;
end

always@ (posedge clk )
begin
  if(readFrame) begin
    temp1 = FrameWInd % 300;
    temp2 = FrameWInd / 300;
    FrameDataOut[FrameWInd] = frame[3330 + temp1 + 330*temp2];
    testFrameByte[7:0] = frame[3330 + temp1 + 330*temp2];
    //$display("Frame Index:%d  %h",(3330 + temp1 + 330*temp2), FrameDataOut[FrameWInd]);
    if ((3330 + temp1 + 330*temp2) == 36330) begin
      $display("Frame Index:%d",3330 + temp1 + 330*temp2);
      wfileId = $fopen("new_headless_sample.bmp", "wb");
      if (!wfileId) begin
          $display("Cannot open file to write");
          $finish;
      end

      for (i = 0; i < 30000; i = i + 4) begin
          val = {FrameDataOut[i+3], FrameDataOut[i+2], FrameDataOut[i+1], FrameDataOut[i]};
          $fwrite(wfileId, "%u", val);
      end
      $fclose(wfileId);
    end
  end
end

always@ (posedge clk)
begin
      index <= index + IncIndex;
      frame[index] <= FrameIn;
      $display("Frame Index:%d  FrameIn:%h",index, FrameIn);
      if(index == 36299) begin
        $display("Index:%d",index);
        //$writememh("frame_file.txt", frame);
        index <= 0;
      end
end
endmodule
