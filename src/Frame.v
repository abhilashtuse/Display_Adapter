module Frame(FrameIn, PxOut, LineOut, clk, readFrame, FrameDataOut, IncIndex, FrameWInd);
input [7:0]FrameIn;
input [9:0]PxOut;
input [9:0]LineOut;
input clk, reset, readFrame;
input IncIndex;
input [15:0]FrameWInd;

wire [7:0]FrameIn;
wire [9:0]PxOut;
wire [9:0]LineOut;
wire [15:0]FrameWInd;
wire clk, reset, readFrame;
wire IncIndex;

output [0:2639]FrameDataOut;
reg [0:2639]FrameDataOut;

reg [7:0]frame[36299:0];
//reg [0:2639]temp;
integer index;

initial
begin
  //regCount = 0;
  index = 0;
end

always@ (posedge clk )
begin
  if(readFrame) begin
    FrameDataOut = frame[3329];
    //$display("FrameDataOut:%h",FrameDataOut);
  end
end

always@ (posedge clk)
begin
    index <= index + IncIndex;
    frame[index] <= FrameIn;
    if(index == 36299) begin
      $display("Index:%d",index);
      //$writememh("frame_file.txt", frame);
      index <= 0;
    end
end
endmodule
