`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:10:30 11/13/2019
// Design Name:   CPU
// Module Name:   C:/Users/Dell/Desktop/New folder/rv32i/CPU_test.v
// Project Name:  rv32i
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module CPU_test;

	// Inputs
	reg reset;
	reg clk=0;

	// Instantiate the Unit Under Test (UUT)
	initial begin
		// Initialize Inputs
		
    	$dumpfile("CPU_test.vcd");
	    $dumpvars(0,CPU_test);
		reset = 0;
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		reset=1;
		
		#10;
	reset=0;

		
		#10;
		
	
		#10;
		
	
		#10;
		#1000 $finish;

	end
     always #5 clk = !clk; 
	 CPU uut (
		.reset(reset), 
		.clk(clk)
	);
endmodule

