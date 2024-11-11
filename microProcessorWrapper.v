`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
    // Top-level module for the microprocessor FPGA implementation
    // This module integrates the processor, memory, timer and various peripherals
    //
    // Parameters:
    // - 
    // - 
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - ENABLE_IN: Enable signal for controlling peripheral functionality
    //
    // - SW_IN: 16-bit signal from the switches 
    //
    // Outputs:
    // - LED_OUT: 16-bit signal, each bit drives one of the LEDs 
    // - RGB_OUT: 3-bit signal controlling the colour of RGB LEDs
    // - anodeSelect: Controlling digits
    // - segmentSelect: Controlling individual segments
    // - SENSOR_PW_IN: Attached to board for PWM
    // - ultraSonic_Rx: Pin set HIGH to enable reading
//////////////////////////////////////////////////////////////////////////////////

module microProcessorWrapper(
        input CLK,
        input RESET, // Reset left unattached, can be attached to board for added functionality
        
        input [15:0] SW_IN, // Switch module input
        input ENABLE, // Enable signal for controlling peripheral functionality

    
        output [15:0] LED_OUT, // LED array output
        output [2:0] RGB_OUT, // RGB output
    
        // Connected to 7-seg on the board

        output [7:0] anodeSelect,   // Controlling digits
        output [7:0] segmentSelect, // Controlling individual segments
        
        //Connected to ultra sonic sensor  
          
        input SENSOR_PW_IN, // Attached to board for PWM
        output ultraSonic_Rx // Pin set HIGH to enable reading

    );
    
    
    // Internal signal declarations
    wire [7:0] BUS_DATA, BUS_ADDR, ROM_DATA, ROM_ADDR, NEXT_BUS_ADDR; // Input to the address decoder
    wire BUS_WE, A; 
    wire [1:0] BUS_INTERRUPTS_RAISE, BUS_INTERRUPTS_ACK;
    
    // Each peripheral takes individual wire from this output corresponding to their address
    // See addressDecoder module code for pairing
    wire [15:0] peripheralWE; // Output from central address decoder module
  

   


    
    // Instantiate centalised address decoder
    addressDecoder addrDecoder_inst(
        // Standard signals
        .CLK(CLK), 
        .RESET(RESET),
        
        //Taking the NEXT_BUS_ADDR signal for timing
        .BUS_ADDR(NEXT_BUS_ADDR),
        
        //16-bit output supporting up to unique 16 peripheral addresses
        .writeEnable(peripheralWE) 
    );

  // Instantiate processor module  
    Processor_tbc Processor (
    .CLK(CLK), 
    .RESET(RESET), 
    .BUS_DATA(BUS_DATA), 
    .BUS_ADDR(BUS_ADDR), 
    .BUS_WE(BUS_WE), 
    .ROM_ADDRESS(ROM_ADDR), 
    .ROM_DATA(ROM_DATA), 
    .BUS_INTERRUPTS_RAISE(BUS_INTERRUPTS_RAISE), 
    .BUS_INTERRUPTS_ACK(BUS_INTERRUPTS_ACK),
    
    .NEXT_BUS_ADDR(NEXT_BUS_ADDR) // Input to the address decoder
    );
  
  // Instantiate ROM module  
        ROM ROM_256 (
        .CLK(CLK), 
        .DATA(ROM_DATA), 
        .ADDR(ROM_ADDR)
        );

    // Instantiate RAM module
        RAM RAM_128 (
        .CLK(CLK), 
        .BUS_DATA(BUS_DATA), 
        .BUS_ADDR(BUS_ADDR), 
        .BUS_WE(BUS_WE)
        );
   
    // Timer module instantiation
  
        Timer Timer_0 (
        .CLK(CLK), 
        .RESET(RESET), 
        .BUS_DATA(BUS_DATA), 
        .BUS_ADDR(BUS_ADDR), 
        .BUS_WE(BUS_WE), 
        .BUS_INTERRUPT_RAISE(BUS_INTERRUPTS_RAISE[1]), 
        .BUS_INTERRUPT_ACK(BUS_INTERRUPTS_ACK[1])
        );


 // Two instances of the Slide switch modules, with different addresses	
	
         SlideSwitches lowerSwitch (
         
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .SW_IN(SW_IN[7:0])
         );
            
            defparam lowerSwitch.SlideSwitchesBaseAddr = 8'hB0; //Define the modular address for lower 8 switches
          
         SlideSwitches upperSwitch (
         
        .CLK(CLK),
        .RESET(RESET),
        .BUS_DATA(BUS_DATA),
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .SW_IN(SW_IN[15:8])
          );
          
            defparam upperSwitch.SlideSwitchesBaseAddr = 8'hB1;   //Redefine the modular address for upper 8 switches
  
  
  
  
 // LED module instantiations
         LEDs lowerLEDs (
            .CLK(CLK),
            .RESET(RESET),
            .BUS_DATA(BUS_DATA),
            .BUS_ADDR(BUS_ADDR),
            .BUS_WE(BUS_WE),
            .LED_OUT(LED_OUT[7:0])
             );
      
      
      LEDs upperLEDs (
         .CLK(CLK),
         .RESET(RESET),
         .BUS_DATA(BUS_DATA),
         .BUS_ADDR(BUS_ADDR),
         .BUS_WE(BUS_WE),
         .LED_OUT(LED_OUT[15:8])
         );
       // Address changes below for upper LED bank   
            defparam upperLEDs.LEDsBaseAddr= 8'hC1;  
            
            
  
 // Instantiate RGB LED module
 
    //Peripheral updated for address decoder
      triColourLEDs ledRGB (
            .CLK(CLK),
            .RESET(RESET),
            .BUS_DATA(BUS_DATA),
            .BUS_WE(BUS_WE),
            .WE(peripheralWE[9]), //Address decoder output
            .RGB_OUT(RGB_OUT)
            );
     
    
    // Controlling the seven-seg display
    displayControl segDisplayControl (
     .CLK(CLK),
     .RESET(RESET),
     .BUS_DATA(BUS_DATA),
     .BUS_ADDR(BUS_ADDR),
     .BUS_WE(BUS_WE),
     .ENABLE(1'b1),
     
    // Connected to 7-seg on the board
     .anodeSelect(anodeSelect), // Controlling digits
     .segmentSelect(segmentSelect)  // Controlling individual segments
    );      

// Instantiate ultrasonic sensor module
    sonicWrapper ultraSensor_inst (
    
    .CLK(CLK),
    .RESET(RESET),
    .BUS_DATA(BUS_DATA),
    .BUS_ADDR(BUS_ADDR),
    .BUS_WE(BUS_WE),
    .ENABLE(1'b1),
    
    //Connected to ultra sonic sensor port on board JA pins
    .SENSOR_PW_IN(SENSOR_PW_IN), 
    .ultraSonic_Rx(ultraSonic_Rx) 
    );
endmodule

          
