`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:16:47 11/06/2019 
// Design Name: 
// Module Name:    mux 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mux4_1(Out,in1,in2,in3,in4,select
    );
	 //n bit 4 to 1 mux
	parameter n=32;
	output reg [n-1:0]Out;
	input [n-1:0]in1;
	input [n-1:0]in2;
	input [n-1:0]in3;
	input [n-1:0]in4;
	input [1:0]select;
	 always @ (in1 or in2 or in3 or in4 or select)
	 begin
      case (select)
         2'b00 : Out <= in1;
         2'b01 : Out <= in2;
         2'b10 : Out <= in3;
         2'b11 : Out <= in4;
      endcase
	end
endmodule


module mux2_1(Out,in1,in2,select);
//n bit 2 to 1 mux
parameter n=32;
output reg [n-1:0]Out;
input [n-1:0] in1;
input [n-1:0] in2;
input select;
always @ (in1 or in2 or select)
	begin
		case(select)
			1'b0: Out<= in1;
			1'b1: Out<=in2;
		endcase
	end
endmodule

module mux8_1(Out,in1,in2,in3,in4,in5,in6,in7,in8,select);
//n bit 8 to 1 mux
parameter n=32;
output reg [n-1:0]Out;
input [n-1:0] in1;
input [n-1:0] in2;
input [n-1:0] in3;
input [n-1:0] in4;
input [n-1:0] in5;
input [n-1:0] in6;
input [n-1:0] in7;
input [n-1:0] in8;
input [2:0] select;
always @ (in1 or in2 or in3 or in4 or in5 or in6 or in7 or in8 or select)
	begin
		case(select)
			3'd0: Out<=in1;
			3'd1: Out<=in2;
			3'd2: Out<=in3;
			3'd3: Out<=in4;
			3'd4: Out<=in5;
			3'd5: Out<=in6;
			3'd6: Out<=in7;
			3'd7: Out<=in8;
		endcase
	end

endmodule