`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:55:06 11/09/2019 
// Design Name: 
// Module Name:    define 
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
`define BRANCH_OP   5'b11000
`define JALR_OP 	5'b11001
`define LOAD_OP 	5'b00000
`define ARTI_OP 	5'b00100
`define ART_OP 	    5'b01100
`define LUI_OP 	    5'b01101
`define AUIPC_OP 	5'b00101
`define JAL_OP 	    5'b11011
`define STORE_OP 	5'b01000

`define fLTU 		3'b011

`define B_Type		3'b000
`define I_Type		3'b001
`define S_Type		3'b010
`define U_Type      3'b011
`define J_Type		3'b100
`define sh_Type	    3'b101


`define IF_ID 		96
`define ID_EX 		226
`define EX_MEM		120
`define MEM_WB		120

`define Ctrl_length 19
`define iCtrl_length 9



`define NOP_ID_EX      {19'h0,32'd0,32'd0,32'd0,32'd0,32'd0,32'd0,15'd0}
`define NOP_IF_ID      {32'd0,32'd0,32'h00000013}
`define NOP_EX_MEM     {19'h0,32'd0,32'd0,32'd0,5'd0} 