`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:56:25 11/11/2019 
// Design Name: 
// Module Name:    CPU 
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
`include "control_unit.v"
`include "ALU_32.v"
`include "hazard.v"
`include "Imm_gen.v"
`include "reg_file.v"
module CPU(reset,clk
    );
input clk;
input reset;


//IF stage
wire [31:0] BrData_IF;
wire [31:0] PC_4_IF;
wire Bsrc;
wire [31:0] to_PC;
wire [31:0] PC_IF;
wire [31:0] I_IF;
wire exception_opcode;

//ID
wire comp_result_ID;
wire BType_ID;
wire [31:0] PC_4_ID;
wire [31:0] PC_ID;
wire [31:0] I_ID;
wire [4:0] rs1_ID;
wire [4:0] rs2_ID;
wire [4:0] rd_ID;
wire [`iCtrl_length-1:0] Ctrl_in;
wire [24:0] imm_in;
wire I_30_ID;
wire I_12_ID;
wire [2:0] funct3_ID;
wire ALUSrc1_ID;
wire ALUSrc2_ID;
wire Branch_ID;
wire [2:0] ImmType_ID;
wire RegWrite_ID;
wire MemtoReg_ID;
wire MemRead_ID;
wire MemWrite_ID;
wire SECtrl_ID;
wire Jump_ID;
wire LCtrl_ID;
wire isIType_ID;
wire [`Ctrl_length-1:0] Ctrl_ID;
wire [31:0] Imm_ID;
wire [31:0] rs1_data_ID;
wire [31:0] rs2_data_ID;
wire [31:0] Lctrl_op_ID;
wire [31:0] Op1_ID;
wire [31:0] Op2_ID;
wire [31:0] rs1_branch_ID;
wire [31:0] rs2_branch_ID;
wire [`IF_ID-1:0] to_IF_ID;

//EX
wire [31:0] ALU_EX;
wire Jump_EX;
wire [`Ctrl_length-1:0] Ctrl_EX;
wire [31:0] PC_EX;
wire [31:0] PC_4_EX;
wire [31:0] Op1_EX;
wire [31:0] Op2_EX;
wire [31:0] rs2_data_EX;
wire [31:0] Imm_EX;
wire [4:0] rd_EX;
wire [4:0] rs1_EX;
wire [4:0] rs2_EX;
wire [`ID_EX-1:0] to_ID_EX;
wire I_30_EX;
wire I_12_EX;
wire [2:0] funct3_EX;
wire ALUSrc1_EX;
wire ALUSrc2_EX;
wire Branch_EX;
wire [2:0] ImmType_EX;
wire RegWrite_EX;
wire MemtoReg_EX;
wire MemRead_EX;
wire MemWrite_EX;
wire SECtrl_EX;
wire LCtrl_EX;
wire isIType_EX;
wire [31:0] ALU_op1;
wire [31:0] ALU_op2;
wire [31:0] rs2_data_fin_EX;
wire [3:0] ALUCtrl_EX;
wire SigA;


//MEM
wire exception_mem_4byte;
wire [`Ctrl_length-1:0] Ctrl_MEM;
wire [31:0] PC_4_MEM;
wire [31:0] rs2_data_MEM;
wire I_30_MEM;
wire I_12_MEM;
wire [2:0] funct3_MEM;
wire ALUSrc1_MEM;
wire ALUSrc2_MEM;
wire Branch_MEM;
wire [2:0] ImmType_MEM;
wire MemtoReg_MEM;
wire MemRead_MEM;
wire MemWrite_MEM;
wire SECtrl_MEM;
wire Jump_MEM;
wire LCtrl_MEM;
wire isIType_MEM;
wire [31:0] ReadData_MEM;
wire [31:0] ALU_MEM;
wire RegWrite_MEM;
wire [4:0] rd_MEM;
wire [`EX_MEM-1:0] to_EX_MEM;

//WB
wire [`Ctrl_length-1:0] Ctrl_WB;
wire [31:0] PC_4_WB;
wire [31:0] ALU_WB;
wire [31:0] ReadData_WB;
wire I_30_WB;
wire I_12_WB;
wire [2:0] funct3_WB;
wire ALUSrc1_WB;
wire ALUSrc2_WB;
wire Branch_WB;
wire [2:0] ImmType_WB;
wire MemtoReg_WB;
wire MemRead_WB;
wire MemWrite_WB;
wire SECtrl_WB;
wire Jump_WB;
wire LCtrl_WB;
wire isIType_WB;
wire [4:0] rd_WB;
wire [31:0] wr_data_WB;
wire RegWrite_WB;

//Hazard
wire stall_IF_ID;
wire stall_ID_EX;
wire stall_EX_MEM;
wire stall_MEM_WB;
wire flush_IF_ID;
wire flush_ID_EX;
wire flush_EX_MEM;
wire flush_MEM_WB;
wire PCWrite;

//Forwarding
wire [1:0]ForwardA;
wire [1:0]ForwardB;
wire [1:0]ForwardC;
wire [1:0]ForwardD;
wire [1:0]ForwardE;

assign PC_4_IF=PC_IF+32'd4;
mux4_1 #(32) PC_in(to_PC,PC_4_IF,BrData_IF,{ALU_EX[31:1],1'b0},{ALU_EX[31:1],1'b0},{Jump_EX,Bsrc});
register #(32) PC(PC_IF,to_PC,PCWrite,reset,clk);



reg_file_I #(7,32) Inst_mem(I_IF,PC_IF[6:0],reset,clk);


assign exception_opcode=I_IF[0]&I_IF[1];


hazard_unit HAZARD(PCWrite,stall_IF_ID,stall_ID_EX,stall_EX_MEM,stall_MEM_WB,flush_IF_ID,flush_ID_EX,flush_EX_MEM,flush_MEM_WB,rs1_ID,rs2_ID,rd_EX,rd_MEM,MemRead_EX,MemRead_MEM,Branch_ID,Jump_MEM);

//IF_ID pipeline register

mux2_1 #(`IF_ID) IF_ID_FLUSH(to_IF_ID,{PC_4_IF,PC_IF,I_IF},`NOP_IF_ID,flush_IF_ID);//|Bsrc
pipeline_reg #(`IF_ID) IF_ID({PC_4_ID,PC_ID,I_ID},to_IF_ID,stall_IF_ID,reset,clk);
 
//ID Stage


assign rs1_ID=I_ID[19:15];
assign rs2_ID=I_ID[24:20];
assign rd_ID=I_ID[11:7];
assign Ctrl_in={I_ID[30],I_ID[14:12],I_ID[6:2]};
assign imm_in=I_ID[31:7];

//Control Unit


assign {I_30_ID,I_12_ID,funct3_ID,ALUSrc1_ID,ALUSrc2_ID,Branch_ID,ImmType_ID,RegWrite_ID,MemtoReg_ID,MemRead_ID,MemWrite_ID,SECtrl_ID,Jump_ID,LCtrl_ID,isIType_ID}=Ctrl_ID;
control_unit Ctrl_unit(Ctrl_ID,Ctrl_in);


//Imm Generation


Imm_gen imm_gen(Imm_ID,imm_in,ImmType_ID,SECtrl_ID);

//register file



reg_file Reg_File(rs1_data_ID,rs2_data_ID,rs1_ID,rs2_ID,rd_WB,wr_data_WB,RegWrite_WB,reset,clk);


mux2_1 #(32) MUX1_ID(Lctrl_op_ID,PC_ID,32'd0,LCtrl_ID);
mux2_1 #(32) MUX2_ID(Op1_ID,rs1_data_ID,Lctrl_op_ID,ALUSrc1_ID);
mux2_1 #(32) MUX3_ID(Op2_ID,rs2_data_ID,Imm_ID,ALUSrc2_ID);


//Branch Address calulation and comparision
assign BrData_IF=$signed(PC_ID)+$signed(Imm_ID);



mux4_1 #(32) BR1_MUX(rs1_branch_ID,rs1_data_ID,ALU_MEM,wr_data_WB,32'd0,ForwardD);
mux4_1 #(32) BR2_MUX(rs2_branch_ID,rs2_data_ID,ALU_MEM,wr_data_WB,32'd0,ForwardE);


comparator #(32) branch_comp(comp_result_ID,rs1_branch_ID,rs2_branch_ID,funct3_ID[2:1]);

mux2_1 #(1) BRANCH_SELECT(BType_ID,~comp_result_ID,comp_result_ID,I_12_ID);
    assign Bsrc=Branch_ID & BType_ID;

//ID_EX Pipeline Register
mux2_1 #(`ID_EX) ID_EX_FLUSH(to_ID_EX,{Ctrl_ID,PC_ID,PC_4_ID,Op1_ID,Op2_ID,rs2_data_ID,Imm_ID,rd_ID,rs1_ID,rs2_ID},`NOP_ID_EX,flush_ID_EX);
pipeline_reg #(`ID_EX) ID_EX({Ctrl_EX,PC_EX,PC_4_EX,Op1_EX,Op2_EX,rs2_data_EX,Imm_EX,rd_EX,rs1_EX,rs2_EX},to_ID_EX,stall_ID_EX,reset,clk);

//EX Stage

assign {I_30_EX,I_12_EX,funct3_EX,ALUSrc1_EX,ALUSrc2_EX,Branch_EX,ImmType_EX,RegWrite_EX,MemtoReg_EX,MemRead_EX,MemWrite_EX,SECtrl_EX,Jump_EX,LCtrl_EX,isIType_EX}=Ctrl_EX;

//Forwarding Unit


forwarding_unit Forw_unit(ForwardA,ForwardB,ForwardC,ForwardD,ForwardE,rs1_EX,rs2_EX,rd_MEM,rd_WB,RegWrite_MEM,RegWrite_WB,ALUSrc1_EX,ALUSrc2_EX,MemWrite_EX,Branch_ID,rs1_ID,rs2_ID);

//ALU and ALU control

assign SigA=MemtoReg_EX|Jump_EX|ALUSrc1_EX;

ALU_control ALUCTRL(ALUCtrl_EX,funct3_EX,I_30_EX,SigA,isIType_EX,Branch_EX);

 
mux4_1 #(32) OP1_MUX(ALU_op1,Op1_EX,ALU_MEM,wr_data_WB,32'd0,ForwardA);
mux4_1 #(32) OP2_MUX(ALU_op2,Op2_EX,ALU_MEM,wr_data_WB,32'd0,ForwardB);
mux4_1 #(32) RS2_MUX(rs2_data_fin_EX,Op1_EX,ALU_MEM,wr_data_WB,32'd0,ForwardC);



ALU_32 ALU(ALU_EX,ALU_op1,ALU_op2,ALUCtrl_EX);


//changed to EX stage from MEM


assign exception_mem_4byte=Jump_EX & ALU_EX[1];

//Pipeline register EX_MEM
mux2_1 #(`EX_MEM) EX_MEM_FLUSH(to_EX_MEM,{Ctrl_EX,PC_4_EX,ALU_EX,rs2_data_fin_EX,rd_EX},`NOP_EX_MEM,flush_EX_MEM);

pipeline_reg #(`EX_MEM) EX_MEM({Ctrl_MEM,PC_4_MEM,ALU_MEM,rs2_data_MEM,rd_MEM},to_EX_MEM,stall_EX_MEM,reset,clk);

//MEM Stage

assign {I_30_MEM,I_12_MEM,funct3_MEM,ALUSrc1_MEM,ALUSrc2_MEM,Branch_MEM,ImmType_MEM,RegWrite_MEM,MemtoReg_MEM,MemRead_MEM,MemWrite_MEM,SECtrl_MEM,Jump_MEM,LCtrl_MEM,isIType_MEM}=Ctrl_MEM;


reg_file_D #(5,32) Data_MEM(ReadData_MEM,ALU_MEM[4:0],rs2_data_MEM,MemRead_MEM,MemWrite_MEM,reset,clk);


//Pipeline Register MEM_WB


pipeline_reg #(`MEM_WB) MEM_WB({Ctrl_WB,PC_4_WB,ALU_WB,ReadData_WB,rd_WB},{Ctrl_MEM,PC_4_MEM,ALU_MEM,ReadData_MEM,rd_MEM},1'b0,reset,clk);

//WB Stage

assign {I_30_WB,I_12_WB,funct3_WB,ALUSrc1_WB,ALUSrc2_WB,Branch_WB,ImmType_WB,RegWrite_WB,MemtoReg_WB,MemRead_WB,MemWrite_WB,SECtrl_WB,Jump_WB,LCtrl_WB,isIType_WB}=Ctrl_WB;

mux4_1 #(32) WBMUX(wr_data_WB,ALU_WB,PC_4_WB,ReadData_WB,32'd0,{MemtoReg_WB,Jump_WB});

endmodule