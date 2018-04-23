`timescale 1fs/1fs
module ReadImage(clk,fout,imageNumber, Buf1Empty,Buf0Empty);
  input clk,Buf1Empty,Buf0Empty;
  input [2:0] imageNumber;

  wire clk,Buf1Empty,Buf0Empty;
  wire [2:0] imageNumber;

  output [31:0]fout;
  reg [31:0]fout;
  integer count1, count2;
  integer rfileId, wfileId, i, ret_val, rfileId_red;
  reg [7:0] image1[29999:0];
  reg [7:0]  image2[29999:0];
  reg [7:0]  image3[29999:0];
  reg [7:0]  image4[29999:0];

  initial
  begin
    count1 = 0;
    count2 = 0;
    fout = 0;

    // Read image1
    rfileId = $fopen("../bin/headless_sample.bmp", "rb");
    if (!rfileId) begin
        $display("Cannot open file to read");
        $finish;
    end

    ret_val = $fread(image1, rfileId);
    $fclose(rfileId);


    rfileId_red = $fopen("../bin/headless_sample_red.bmp", "rb");
    if (!rfileId_red) begin
        $display("Cannot open file to read red");
        $finish;
    end

    ret_val = $fread(image2, rfileId_red);
    $fclose(rfileId_red);

  end

  always@ (posedge clk)
  begin
    if(imageNumber == 1 && Buf0Empty == 1) begin
      fout[23:0] = {image1[count1 + 2],image1[count1 + 1],image1[count1]};
      //$display("Addr: %d    fout:%h", count1, fout[23:0]);
      count1 = count1 + 3;
    end
    else begin
      count1 = 0;
    end
    if(imageNumber == 2 && Buf1Empty == 1) begin
      fout[23:0] = {image2[count2 + 2],image2[count2 + 1],image2[count2]};
      //$display("Addr: %d    fout:%h", count2, fout[23:0]);
      count2 = count2 + 3;
    end
    else begin
      count2 = 0;
    end
  end
endmodule
