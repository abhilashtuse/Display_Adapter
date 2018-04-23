`timescale 1fs/1fs
module Controller(PxOut, LineOut,VBOut,HBOut,AIPOut,AILOut,CSDisplay,RE0,WE0,RE1,WE1,
SelR0,SelG0,SelB0,SelR1,SelG1,SelB1,SelBuf0, SelBlank, SelBuf1, IncPx, ResetPx, IncLine, ResetLine,
SyncHB, SyncVB, Buf0Empty,Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1, clk, reset, IncIndex,Buffer0Full, Buffer1Full);

  input [9:0]PxOut;
  input [9:0]LineOut;
  input [9:0]VBOut;
  input [9:0]HBOut;
  input [9:0]AIPOut;
  input [9:0]AILOut;
  input CSDisplay, reset, clk, Buffer0Full, Buffer1Full;

  wire [9:0]PxOut;
  wire [9:0]LineOut;
  wire [9:0]VBOut;
  wire [9:0]HBOut;
  wire [9:0]AIPOut;
  wire [9:0]AILOut;
  wire CSDisplay, reset, clk, Buffer0Full, Buffer1Full;
  output RE0,WE0,RE1,WE1,SelR0,SelG0,SelB0,SelR1,SelG1,SelB1,SelBuf0, SelBlank,
         SelBuf1, IncPx, ResetPx, IncLine, ResetLine,SyncHB, SyncVB, Buf0Empty,
         Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1, IncIndex;
  reg RE0,WE0,RE1,WE1,SelR0,SelG0,SelB0,SelR1,SelG1,SelB1,SelBuf0, SelBlank,
         SelBuf1, IncPx, ResetPx, IncLine, ResetLine,SyncHB, SyncVB, Buf0Empty,
         Buf1Empty, IncAddr0, ResetAddr0, IncAddr1, ResetAddr1,IncIndex;

  reg Inc0Flag;
  reg [6:0] state, nextState;

  //Parameters for Buffer 0
  parameter IDLE = 0, START0 = 1, VB0R = 2, VB0G = 3, VB0B = 4, ResetVB0R = 5, ResetVB0G = 6, ResetVB0B = 7,
            Switch0VBtoHB = 8, SyncHB0A = 9, HB0R = 10, HB0G = 11, HB0B = 12, ResetHB0R = 13, ResetHB0G = 14,
            ResetHB0B = 15, R0 = 16, G0 = 17, B0 = 18, ResetR0 = 19, ResetG0 = 20, ResetB0 = 21, SyncHB0 = 22,
            SyncHB0B = 23, LastHB0R = 24, LastHB0G = 25, LastHB0B = 26, ResetLastHB0R = 27, ResetLastHB0G = 28,
            ResetLastHB0B = 29, LastR0 = 30, LastG0 = 31, LastB0 = 32, ResetLastR0 = 33, ResetLastG0 = 34,
            ResetLastB0 = 35;

  //Parameters for Buffer 1
  parameter START1 = 36, VB1R = 37, VB1G = 38, VB1B = 39, ResetVB1R = 40, ResetVB1G = 41, ResetVB1B = 42,
            Switch1VBtoHB = 43, SyncHB1A = 44, HB1R = 45, HB1G = 46, HB1B = 47, ResetHB1R = 48, ResetHB1G = 49,
            ResetHB1B = 50, R1 = 51, G1 = 52, B1 = 53, ResetR1 = 54, ResetG1 = 55, ResetB1 = 56, SyncHB1 = 57,
            SyncHB1B = 58, LastHB1R = 59, LastHB1G = 60, LastHB1B = 61, ResetLastHB1R = 62, ResetLastHB1G = 63,
            ResetLastHB1B = 64, LastR1 = 65, LastG1 = 66, LastB1 = 67, ResetLastR1 = 68, ResetLastG1 = 69,
            ResetLastB1 = 70;

initial
begin
  Inc0Flag = 0;

  RE0 = 0;WE0 = 0;RE1 = 0;WE1 = 0;SelR0 = 0;SelG0 = 0;SelB0 = 0;SelR1 = 0;SelG1 = 0;SelB1 = 0;SelBuf0 = 0; SelBlank = 0;
  SelBuf1 = 0; IncPx = 0; ResetPx = 0; IncLine = 0; ResetLine = 0;SyncHB = 0; SyncVB = 0; IncAddr0 = 0;
  ResetAddr0 = 0; IncAddr1 = 0; ResetAddr1 = 0; IncIndex = 0; Buf1Empty = 1;
end

always @(*) // always block to compute output
begin
  if(CSDisplay == 0) begin
    nextState <= IDLE;
  end

 case(state)
    //0
    IDLE: begin
      if(CSDisplay == 1) begin
        nextState <= START0;
        WE0 <= 0;
        IncAddr0 <= 0;
        Inc0Flag <= 0;
        ResetAddr0 <= 1;
        Buf0Empty <= 0;//fill buffer 0 first time  complete
      end
      else begin
        Buf0Empty <= 1; //fill buffer 0 first time  complete
        if(reset == 1) begin
          Inc0Flag <= 0;
        end
        else begin
          nextState <= IDLE;
          WE0 <= 1;
          WE1 <= 0;
          if(Inc0Flag == 0) begin
            IncAddr0 <= 0;
            Inc0Flag <= 1;
          end
          else begin
            IncAddr0 <= 1;
          end
        end
      end
    end

    //1
     START0: begin
      SelBlank <= 1;
      Buf1Empty <= 1;
      SyncVB <= 1;
      IncIndex <= 1;

      //Writing buffer 1
      WE0 <= 0;
      WE1 <= 1;
      IncAddr1 <= 1;



      //complementary cases
      IncAddr0 <= 0;
      ResetAddr0 <= 1;
      nextState <= VB0G;
    end

    //2
    VB0R: begin
      SelBlank <= 1;


      //buffer 1
      IncAddr1 <= 1;

      //complementary cases
      ResetAddr0 <= 0;
      IncPx <= 0;
      IncLine <= 0;
      ResetPx <= 0;
      nextState <= VB0G;
    end

    //3
    VB0G: begin
      SelBlank <= 1;

      //complementary cases
      SyncVB <= 0;
      nextState <= VB0B;
    end

    //4
    VB0B: begin
      IncPx <= 1;
      SelBlank <= 1;


      //check else condition if code does not run properly
        //$display("PxOut: %d  (HBOut + AIPOut - 2):%d", PxOut, (HBOut + AIPOut - 2));
      if(PxOut < (HBOut + AIPOut - 2)) // Here -2 to detect second last pixel
        nextState <= VB0R;
      else if(PxOut == (HBOut + AIPOut - 2)) // Here -2 to detect second last pixel
        nextState <= ResetVB0R;
    end

    //5
    ResetVB0R: begin
      SelBlank <= 1;

      //complementary cases
      IncPx <= 0;
      //$display("PxOut: %d  (HBOut + AIPOut - 2):%d", PxOut, (HBOut + AIPOut - 2));
      nextState <= ResetVB0G;
    end

    //6
    ResetVB0G: begin
      SelBlank <= 1;

      if(LineOut < (VBOut - 1))
        nextState <= ResetVB0B;
      else if(LineOut == (VBOut - 1))
        nextState <= Switch0VBtoHB;
    end

    //7
    ResetVB0B: begin
      ResetPx <= 1;
      //$display("In state 7: %d", PxOut);
      IncLine <= 1;
      SelBlank <= 1;
      nextState <= VB0R;

    end

    //8
    Switch0VBtoHB: begin
      ResetPx <= 1;
      ResetLine <= 1;
      SelBlank <= 1;

      //IncIndex <=0;
      nextState <= SyncHB0A;
    end

    //9
    SyncHB0A: begin
      SyncHB <= 1;
      SelBlank <= 1;

      //IncIndex <=1;
      //complementary cases
      ResetPx <= 0;
      ResetLine <= 0;
      nextState <= HB0G;
    end

    //10
    HB0R: begin
      SelBlank <= 1;

      //complementary cases
      IncPx <= 0;
      nextState <= HB0G;
    end

    //11
    HB0G: begin
      SelBlank <= 1;

      //complementary cases
      SyncHB <= 0;
      nextState <= HB0B;
    end

    //12
    HB0B: begin
      IncPx <= 1;
      SelBlank <= 1;

      if(PxOut < (HBOut - 2))
      nextState <= HB0R;
      else if(PxOut == (HBOut - 2))
      nextState <= ResetHB0R;
    end

    //13
    ResetHB0R: begin
      SelBlank <= 1;

      //complementary cases
      IncPx <= 0;
      nextState <= ResetHB0G;
    end

    //14
    ResetHB0G: begin
      SelBlank <= 1;

      nextState <= ResetHB0B;
    end

    //15
    ResetHB0B: begin
      ResetPx <= 1;
      SelBlank <= 1;
      RE0 <= 1;

      nextState <= R0;
    end

    //16
    R0: begin
      SelR0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      //complementary cases
      IncPx <= 0;
      SelBlank <= 0;
      SelB0 <= 0;
      ResetPx <= 0;

      //buffer 1 check
      if(Buffer1Full) begin
      IncAddr1 <= 0;
      end
      nextState <= G0;
    end

    //17
    G0: begin
      SelG0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;
      IncAddr0 <= 1;

      //complementary cases
      SelR0 <= 0;

      //buffer 1 check
      if(Buffer1Full) begin
      WE1 <= 0;
      IncAddr1 <= 0;
      ResetAddr1 <= 0;
      end
      nextState <= B0;
    end

    //18
    B0: begin
      IncPx <= 1;
      SelB0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;
      //complementary cases
      IncAddr0 <= 0;
      SelG0 <= 0;
      if(PxOut < (AIPOut - 2))
      nextState <= R0;
      else if(PxOut == (AIPOut - 2))
      nextState <= ResetR0;
    end

    //19
    ResetR0: begin
      SelR0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      //complementary cases
      SelB0 <= 0;
      IncPx <= 0;
      nextState <= ResetG0;
    end

    //20
    ResetG0: begin
      SelG0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      IncAddr0 <= 1;
      //complementary cases
      SelR0 <= 0;
      nextState <= ResetB0;
    end

    //21
    ResetB0: begin
      ResetPx <= 1;
      IncLine <= 1;
      SelB0 <= 1;
      SelBuf0 <= 1;

      //complementary cases
      IncAddr0 <= 0;
      SelG0 <= 0;
      RE0 <= 0;
      if(LineOut < (AILOut - 2))
        nextState <= SyncHB0;
      else if(LineOut == (AILOut - 2))
        nextState <= SyncHB0B;
    end

    //22
    SyncHB0: begin
      SyncHB <= 1;
      SelBlank <= 1;

      //complementary cases
      ResetPx <= 0;
      IncLine <= 0;
      SelB0 <= 0;
      SelBuf0 <= 0;
      nextState <= HB0G;
    end

    //23
    SyncHB0B: begin
      SyncHB <= 1;
      SelBlank <= 1;

      //complementary cases
      ResetPx <= 0;
      IncLine <= 0;
      SelB0 <= 0;
      SelBuf0 <= 0;
      nextState <= LastHB0G;
    end

    //24
    LastHB0R: begin
      SelBlank <= 1;

      //complementary cases
      IncPx <= 0;
      nextState <= LastHB0G;
    end

    //25
    LastHB0G: begin
      SelBlank <= 1;

      IncIndex <= 1;
      //complementary cases
      SyncHB <= 0;
      nextState <= LastHB0B;
    end

    //26
    LastHB0B: begin
      IncPx <= 1;
      SelBlank <= 1;

      if(PxOut < (HBOut - 2))
      nextState <= LastHB0R;
      else if(PxOut == (HBOut - 2))
      nextState <= ResetLastHB0R;
    end

    //27
    ResetLastHB0R: begin
      SelBlank <= 1;

      //complementary cases
      IncPx <= 0;
      nextState <= ResetLastHB0G;
    end

    //28
    ResetLastHB0G: begin
      SelBlank <= 1;

      nextState <= ResetLastHB0B;
    end

    //29
    ResetLastHB0B: begin
      ResetPx <= 1;
      SelBlank <= 1;
      RE0 <= 1;

      nextState <= LastR0;
    end

    //30
    LastR0: begin
      SelR0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      //complementary cases
      ResetPx <= 0; // coming from state 29
      SelBlank <= 0; // coming from state 29
      IncPx <= 0; // coming from state 32
      SelB0 <= 0; // coming from state 32
      nextState <= LastG0;
    end

    //31
    LastG0: begin
      SelG0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;
      IncAddr0 <= 1;
      //complementary cases
      SelR0 <= 0;
      nextState <= LastB0;

    end

    //32
    LastB0: begin
      IncPx <= 1;
      SelB0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      //complementary cases
      IncAddr0 <= 0;
      SelG0 <= 0;
      if(PxOut < (AIPOut - 2))
      nextState <= LastR0;
      else if(PxOut == (AIPOut - 2))
      nextState <= ResetLastR0;
    end

    //33
    ResetLastR0: begin
      SelR0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;

      //complementary cases
      IncPx <= 0;
      SelB0 <= 0;
      nextState <= ResetLastG0;
    end

    //34
    ResetLastG0: begin
      SelG0 <= 1;
      SelBuf0 <= 1;
      RE0 <= 1;
      ResetAddr0 <= 1;

      //complementary cases
      SelR0 <= 0;
      nextState <= ResetLastB0;
    end

    //35
    ResetLastB0: begin
      ResetLine <= 1;
      ResetPx <= 1;
      SelB0 <= 1;
      SelBuf0 <= 1;

      //complementary cases
      SelG0 <= 0;
      RE0 <= 0;
      ResetAddr0 <= 0;
      nextState <= START1;
    end

    //36
    START1: begin
      SelBlank <= 1;
      Buf0Empty <= 1;
      SyncVB <= 1;
      nextState <= VB1G;
      WE0 <= 1;
      WE1 <= 0;
      //complementary cases
      IncIndex <= 0;
      ResetLine <= 0;
      ResetPx <= 0;
      SelB0 <= 0;
      SelBuf0 <= 0;
    end

    //37
    VB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= VB1G;
    end

    //38
    VB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= VB1B;
    end

    //39
    VB1B: begin
      IncPx <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      //check else condition if code does not run properly
      if(PxOut < (HBOut + AIPOut -2))
        nextState <= VB1R;
      else if(PxOut == (HBOut + AIPOut -2))
        nextState <= ResetVB1R;
    end

    //40
    ResetVB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= ResetVB1G;
    end

    //41
    ResetVB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      if(LineOut < (VBOut - 1))
        nextState <= ResetVB1B;
      else if(LineOut == (VBOut - 1))
        nextState <= Switch1VBtoHB;
    end

    //42
    ResetVB1B: begin
      ResetPx <= 1;
      IncLine <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= VB1R;
    end

    //43
    Switch1VBtoHB: begin
      ResetPx <= 1;
      ResetLine <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= SyncHB1A;
    end

    //44
    SyncHB1A: begin
      SyncHB <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= HB1G;
    end

    //45
    HB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= HB1G;
    end

    //46
    HB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= HB1B;
    end

    //47
    HB1B: begin
      IncPx <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      if(PxOut < (HBOut - 2))
      nextState <= HB1R;
      else if(PxOut == (HBOut - 2))
      nextState <= ResetHB1R;
    end

    //48
    ResetHB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= ResetHB1G;
    end

    //49
    ResetHB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= ResetHB1B;
    end

    //50
    ResetHB1B: begin
      ResetPx <= 1;
      SelBlank <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= R1;
    end

    //51
    R1: begin
      SelR1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= G1;
    end

    //52
    G1: begin
      SelG1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      IncAddr1 <= 1;
      WE0 <= 1;
      nextState <= B1;
    end

    //53
    B1: begin
      IncPx <= 1;
      SelB1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      if(PxOut < (AIPOut - 2))
      nextState <= R1;
      else if(PxOut == (AIPOut - 2))
      nextState <= ResetR1;
    end

    //54
    ResetR1: begin
      SelR1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= ResetG1;
    end

    //55
    ResetG1: begin
      SelG1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= ResetB1;
    end

    //56
    ResetB1: begin
      ResetPx <= 1;
      IncLine <= 1;
      SelB1 <= 1;
      SelBuf1 <= 1;
      WE0 <= 1;
      if(LineOut < (AILOut - 2))
        nextState <= SyncHB1;
      else if(LineOut == (AILOut - 2))
        nextState <= SyncHB1B;
    end

    //57
    SyncHB1: begin
      SyncHB <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= HB1G;
    end

    //58
    SyncHB1B: begin
      SyncHB <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= LastHB1G;
    end

    //59
    LastHB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= LastHB1G;
    end

    //60
    LastHB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= LastHB1B;
    end

    //61
    LastHB1B: begin
      IncPx <= 1;
      SelBlank <= 1;
      WE0 <= 1;
      if(PxOut < (HBOut - 2))
      nextState <= LastHB1R;
      else if(PxOut == (HBOut - 2))
      nextState <= ResetLastHB1R;
    end

    //62
    ResetLastHB1R: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= ResetLastHB1G;
    end

    //63
    ResetLastHB1G: begin
      SelBlank <= 1;
      WE0 <= 1;
      nextState <= ResetLastHB1B;
    end

    //64
    ResetLastHB1B: begin
      ResetPx <= 1;
      SelBlank <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= LastR1;
    end

    //65
    LastR1: begin
      SelR1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= LastG1;
    end

    //66
    LastG1: begin
      SelG1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      IncAddr1 <= 1;
      WE0 <= 1;
      nextState <= LastB1;
    end

    //67
    LastB1: begin
      IncPx <= 1;
      SelB1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      if(PxOut < (AIPOut - 2))
      nextState <= LastR1;
      else if(PxOut == (AIPOut - 2))
      nextState <= ResetLastR1;
    end

    //68
    ResetLastR1: begin
      SelR1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      WE0 <= 1;
      nextState <= ResetLastG1;
    end

    //69
    ResetLastG1: begin
      SelG1 <= 1;
      SelBuf1 <= 1;
      RE1 <= 1;
      ResetAddr1 <= 1;
      WE0 <= 1;
      nextState <= ResetLastB1;
    end

    //70
    ResetLastB1: begin
      ResetLine <= 1;
      ResetPx <= 1;
      SelB1 <= 1;
      SelBuf1 <= 1;
      WE0 <= 1;
      nextState <= START0;
    end
 endcase
end

always @(posedge clk or posedge reset) // always block to update state
begin
  if (reset)
    state <= IDLE;
  else
    state <= nextState;
end
endmodule
