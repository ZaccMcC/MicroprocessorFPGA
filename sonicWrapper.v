`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // sonic wrapper module
    // This module wraps the IP belonging to the sonic range sensor, 
    // It defines the address, and logic used for the address decoding of the sonic range sensor
    // The status of the slide switches are read through the 8-bit internal wire "measuredDistance"
    // Then stored on the register "Out"
    // If address matching occurs, with a write enable signal, this register is written to the address bus
    //
    // Parameters: 
    // - UltraSonicADDR: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    // - SENSOR_PW_IN: Attached to board for PWM
    //
    // In/Output:
    // - BUS_DATA: 8-bit bidirectional data bus, used for reading from or writing to memory and peripherals
    //
    //
    // Output:
    // - ultraSonic_Rx: Pin set HIGH to enable reading
//////////////////////////////////////////////////////////////////////////////////


module sonicWrapper(
          //Standard inputs
        input CLK,
        input RESET,
        //BUS signals 
        inout [7:0] BUS_DATA, 
        input [7:0] BUS_ADDR,
        input BUS_WE,
        input ENABLE,
        
        input SENSOR_PW_IN,
        output ultraSonic_Rx
      

);


	parameter [7:0] UltraSonicADDR = 8'hA0;
        
        reg     [7:0]    Out;
        wire     [7:0]   measuredDistance;
        reg              SonarBusWE = 1'b0;
        
        //Only place data on the bus if the processor is NOT writing, and it is addressing this memory
        assign BUS_DATA = ((SonarBusWE))? Out : 8'hZZ; 
        
                                                    
        always@(posedge CLK) begin
            // Brute-force address decoding. Think of a simpler way...
            if(BUS_ADDR == UltraSonicADDR) begin
                if(BUS_WE) begin
                    SonarBusWE <= 1'b0;
                end else
                    SonarBusWE <= 1'b1;
            end else
                SonarBusWE <= 1'b0;
            
           Out     <= measuredDistance;
        end        
        
        
        
    pmod_ultrasonic_range_finder_1 ultrasonic_range (
    
    .clk(CLK),
    .reset_n(1'b1),
    .sensor_pw(SENSOR_PW_IN),
    
    .RX(ultraSonic_Rx), // Pin set HIGH to enable reading
    .DISTANCE_INCH(measuredDistance)
    
    );
    
    
endmodule
