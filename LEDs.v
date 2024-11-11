`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // LED module
    // This module defines the address, and logic used for the LEDs
    // The status of the LED are stored on the internal register "LedRegData"
    // Register LedRegData can be, when address matching occurs:
    //       Read to the address bus, when write enable is low
    //       Written to by the address bus, when write enable is high
    //
    // Module is generic, so can be instantiated multiple times, unique addresses must then be specified in the wrapper at instantiation
    //
    // Parameters: 
    // - LEDsBaseAddr: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    //
    //
    // Output:
    // - BUS_DATA: 8-bit data bus, used for reading from or writing to memory and peripherals
    // - LED_OUT: 8-bit signal connected to the LEDs 
//////////////////////////////////////////////////////////////////////////////////
    //LEDs module interface
module LEDs(
	//Standard inputs
   input 		 CLK,
   input		    RESET,
	//BUS signals 
	inout  [7:0] BUS_DATA, 
	input  [7:0] BUS_ADDR,
	input  		 BUS_WE,
	//LEDs output signal
	output [7:0] LED_OUT
	);
	
	parameter [7:0] LEDsBaseAddr = 8'hC0;
		
	reg [7:0] LedRegData;
	
	//Check if LEDs is addressed and read the  status
	always@(posedge CLK) begin 
		if(RESET)
			LedRegData <= 8'h00;
		else if((BUS_ADDR == LEDsBaseAddr) & BUS_WE)
			LedRegData <= BUS_DATA;
	end
	
	//Tie the status to the data bus
	assign BUS_DATA = ((BUS_ADDR == LEDsBaseAddr) && !BUS_WE)? LedRegData: 8'hZZ;
	//Tie the register to the output LEDS
	assign LED_OUT = LedRegData;
	
endmodule
    
