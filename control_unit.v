`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:56 11/09/2019 
// Design Name: 
// Module Name:    control_unit 
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
`include "define.v"
module control_unit(Ctrl,in
    );
	parameter N=`Ctrl_length;
	parameter M=`iCtrl_length;
	output [N-1:0] Ctrl;
	input [M-1:0] in;
	wire I_30;
	wire [2:0] funct3;
	wire [4:0] opcode;
	assign opcode=in[4:0];
	assign funct3=in[7:5];
	assign I_30=in[8];
	
	reg ALUSrc1;
	reg ALUSrc2;
	reg Branch;
	reg [2:0]ImmType;
	reg RegWrite;
	reg MemtoReg;
	reg MemRead;
	reg MemWrite;
	reg SignExtendCtrl;
	reg Jump;
	reg Lctrl;
	reg isItype;
	reg I_12;
	
		
	always @(*)
	begin
		case (opcode)
			`BRANCH_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b0;
					Branch<=1'b1;
					ImmType<=`B_Type;
					RegWrite<=1'b0;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b1;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b0;
					I_12 <= in[5];
				end
			`JALR_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`I_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b1;
					Jump<=1'b1;
					Lctrl<=1'b0;
					isItype<=1'b1;
					I_12 <= in[5];
				end
			`LOAD_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`I_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b1;
					MemRead<=1'b1;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b1;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b1;
					I_12 <= in[5];
				end
				
			`ARTI_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					if(funct3==3'b001||funct3==3'b101)
						ImmType<=`sh_Type;
					else
						ImmType<=`I_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					if(funct3==`fLTU)
						SignExtendCtrl<=1'b0;
					else
						SignExtendCtrl<=1'b1;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b1;
					I_12 <= in[5];
				end
				
			`ART_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b0;
					Branch<=1'b0;
					ImmType<=`I_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b0;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b0;
					I_12 <= in[5];
				end
				
			`LUI_OP :
				begin
					ALUSrc1<=1'b1;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`U_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b0;
					Jump<=1'b0;
					Lctrl<=1'b1;
					isItype<=1'b0;
					I_12 <= in[5];
				end
			
			`AUIPC_OP :
				begin
					ALUSrc1<=1'b1;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`U_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b0;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b0;
					I_12 <= in[5];
				end
			`JAL_OP :
				begin
					ALUSrc1<=1'b1;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`J_Type;
					RegWrite<=1'b1;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b0;
					SignExtendCtrl<=1'b1;
					Jump<=1'b1;
					Lctrl<=1'b0;
					isItype<=1'b0;
					I_12 <= in[5];
				end
				
			`STORE_OP :
				begin
					ALUSrc1<=1'b0;
					ALUSrc2<=1'b1;
					Branch<=1'b0;
					ImmType<=`S_Type;
					RegWrite<=1'b0;
					MemtoReg<=1'b0;
					MemRead<=1'b0;
					MemWrite<=1'b1;
					SignExtendCtrl<=1'b1;
					Jump<=1'b0;
					Lctrl<=1'b0;
					isItype<=1'b0;
					I_12 <= in[5];
				end
		endcase
	end
assign Ctrl = {I_30,I_12,funct3,ALUSrc1,ALUSrc2,Branch,ImmType,RegWrite,MemtoReg,MemRead,MemWrite,SignExtendCtrl,Jump,Lctrl,isItype};
endmodule
