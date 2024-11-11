`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Slide Switches module
    // This module defines the address, and logic used for the onboard slide switches
    // The status of the slide switches are read into the internal register Out
    // Register Out is written to the address bus when address matching occurs
    //
    // Module is generic, so can be instantiated multiple times, unique addresses must then be specified in the wrapper at instantiation
    //
    // Parameters: 
    // - SlideSwitchesBaseAddr: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - SW_IN: 8-bit signal from the switches 
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    //
    // Output:
    // - BUS_DATA: 8-bit data bus, used for reading from or writing to memory and peripherals
//////////////////////////////////////////////////////////////////////////////////


module SlideSwitches(
	//Standard inputs
   input 		 CLK,
   input		 RESET,
	//slide switches input value
	input [7:0] SW_IN,
	//BUS signals 
	output  [7:0] BUS_DATA, 
	input  [7:0] BUS_ADDR,
	input  		 BUS_WE
    );
	
	parameter [7:0] SlideSwitchesBaseAddr = 8'hB0;

	reg 	[7:0]	Out;
	reg			    SWBusWE = 1'b0;


	
												
	always@(posedge CLK) begin
		// Brute-force address decoding. Think of a simpler way...
		if(BUS_ADDR == SlideSwitchesBaseAddr) begin
			if(BUS_WE) begin
				SWBusWE <= 1'b0;
			end else
				SWBusWE <= 1'b1;
		end else
			SWBusWE <= 1'b0;
		
		Out 	<= SW_IN;
	end
	
	//Only place data on the bus if the processor is NOT writing, and it is addressing this memory
    assign BUS_DATA     = ((SWBusWE))? Out : 8'hZZ;  	
	
endmodule





