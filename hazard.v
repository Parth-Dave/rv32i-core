`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:34:14 11/11/2019 
// Design Name: 
// Module Name:    hazard 
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

module hazard_unit(PCWrite,stall_IF_ID,stall_ID_EX,stall_EX_MEM,stall_MEM_WB,flush_IF_ID,flush_ID_EX,flush_EX_MEM,flush_MEM_WB,rs1_ID,rs2_ID,rd_EX,rd_MEM,MemRead_EX,MemRead_MEM,Branch_ID,Jump_MEM
    );// check load branch hazard
output reg PCWrite;
output reg stall_IF_ID;
output reg stall_ID_EX;
output reg stall_EX_MEM;
output reg stall_MEM_WB;
output reg flush_IF_ID;
output reg flush_ID_EX;
output reg flush_EX_MEM;
output reg flush_MEM_WB;
input [4:0] rs1_ID;
input [4:0] rs2_ID;
input [4:0] rd_EX;
input [4:0] rd_MEM;
input MemRead_MEM;
input MemRead_EX;
input Branch_ID;
input Jump_MEM;
always @(rs1_ID or rs2_ID or rd_EX or rd_MEM or MemRead_MEM or MemRead_EX or Branch_ID or Jump_MEM)//change from *
begin
	PCWrite<=1'b1;
	stall_IF_ID<=1'b0;
	stall_ID_EX<=1'b0;
	stall_EX_MEM<=1'b0;
	stall_MEM_WB<=1'b0;
	flush_IF_ID<=1'b0;
	flush_ID_EX<=1'b0;
	flush_EX_MEM<=1'b0;
	flush_MEM_WB<=1'b0;
	if(MemRead_EX&&((rd_EX==rs1_ID)|(rd_EX==rs2_ID)))// data hazard load
		begin
			stall_IF_ID<=1'b1;
			flush_ID_EX<=1'b1;
			PCWrite<=1'b0;
		end
	if(Branch_ID&&((rd_EX==rs1_ID)|(rd_EX==rs2_ID)))// data hazard load
		begin
			stall_IF_ID<=1'b1;
			flush_ID_EX<=1'b1;
			PCWrite<=1'b0;
		end
	
	if((Branch_ID&MemRead_EX)&&((rd_EX==rs1_ID)|(rd_EX==rs2_ID)))// data hazard load
		begin
			stall_IF_ID<=1'b1;
			flush_ID_EX<=1'b1;
			PCWrite<=1'b0;
		end
	if((Branch_ID&MemRead_MEM)&&((rd_MEM==rs1_ID)|(rd_MEM==rs2_ID)))// data hazard load
		begin
			stall_IF_ID<=1'b1;
			flush_ID_EX<=1'b1;
			PCWrite<=1'b0;
		end
	if(Jump_MEM)
	begin
		//flush_IF_ID<=1'b1;
		flush_ID_EX<=1'b1;
		flush_EX_MEM<=1'b1;
	end
end
endmodule

module forwarding_unit(Forward1,Forward2,Forward3,Forward4,Forward5,rs1_EX,rs2_EX,rd_MEM,rd_WB,RW_MEM,RW_WB,ALUSrc1,ALUSrc2,MemWrite,branch_ID,rs1_ID,rs2_ID
    );
 output reg [1:0] Forward1;//for OP1
 output reg [1:0] Forward2;//for OP2
 output reg [1:0] Forward3;//for rs2_data in store instructions
 output reg [1:0] Forward4;//for Branch rs1
 output reg [1:0] Forward5;//for Branch rs2
 input [4:0] rs1_EX;
 input [4:0] rs2_EX;
 input [4:0] rd_MEM;
 input [4:0] rd_WB;
 input RW_MEM;
 input RW_WB;
 input ALUSrc1;
 input ALUSrc2;
 input MemWrite;
 input branch_ID;
 input [4:0] rs1_ID;
 input [4:0] rs2_ID;
 

 always @(rs1_EX or rs2_EX or rd_MEM or rd_WB or RW_MEM or RW_WB or ALUSrc1 or ALUSrc2 or MemWrite )//change from *
 begin
	if(MemWrite)                           //IF in MEM and RegWRITE MEM then take from MEM else From WB else don't
	begin												//Might have issues with Load instruction
		if(rd_MEM==rs1_EX && RW_MEM==1'b1)		//forwarding for rs2 data/store instructions Stage
			Forward1<=2'b01;
		else if(rd_WB==rs1_EX && RW_WB==1'b1)
			Forward1<=2'b10;
		else Forward1<=2'b00;

		if(rd_MEM==rs2_EX && RW_MEM==1'b1)
			Forward3<=2'b01;
		else if(rd_WB==rs2_EX && RW_WB==1'b1)
			Forward3<=2'b10;
		else Forward3<=2'b00;
	end
	else
	begin													//forwarding for rs1 and rs2 in EX stage
		if(rd_MEM==rs1_EX && RW_MEM==1'b1 && ALUSrc1==1'b0)
			Forward1<=2'b01;
		else if(rd_WB==rs1_EX && RW_WB==1'b1 && ALUSrc1==1'b0)
			Forward1<=2'b10;
		else Forward1<=2'b00;

		if(rd_MEM==rs2_EX && RW_MEM==1'b1 && ALUSrc2==1'b0)
			Forward2<=2'b01;
		else if(rd_WB==rs2_EX && RW_WB==1'b1 && ALUSrc1==1'b0)
			Forward2<=2'b10;
		else Forward2<=2'b00;
	end
 end

 always @(rd_MEM or rd_WB or RW_MEM or RW_WB or branch_ID or rs1_ID or rs2_ID )// 00 regfile| 01 MEM| 10 WB change from *
 begin
	 if(branch_ID)
	 begin
		if(rd_MEM==rs1_ID && RW_MEM==1'b1 )
			Forward4<=2'b01;
		else if(rd_WB==rs1_ID && RW_WB==1'b1)
			Forward4<=2'b10;
		else Forward4<=2'b00;
		
		if(rd_MEM==rs2_ID && RW_MEM==1'b1 )
			Forward5<=2'b01;
		else if(rd_WB==rs2_ID && RW_WB==1'b1)
			Forward5<=2'b10;
		else Forward5<=2'b00;
	end
 end
endmodule

