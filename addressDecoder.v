`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Address Decoder Module
    // This module decodes the bus address to generate write enable signals for different peripherals.
    // It supports up to 16 unique peripheral addresses.
    //
    // Parameters:
    // - 
    // - 
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - BUS_ADDR: 8-bit address for the next instruction to be fetched from ROM (next address is used to synchronise the write enable signals)
    //
    //
    // Outputs:
    // - writeEnable: 16-bit output, each bit represents the write enable signal for a specific peripheral 
//////////////////////////////////////////////////////////////////////////////////


module addressDecoder(
            //Standard inputs
        input          CLK,
        input         RESET,
        
        //BUS signals 
        input  [7:0] BUS_ADDR,
        
            
        output reg [15:0] writeEnable
  
        
        );
        
        always @(posedge CLK) begin
            if (RESET)
                writeEnable <= 16'b0; // Reset all enables on RESET
            else begin
            // switch case depending on input BUS_ADDR: assigns writeEnable signal to relevent peripheral
                case(BUS_ADDR)       
            
                    8'hA0: writeEnable[0]  = 1'b1;  //Address matches: Ultrasonic (lower)
                    8'hA1: writeEnable[1]  = 1'b1;  //Address matches: Ultrasonic (middle)
                    8'hA2: writeEnable[2]  = 1'b1;  //Address matches: Ultrasonic (upper)
                    8'hB0: writeEnable[3]  = 1'b1;  //Address matches: Slide switches (lower)
                    8'hB1: writeEnable[4]  = 1'b1;  //Address matches: Slide switches (upper)
                    8'hC0: writeEnable[5]  = 1'b1;  //Address matches: LEDs (lower)
                    8'hC1: writeEnable[6]  = 1'b1;  //Address matches: LEDs (upper)
                    8'hD0: writeEnable[7]  = 1'b1;  //Address matches: Seven Seg (lower)
                    8'hD1: writeEnable[8]  = 1'b1;  //Address matches: Seven Seg (upper)
                    8'hE0: writeEnable[9]  = 1'b1;  //Address matches: RGB (lower)
                    8'hE1: writeEnable[10] = 1'b1;  //Address matches: RGB (upper)
                    8'hF0: writeEnable[11] = 1'b1;  //Address matches: Timer (lower)
                    8'hF1: writeEnable[12] = 1'b1;  //Address matches: Timer (middle)
                    8'hF3: writeEnable[13] = 1'b1;  //Address matches: Timer (upper)
                                      
                    default: writeEnable = 16'b0;   // no valid address   
                endcase
            end
        end
endmodule