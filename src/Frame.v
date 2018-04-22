module Frame(FrameIn, PxOut, LineOut, clk, readFrame, FrameDataOut, readLineOutCounter, IncIndex);
input [7:0]FrameIn;
input [9:0]PxOut;
input [9:0]LineOut,readLineOutCounter;
input clk, reset, readFrame;
input IncIndex;

wire [7:0]FrameIn;
wire [9:0]PxOut;
wire [9:0]LineOut,readLineOutCounter;
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
    FrameDataOut = frame[readLineOutCounter + 10];
    //$display("line count: %d ", readLineOutCounter + 10);
  end
end

always@ (posedge clk)
begin
    index <= index + IncIndex;
    frame[index] <= FrameIn;
    if(index == 36300)
     index <= 0;
end
endmodule
