`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:02:05 11/06/2019 
// Design Name: 
// Module Name:    Imm_gen 
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
`include "mux.v"
module sign_extend(out,in,signExtend);
	parameter n1=32;
	parameter n2=12;
	output [n1-1:0] out;
	input [n2-1:0] in;
	input signExtend;
	assign out = {{(n1-n2){(in[n2-1]&signExtend)}},in};
endmodule
module Imm_gen(imm,in,ImmType,SignExtendCtrl
    );
	output [31:0] imm;
	input [31:7] in;
	input [2:0] ImmType;
	input SignExtendCtrl;
	
	
	wire [11:0] a;
	mux8_1 #(12) m8_12(a,{in[31],in[7],in[30:25],in[11:8]},in[31:20],{in[31:25],in[11:7]},12'd0,12'd0,12'd0,12'd0,12'd0,ImmType);
	
	wire [31:0] b;//Btype,IType
	sign_extend SE1(b,a,SignExtendCtrl);
	
	wire [31:0] c;//J Type
	sign_extend #(32,20) SE2(c,{in[31],in[19:12],in[7],in[30:21]},SignExtendCtrl);
	
	wire [31:0] d;//sh Type
	sign_extend #(32,5) SE3(d,in[24:20],SignExtendCtrl);
	
	mux8_1 #(32) m8_32(imm,{b[30:0],1'b0},b,b,{in[31:12],12'd0},{c[30:0],1'b0},d,32'd0,32'd0,ImmType);
endmodule

