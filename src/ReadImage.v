module ReadImage(clk,fout,imageNumber, signal);
  input clk,signal;
  input [2:0] imageNumber;

  wire clk,signal;
  wire [2:0] imageNumber;

  output [31:0]fout;
  reg [31:0]fout;
  integer count1;
  integer rfileId, wfileId, i, ret_val;
  reg [23:0] image1[9999:0];
  reg [7:0]  image2[29999:0];
  reg [7:0]  image3[29999:0];
  reg [7:0]  image4[29999:0];

  initial
  begin
    // Read image1
    rfileId = $fopen("../bin/headless_sample.bmp", "rb");
    if (!rfileId) begin
        $display("Cannot open file to read");
        $finish;
    end

    ret_val = $fread(image1, rfileId);
    /*for (i = 0; i < 60; i = i + 1) begin
        $display("%d %h,",i, aaa[i]);
    end*/
    $fclose(rfileId);

    //Read Image2
    rfileId = $fopen("headless_sample.bmp", "rb");
    ret_val = $fread(image2, rfileId);
    $fclose(rfileId);

    //Read Image3
    rfileId = $fopen("headless_sample.bmp", "rb");
    ret_val = $fread(image3, rfileId);
    $fclose(rfileId);

    //Read Image4
    rfileId = $fopen("headless_sample.bmp", "rb");
    ret_val = $fread(image4, rfileId);
    $fclose(rfileId);
    count1 = 0;
    fout = 0;
  end

  always@ (posedge clk)
  begin
    if(imageNumber == 1 && signal == 1) begin
      fout[23:0] = image1[count1];
      count1 = count1+1;
    end
  end
endmodule
