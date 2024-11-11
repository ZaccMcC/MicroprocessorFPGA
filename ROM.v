`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // ROM module
    // This module defines memory to be allocated for the ROM, reading and storing the ROM instructions from the file specifed as "ROM"
    // It provides data based on the specified memory addresses from the processor
    //
    // Parameters:
    // - RAMAddrWidth: Defines the width of the address bus used to index ROM (as 8-bits) 
    // - 
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    //
    // Outputs:
    // - DATA: 8-bit data signal the value at the address specified by ADDR
//////////////////////////////////////////////////////////////////////////////////
module ROM(	
	//standard signals
	input 				CLK,
	//BUS signals
	output	reg	[7:0]		DATA,
	input		[7:0]		ADDR
    );

	parameter RAMAddrWidth	= 8;
	
	//Memory
	reg [7:0] ROM [2**RAMAddrWidth-1:0];

	// Load program
//	initial	$readmemh("Complete_Demo_ROM.txt", ROM);
	initial	$readmemh("C:/Users/zmccaf200/Downloads/cw2Improved/cw2Improved.srcs/constrs_1/imports/Downloads/ROM.txt", ROM);
	
								
	//single port ram
	always@(posedge CLK)
		DATA <= ROM[ADDR];


endmodule
