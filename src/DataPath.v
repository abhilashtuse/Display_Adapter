module DataPath(WData, HBOut_PD, VBOut_PD, AIPOut_PD, AILOut_PD, CSDisplay,clk, reset);
input [31:0]WData;
input [9:0]VBOut;
input [9:0]HBOut;
input [9:0]AIPOut;
input [9:0]AILOut;
input clk, reset, CSDisplay;

reg [9:0]VBOut;
reg [9:0]HBOut;
reg [9:0]AIPOut;
reg [9:0]AILOut;

initial
begin
VBOut = VBOut_PD;
HBOut = HBOut_PD;
AIPOut = AIPOut_PD;
AILOut = AILOut_PD;
end


wire [7:0]R0,B0,G0,R1,B1,G1,FrameIn,Buf0,Buf1;
wire [19:0]Addr0,Addr1;
wire [9:0]PxOut, LineOut;

//buffer control signals
wire WE0,RE0,WE1,RE1;

//Address counter control signals
wire IncAddr0,IncAddr1;

//FrameMUX control signals
wire SelBuf0,SelBuf1,SelBlank;

//buffer MUX control signals
wire SelR0,SelG0,SelB0,SelR1,SelG1,SelB1;

//Frame controll signal
wire IncPx,IncLine;

Addr0_counter addr0(.Addr0(Addr0), .clk(clk), .ResetAddr0(reset), .IncAddr0(IncAddr0));
Buf0 buf0(.R0(R0),.B0(B0),.G0(G0),.RE0(RE0),.WE0(WE0),.Addr0(Addr0),.WData(WData), .clk(clk), .reset(reset));
BufMUX bufMUX0(.Buf(Buf0), .R(R0), .G(G0), .B(B0), .SelR(SelR0), .SelG(SelG0), .SelB(SelB0));

Addr1_counter addr1(.Addr1(Addr1), .clk(clk), .ResetAddr1(reset), .IncAddr1(IncAddr1));
Buf1 buf1(.R1(R1),.B1(B1),.G1(G1),.RE1(RE1),.WE1(WE1),.Addr1(Addr1),.WData(WData), .clk(clk), .reset(reset));
BufMUX bufMUX1(.Buf(Buf1), .R(R1), .G(G1), .B(B1), .SelR(SelR1), .SelG(SelG1), .SelB(SelB1));

FrameMUX frameMUX(.FrameIn(FrameIn), .Buf0(Buf0), .Buf1(Buf1), .SelBuf0(SelBuf0), .SelBlank(SelBlank), .SelBuf1(SelBuf1));

pixel_counter p_counter(.PxOut(PxOut), .clk(clk), .ResetPx(reset), .IncPx(IncPx));
line_counter l_counter(.LineOut(LineOut), .clk(clk), .ResetLine(reset), .IncLine(IncLine));
Frame frame(.FrameIn(FrameIn), .PxOut(PxOut), .LineOut(LineOut), .clk(clk));


Controller controller(.PxOut(PxOut), .LineOut(LineOut),.VBOut(VBOut),.HBOut(HBOut),.AIPOut(AIPOut),.AILOut(AILOut),.CSDisplay(CSDisplay),.RE0(RE0),.WE0(WE0),.RE1(RE1),.WE1(WE1),
.SelR0(SelR0),.SelG0(SelG0),.SelB0(SelB0),.SelR1(SelR1),.SelG1(SelG1),.SelB1(SelB1),.SelBuf0(SelBuf0), .SelBlank(SelBlank), .SelBuf1(SelBuf1), .IncPx(IncPx), .ResetPx(ResetPx), .IncLine(IncLine), .ResetLine(ResetLine),
.SyncHB(SyncHB), .SyncVB(SyncVB), .Buf0Empty(Buf0Empty),.Buf1Empty(Buf1Empty), .IncAddr0(IncAddr0), .ResetAddr0(ResetAddr0), .IncAddr1(IncAddr1), .ResetAddr1(ResetAddr1), .clk(clk), .reset());

always@(posedge clk)
begin

end
endmodule
