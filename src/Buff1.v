module Buf1(R1,B1,G1,RE1,WE1,Addr1,WData, clk, reset);
  input RE1,WE1, clk, reset;
  input [19:0]Addr1;
  input [31:0] WData;

  wire RE1,WE1, clk, reset;
  wire [19:0]Addr1;
  wire [31:0] WData;

  output [7:0]R1;
  output [7:0]B1;
  output [7:0]G1;

  reg [7:0]R1;
  reg [7:0]B1;
  reg [7:0]G1;
  reg [23:0] buff1[9999:0];
  reg [23:0]result;
  always @ (posedge clk)
    begin
      if(reset==1) begin
        R1 = 0;
        B1 = 0;
        G1 = 0;
  	  end
      else begin
        if(WE1 == 1 && RE1 == 0) begin
          buff1[Addr1] = WData;
        end
        if(WE1 == 0 && RE1 == 1) begin
        result = buff1[Addr1];
          R1 = result[7:0];
          G1 = result[15:8];
          B1 = result[23:16];
        end
      end

    end

endmodule
