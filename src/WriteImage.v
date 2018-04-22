module WriteImage(FrameDataOut, write, clk);
input [7:0]FrameDataOut;
input write,clk;
wire write,clk;
wire [7:0]FrameDataOut;
  integer wfileId, i, count;
  reg [7:0]  aaa[29999:0];
  reg [31:0] val;
  reg [0:2639]temp;

  initial
  begin
    count = 0;
  end

always @(posedge clk)
begin
  if(write)begin
      for (i = 0; i < 300; i = i + 1) begin
        //temp = FrameDataOut;
        aaa[count] = FrameDataOut;
        count = count + 1;
      end
  //    $display("count:%d",count);
    end
end

always @(*)
begin
  if(count == 30000) begin

    wfileId = $fopen("new_headless_sample.bmp", "wb");
    if (!wfileId) begin
        $display("Cannot open file to write");
        $finish;
    end

    for (i = 0; i < 30000; i = i + 4) begin
        val = {aaa[i+3], aaa[i+2], aaa[i+1], aaa[i]};
        $fwrite(wfileId, "%u", val);

    end
  //  $display("i:%d, data: %h",i,aaa[0]);
    $fclose(wfileId);
    count = 0;
  end

end
endmodule
