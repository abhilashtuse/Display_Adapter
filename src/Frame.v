module Frame(FrameIn, PxOut, LineOut, clk);
input [7:0]FrameIn;
input [9:0]PxOut;
input [9:0]LineOut;
input clk, reset;

wire [7:0]FrameIn;
wire [9:0]PxOut;
wire [9:0]LineOut;
wire clk, reset;

reg [0:2639]frame[0:109];
reg [0:2639]temp;
reg count = 0;

always@ (posedge clk && FrameIn)
begin
  if(count == 0) begin
  temp[0:7] = FrameIn;
  count = count + 1;
  end
  if(count == 1) begin
  temp[8:15] = FrameIn;
  count = count + 1;
  end
  if(count == 2) begin
  temp[16:23] = FrameIn;
  frame[LineOut] = frame[LineOut] | (temp >> (24 * PxOut));
  count = 0;
  end
end

endmodule
