module Frame(FrameIn, PxOut, LineOut, clk);
input [7:0]FrameIn;
input [9:0]PxOut;
input [9:0]LineOut;
input clk, reset;

reg [0:2640]frame[0:109];
reg [0:2640]temp;
reg count = 0;

always@ (posedge clk && FrameIn)
begin
  if(count == 0) begin
  temp = FrameIn;
  count = count + 1;
  end
  if(count == 1) begin
  temp[15:8] = FrameIn;
  count = count + 1;
  end
  if(count == 2) begin
  temp[23:16] = FrameIn;
  frame[LineOut] = frame[LineOut] | (temp >> (24 * PxOut));
  count = 0;
  end
end

endmodule
