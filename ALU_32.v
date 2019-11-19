`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:31:31 11/06/2019 
// Design Name: 
// Module Name:    ALU_32 
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
module ALU_32(Out,Op1,Op2,ALUCtrl);
	output reg [31:0] Out;
	input [31:0] Op1;
	input [31:0] Op2;
	input [3:0] ALUCtrl;
	
	//confirm sign / unsigned
	always @(*)
		begin
			case(ALUCtrl)
			4'b0000://ADD
			Out<=$signed(Op1)+$signed(Op2);
			4'b1000://SUB 
			Out<=$signed(Op1)-$signed(Op2);
			4'b0011://Less than Unsigned
			Out<=(Op1<Op2)?32'd0:32'd1;
			4'b0010://Less than signed
			Out<=($signed(Op1)<$signed(Op2))?32'd0:32'd1;
			4'b1100://Equal
			Out<=(Op1==Op2)?32'd0:32'd1;
			4'b0100://XOR
			Out<=Op1^Op2;
			4'b0110://OR
			Out<=Op1|Op2;
			4'b0111://AND
			Out<=Op1&Op2;
			4'b0001://SHIFT LEFT
			Out<=Op1<<Op2;
			4'b0101://SHIFT RIGHT
			Out<=Op1>>Op2;
			4'b1101://SHIFT RIGHT ARITHMETIC
			Out<=Op1>>>Op2;
			default:Out<=Op1+Op2;
			endcase
		end
endmodule

module ALU_control(ALUCtrl,func3,I,SigA,isItype,Branch);
	output [3:0] ALUCtrl;
	input [2:0] func3;
	input I;
	input SigA;
	input isItype;
	input Branch;
//Generates the 4 bit alu control signal from normal control, SigA is MemtoReg||Jump||ALUSrc1, I is I[30]
	assign ALUCtrl =  Branch ? {~func3[2],~func3[2],func3[2:1]} :
                  SigA ? 4'b0000 :
                  isItype ? {1'b0,func3} : 
                      {I,func3};
endmodule

module comparator(Out,in1,in2,type);
	parameter n=32;
	output reg Out;
	input [n-1:0]in1;
	input [n-1:0]in2;
	input [1:0]type;

	always @(*)
	begin
		case(type)
		2'b00:
		Out<=(in1==in2);
		2'b10:
		Out<=($signed(in1)<$signed(in2))?1'd0:1'd1;
		2'b11:
		Out<=(in1<in2)?1'd0:1'd1;
		default:
		Out<=1;
		endcase
	end
endmodule