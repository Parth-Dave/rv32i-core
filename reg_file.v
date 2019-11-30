`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:06 11/06/2019 
// Design Name: 
// Module Name:    reg_file 
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
module reg_file(Out1,Out2,Ad1,Ad2,WrAd,WrData,Wr,reset,clk
    );
	 //l bit 2^n entry register file with 2 read and 1 write port
	parameter n=5;
	parameter l=32;
	localparam N = 1 << n;
	output reg [l-1:0] Out1;//make using d flipflops
	output reg [l-1:0] Out2;
	input [n-1:0] Ad1;
	input [n-1:0] Ad2;
	input [n-1:0] WrAd;
	input [l-1:0] WrData;
	input Wr;
	input reset;
	input clk;
	reg [l-1:0]mem[N-1:0];//don't use mem variable name for reg_file
	integer i;
	
	always @(clk or Ad1 or Ad2)// change to level and negedge for write
	begin
		if(clk)
		begin
			Out1<=32'd0;
			Out2<=32'd0;
			if(reset)//avoid for loop
				for(i=0;i<N;i=i+1)
					mem[i]<=0;
			else	
				Out1<=mem[Ad1];
				Out2<=mem[Ad2];
		end
	end
	always@(negedge clk)
	begin
		if(Wr)
			begin
				mem[WrAd]<=WrData;
				mem[0]<=32'd0;
			end
	end
endmodule

module reg_file_D(Out,Ad,Data,r,w,reset,clk);
//l bit 2^n entry register file with write
	parameter n=5;
	parameter l=32;
	localparam N = 1 << n;
	output reg [l-1:0] Out;
	input [n-1:0] Ad;
	input [l-1:0] Data;
	input r;
	input w;
	input reset;
	input clk;
	reg [l-1:0] mem [N-1:0];
	integer i;
	always @ (posedge clk)
	begin
		Out<=0;	
		if(reset)
			begin
				for(i=0;i<N;i=i+1)
				mem[i]<=0;
			end
		else
		begin
			if(r)
				Out<=mem[Ad];
		end
	end
	always@(negedge clk)
	begin
		if(w)
			begin
				mem[Ad]<=Data;
			end
	end
endmodule

module reg_file_I(Out,Ad,reset,clk);
//l bit 2^n entry register file without write
	parameter n=8;
	parameter l=32;
	localparam N = 1 << n;
	output reg [l-1:0] Out;
	input [n-1:0] Ad;
	input reset; 
	input clk;
	reg [l/4-1:0] mem [N-1:0];
	integer i;
	always @(reset)
	begin
	Out<=32'd0;
	if(reset)
	begin
	/*
	addi x11 x11 5
	addi x12 x12 0
	lw x10 4(x12)
	beq x10 x11 12
	addi x10 x10 1
	jal x1 12
	addi x10 x10 10
	*/
		mem[0]<=8'h93;//addi x11 x11 5
		mem[1]<=8'h85;
		mem[2]<=8'h55;
		mem[3]<=8'h00;
		
		mem[4]<=8'h13;//addi x12 x12 0
		mem[5]<=8'h06;
		mem[6]<=8'h06;
		mem[7]<=8'h00;
		
		mem[8]<=8'h03;//lw x10 4(x12)
		mem[9]<=8'h25;
		mem[10]<=8'h46;
		mem[11]<=8'h00;

		mem[12]<=8'h63;‬//beq x10 x11 12
		mem[13]<=8'h06;
		mem[14]<=8'hB5;
		mem[15]<=8'h00;

		mem[16]<=8'h13;‬//addi x10 x10 1
		mem[17]<=8'h05;
		mem[18]<=8'h15;
		mem[19]<=8'h00;
		
		mem[20]<=8'hEF;‬//jal x1 -8
		mem[21]<=8'hF0;
		mem[22]<=8'h9F;
		mem[23]<=8'hFF;
		
		mem[24]<=8'h13;//addi x10 x10 10
		mem[25]<=8'h05;
		mem[26]<=8'hA5;
		mem[27]<=8'h00;
		for(i=28;i<N;i=i+4)
		begin
				mem[i]<=8'h13;
				mem[i+1]<=8'd0;
				mem[i+2]<=8'd0;
				mem[i+3]<=8'd0;
		end
	end
end
always @(clk)
begin
	if(!reset)
	begin
		Out<={mem[Ad+3],mem[Ad+2],mem[Ad+1],mem[Ad]};
	end
end
endmodule

module register(Out,in,en,reset,clk);
//l bit register, used for PC
parameter l=32;
output reg [l-1:0] Out;
input [l-1:0] in;
input en;
input reset;
input clk;

always @ (posedge clk )
	begin
		
		
			Out<=32'd0;
			if(reset)
				Out<=0;
			else if(!en)
				Out<=Out;
			else
				Out<=in;
		
	end
endmodule

module pipeline_reg(Out,in,stall,reset,clk);// doesn't change value if stall, use mux at input for flush with nop
	parameter n=128;
	output reg [n-1:0] Out;
	input [n-1:0] in;
	input stall ;
	input clk;
	input reset;
	always @( posedge clk)
		begin	
			Out<=0;
			if(reset)
				Out<=0;
			else if(stall)
				Out<=Out;
			else
				Out<=in;
		end
endmodule
