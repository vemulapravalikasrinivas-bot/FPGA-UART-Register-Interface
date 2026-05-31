
`timescale 1ns / 1ps
module hex_ascii(
  input [3:0] nib,
  output reg [7:0] out);
  
  always @(*) begin
    case(nib)
      	4'h0:out="0";
        4'h1:out="1";
        4'h2:out="2";
        4'h3:out="3";
        4'h4:out="4";
        4'h5:out="5";
        4'h6:out="6";
        4'h7:out="7";
        4'h8:out="8";
        4'h9:out="9";
        4'hA:out="A";
        4'hB:out="B";
        4'hC:out="C";
        4'hD:out="D";
        4'hE:out="E";
        4'hF:out="F";
      default: out="?";
    endcase
  end
endmodule
