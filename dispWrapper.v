`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Display decoding module 
    // This module defines the address, and logic used for address matching for the seven segement display 
    // It recieves data from the processor BUS_DATA signal
    // Performs address matching for upper and lower digits (with unique addresses) 
    // The data is output to the MUX 
    //
    // Parameters: 
    // - SevenSegBaseAddrLower: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    // - SevenSegBaseAddrUpper: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    //    
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    //
    // In/Output:
    // - BUS_DATA: 8-bit bidirectional data bus, used for reading from or writing to memory and peripherals
    //
    // Output:
    // - upperDigits: 8-bit signal containing the seperated data from the BUS for the upper two digits 
    // - lowerDigits: 8-bit signal containing the seperated data from the BUS for the lower two digits
//////////////////////////////////////////////////////////////////////////////////


module displayDecoding(
        	//Standard inputs
                input CLK,
                input RESET,
                //BUS signals 
                inout [7:0] BUS_DATA, 
                input [7:0] BUS_ADDR,
                input BUS_WE,
                //LEDs output signal
                output [7:0] upperDigits,
                output [7:0] lowerDigits
        
    );
    
    parameter [7:0] SevenSegBaseAddrLower = 8'hD0;
    parameter [7:0] SevenSegBaseAddrUpper = 8'hD1;
        
    reg [7:0] SevenSegDataUpper;
    reg [7:0] SevenSegDataLower;

  
    
                        //Address decoding
    
    //Checking status of BUS_DATA	
    always@(posedge CLK) begin
        if(RESET) begin //RESET both registers when triggered
            SevenSegDataUpper <= 8'h00;
            SevenSegDataLower <= 8'h00;
        end         
        
                //Assign data depending on BUS_ADDR
        else if((BUS_ADDR == SevenSegBaseAddrLower) & BUS_WE)
            SevenSegDataLower <= BUS_DATA; //Lower register (digits 0 & 1)
        else if((BUS_ADDR == SevenSegBaseAddrUpper) & BUS_WE)     
            SevenSegDataUpper <= BUS_DATA; //Upper register (digits 2 & 3)
    end
                        // If BUS_DATA isnt writing to either register with HIGH WE then tie signal to high impedence
    
    // Tri-state control for BUS_DATA, checking for addr match
        assign bus_data_drive = ((BUS_ADDR == SevenSegBaseAddrLower) && !BUS_WE) || 
                                ((BUS_ADDR == SevenSegBaseAddrUpper) && !BUS_WE);
                // If drive == 1
                    // If lower reg is addressed, data == Lower register,
                    // else if upper reg is addressed, data == upper register
                    // else data == high impednece
        assign BUS_DATA = bus_data_drive ? (BUS_ADDR == SevenSegBaseAddrLower ? SevenSegDataLower : 
                                            BUS_ADDR == SevenSegBaseAddrUpper ? SevenSegDataUpper : 8'hZZ) : 8'hZZ;

     
        assign upperDigits = SevenSegDataUpper;
        assign lowerDigits = SevenSegDataLower;
        
endmodule
