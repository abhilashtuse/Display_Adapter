module Buf0(R0,B0,G0,RE0,WE0,Addr0,WData, clk, reset);
  input RE0,WE0, clk, reset;
  input [19:0]Addr0;
  input [31:0] WData;

  output [7:0]R0;
  output [7:0]B0;
  output [7:0]G0;

  reg [7:0]R0;
  reg [7:0]B0;
  reg [7:0]G0;
  reg [23:0] buff0[9999:0];
  reg [23:0]result;
  always @ (posedge clk)
    begin
      if(reset==1) begin
        G0 = 0;
        B0 = 0;
        R0 = 0;
  	  end
      else begin
        if(WE0 == 1 && RE0 == 0) begin
          buff0[Addr0] = WData;
        end
        if(WE0 == 0 && RE0 == 1) begin
        result = buff0[Addr0];
          R0 = result[7:0];
          G0 = result[15:8];
          B0 = result[23:16];
        end
      end

    end

endmodule
