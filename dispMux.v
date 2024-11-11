`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // display MUX Module
    // This module takes the data for the 4 digits, and cycles through them, passing the data to the 7-segement decoder
    // The cycling is driven by the 2-bit counter at 250 Hz (0.004s)
    // 
    //
    // Parameters:
    // - 
    // - 
    //
    // Inputs:
    // - CONTROL: 2-bit control signal to select which digit's data to output
    // - IN0: 4-bit data input for digit 0
    // - IN1: 4-bit data input for digit 1
    // - IN2: 4-bit data input for digit 2
    // - IN3: 4-bit data input for digit 3
    //
    // Outputs:
    // - OUT: 4-bit data output for the selected digit to be passed to 7-seg decoder module
    // - anodeSelect: 8-bit signal to control which digit(s) are illuminated (driven low/'0' for on)
//////////////////////////////////////////////////////////////////////////////////


module dispMux(
    input [1:0] CONTROL, // 2-bit control signal to select the digit
    input [3:0] IN0, // 4-bit data input for digit 0
    input [3:0] IN1, // digit 1
    input [3:0] IN2, // 2
    input [3:0] IN3, // 3
    output reg [3:0] OUT, // selected digit data 
    output reg [7:0] anodeSelect // identifies which anodes to select
    );

// Internal registers for anode selection          
    reg [3:0] upperDigits;
    reg [3:0] lowerDigits;
        
    always@( CONTROL 
                or IN0 or IN1 or IN2 or IN3)
    begin
    // Select digit data based on the CONTROL signal 
        case(CONTROL)
            2'b00 : OUT <= IN0;
            2'b01 : OUT <= IN1;
            2'b10 : OUT <= IN2;
            2'b11 : OUT <= IN3;
            default : OUT <= 4'b0000;
        endcase

        
      
                // Control anode selection signals
        case(CONTROL)
            2'b00: lowerDigits = 4'b1110; // digit 0
            2'b01: lowerDigits = 4'b1101; // digit 1
            2'b10: lowerDigits = 4'b1011; // digit 2
            2'b11: lowerDigits = 4'b0111; // digit 3
            default: lowerDigits = 4'b1111;
        endcase
        
            upperDigits <= 4'b1111;
            anodeSelect = {upperDigits, lowerDigits}; // Combine upper and lower digits for anode control
    end

endmodule