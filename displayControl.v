`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Display control module 
    // This module wraps together the hardware required for the seven-segement display 
    // It recieves the data, WE, and address signals from the processor, and branches off relevent signals to wrapped modules
    //
    //
    // Module contains: 2 genericCounters, a decoder, a MUX, and a 7-seg decoder
    //      17-bit counter scales down the onboard CLK timer to 100 ms used for driving the 7-segment display
    //      2-bit counter drives the MUX to cycle through each of the digits' input data at 250 Hz (0.004s)
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    // - ENABLE_IN: Enable signal for controlling peripheral functionality
    //
    // In/Output:
    // - BUS_DATA: 8-bit bidirectional data bus, used for reading from or writing to memory and peripherals
    //
    // Output:
    // - anodeSelect: 8-bit signal controlling the seven segment digits
    // - segmentSelect: 8-bit signal controlling the individual segments of the digits
//////////////////////////////////////////////////////////////////////////////////


module displayControl(
            	//Standard inputs
    input CLK,
    input RESET,
    //BUS signals 
    inout [7:0] BUS_DATA, 
    input [7:0] BUS_ADDR,
    input BUS_WE,
    input ENABLE,
    
    output [7:0] anodeSelect,
    
    output [7:0] segmentSelect

    );
 
//Declare internal signals    
    wire [7:0] upper, lower;
    
    displayDecoding decoding (
        // Module recieves the data from processor bus, assigns data to addressed digits (0 -> 1 and 2 -> 3)
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA), 
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .upperDigits(upper), // digits 0 -> 1
        .lowerDigits(lower) // digits 2 -> 3
    );
    
    // 17-bit counter
      wire Bit17TriggOut;    
      genericCounter # (.COUNTER_WIDTH(17), .COUNTER_MAX(99999))
                        Bit17Counter (
                           .CLK(CLK),
                           .RESET(RESET),
                           .ENABLE_IN(1'b1),
                           .TRIG_OUT(Bit17TriggOut)
                           ); 
     
    // 2-bit counter for cycling digits
    wire [1:0] bitCount;
    genericCounter # (.COUNTER_WIDTH(2), .COUNTER_MAX(3)) 
                        Bit2Counter (
                            .CLK(Bit17TriggOut),
                            .RESET(RESET),
                            .ENABLE_IN(ENABLE),
                            .COUNT(bitCount)
                            );   
                            
    // Extract digits
     wire [3:0] digit0 = lower[3:0]; //Digit 0
     wire [3:0] digit1 = lower[7:4]; //Digit 1
     wire [3:0] digit2 = upper[3:0]; //Digit 2
     wire [3:0] digit3 = upper[7:4]; //Digit 3
     
     wire [3:0] activeDigit; //Cycle selected active digit from MUX to decoder
     
     //Allocate timing to each digit, controlling to anode values and passing active hex digit to 7-seg decoder
     dispMux timingMUX (
         .CONTROL(bitCount),
         .IN0(digit0),
         .IN1(digit1),
         .IN2(digit2),
         .IN3(digit3),
         .OUT(activeDigit),
         .anodeSelect(anodeSelect)
     );
    

    
    //Allocating segements to input hex values
     segDecoder segmentDecoding (
            .x(activeDigit),          
            .dot(1'b0),   
            .seg(segmentSelect)   
     );
                              
endmodule
