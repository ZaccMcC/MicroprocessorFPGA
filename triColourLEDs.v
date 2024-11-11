`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // tri-colour LED module
    // This module defines the address, and logic used for the tri-colour LED
    // The status of the LED is stored on the internal register "LedRegData"
    // Module uses the centralised address decoder module to perform address matching
    // When matching occurs, a unique wire is set high, recieved as "WE" by this module
    //
    // Module is generic, so can be instantiated multiple times, unique addresses must then be specified in the wrapper at instantiation
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - WE: Signal from the address decoder indicating address matched by processor operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation
    //
    // In/Output:
    // - BUS_DATA: 8-bit bidirectional data bus, used for reading from or writing to memory and peripherals
    //
    // Output:
    // - RGB_OUT: 2-bit signal connected to the LEDs 
//////////////////////////////////////////////////////////////////////////////////


module triColourLEDs(
            //Standard inputs
        input          CLK,
        input            RESET,
        //BUS signals 
        inout  [7:0] BUS_DATA, 
        

        input          BUS_WE,
        input          WE, // Write enable signal from address decoder
        
        //LEDs output signal
        output [2:0] RGB_OUT
        );


        
    reg [7:0] LedRegData;
    
    //Check if LEDs is addressed and read the status
    always@(posedge CLK) begin 
        if(RESET)
            LedRegData <= 8'h00;
            
         //Checking processor WE and address decoder WE
	         //i.e. Write to peripheral operation
			   else if (WE && BUS_WE) 
          			   // ^^ replaces logic ->       else if((BUS_ADDR == LEDsBaseAddr) & BUS_WE)
			         LedRegData <= BUS_DATA; // Assign data to internal register
			         

			
    end
    
    //Tie the status to the data bus
		    //Checking for read from peripheral operation
		    // If not, set BUS_DATA to high impedence
    assign BUS_DATA = (WE && !BUS_WE) ? LedRegData: 8'hZZ;
    
    //Tie the register to the output data while setting two unused bits to 0
    assign RGB_OUT = LedRegData[2:0];
    
    endmodule

