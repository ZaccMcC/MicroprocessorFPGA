`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // Generic Counter Module
    // This module implements a generic up/down counter with configurable width and maximum value
    // Set parameter values as required
    //
    // Parameters:
    // - COUNTER_WIDTH: The bit-width of the counter (default is 4)
    // - COUNTER_MAX: The maximum value the counter can reach (default is 9)
    //
    // Inputs:
    // - CLK: Clock signal
    // - RESET: Reset signal (Included in sensitivity list ... synchronous)
    // - ENABLE_IN: Enable signal to control counting
    // - DIRECTION: Direction signal to control counting direction (1 for up, 0 for down)
    //
    // Outputs:
    // - TRIG_OUT: Trigger output signal, asserted when the counter reaches 0 or COUNTER_MAX based on the direction
    // - COUNT: Current count value of the counter
//////////////////////////////////////////////////////////////////////////////////

module genericCounter(
        CLK,
        RESET,
        ENABLE_IN,
        TRIG_OUT,
        COUNT
    );
    
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX = 9;
    
    input CLK;
    input RESET;
    input ENABLE_IN;
    output TRIG_OUT;
    output [COUNTER_WIDTH-1:0] COUNT;
    
    reg [COUNTER_WIDTH-1:0] count_value;
    reg Trigger_out;
    
    
    
    always@(posedge CLK or posedge RESET) begin
        if(RESET) //on reset triggering, counter value resets to 0
            count_value <= 0;
        else begin
            if(ENABLE_IN) begin //when counting action set 'on'
                if(count_value == COUNTER_MAX) // if value max value reached, reset to 0
                    count_value <= 0;
                else // otherwise increment counter
                    count_value <= count_value + 1;
                end
            end
        end
        
    always@(posedge CLK  or posedge RESET) begin
        if(RESET)
            Trigger_out <= 0;
        else begin
            if(ENABLE_IN && (count_value == COUNTER_MAX))
                Trigger_out <= 1;
            else
                Trigger_out <= 0;
            end
        end
        
        
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;
    
    
    
endmodule
