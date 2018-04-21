module Test_Addr1_counter;
reg clk, ResetAddr1, IncAddr1, ResetLine, IncLine, IncPx, ResetPx ;
wire [19:0] Addr1;
wire [9:0]LineOut;
wire [9:0]PxOut;
//Addr1_counter addr1Counter(.Addr1(Addr1), .clk(clk), .ResetAddr1(ResetAddr1), .IncAddr1(IncAddr1));
//line_counter line(.LineOut(LineOut), .clk(clk), .ResetLine(ResetLine), .IncLine(IncLine));
pixel_counter px(.PxOut(PxOut), .clk(clk), .ResetPx(ResetPx), .IncPx(IncPx));
initial
begin
clk = 1;
forever #1 clk= !clk;
end

initial
begin
//ResetAddr1 = 0; IncAddr1 = 0;
ResetPx = 0; IncPx = 0;
#2  IncPx = 1;

repeat(120)
  #2 $display("%d",PxOut);

$finish;

end

initial begin
  $dumpfile("test_ProgramCounter.vcd");
  $dumpvars;
end
endmodule
