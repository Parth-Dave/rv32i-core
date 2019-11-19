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
	output reg [l-1:0] Out1;
	output reg [l-1:0] Out2;
	input [n-1:0] Ad1;
	input [n-1:0] Ad2;
	input [n-1:0] WrAd;
	input [l-1:0] WrData;
	input Wr;
	input reset;
	input clk;
	reg [l-1:0]mem[N-1:0];
	integer i;
	
	always @(posedge clk)
	begin
	if(reset)
		for(i=0;i<N;i=i+1)
			mem[i]<=0;
	else
		if(Wr)
		begin
			mem[WrAd]<=WrData;
			mem[0]<=32'd0;
		end
		Out1<=mem[Ad1];
		Out2<=mem[Ad2];
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
		if(reset)
			begin
				for(i=0;i<N;i=i+1)
				mem[i]<=0;
			end
		else
		begin
			if(w)
				mem[Ad]<=Data;
			if(r)
				Out<=mem[Ad];
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
	always @(posedge clk)
	begin
	if(reset)
	begin
		for(i=0;i<N;i=i+4)
		begin
				mem[i]<=8'h13;
				mem[i+1]<=8'd0;
				mem[i+2]<=8'd0;
				mem[i+3]<=8'd0;
		end
	end
	else
		Out<={mem[Ad+3],mem[Ad+2],mem[Ad+1],mem[Ad]};
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
			if(reset)
				Out<=0;
			else if(stall)
				Out<=Out;
			else
				Out<=in;
		end
endmodule
