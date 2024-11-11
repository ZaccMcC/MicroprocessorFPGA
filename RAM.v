`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // RAM module
    // This module defines memory to be allocated for the RAM, reading and storing the RAM data from the file specifed as "RAM"
    // It provides data based on the specified RAM memory addresses from the processor
    //
    // Parameters:
    // - RAMAddrWidth: Defines the width of the address bus used to index ROM (as 8-bits) 
    // - RAMBaseAddr: Defines an address, which is compared with the BUS_ADDR from processor in the address decoding logic
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - BUS_ADDR: 8-bit address bus signal from the processor, specifying the memory address for the current operation
    // - BUS_WE: Write enable signal from the processor, indicating a read / write operation, when address(es) match BUS_ADDR & peripheral BaseAddr
    //
    // In/Output:
    // - BUS_DATA: 8-bit bidirectional data bus, used for reading from or writing to memory and peripherals
//////////////////////////////////////////////////////////////////////////////////
module RAM(
  	 //standard signals
	input 						CLK,
	//BUS signals
	inout		[7:0]			BUS_DATA,
	input		[7:0]			BUS_ADDR,
	input						BUS_WE	
    );

	parameter RAMBaseAddr 	= 0;
	parameter RAMAddrWidth	= 7; // 128 x 8-bits memory
	
	//Tristate
	wire 	[7:0]	BufferedBusData;
	reg 	[7:0]	Out;
	reg			    RAMBusWE;

	//Only place data on the bus if the processor is NOT writing, and it is addressing this memory
	assign BUS_DATA	 = (RAMBusWE) ? Out : 8'hZZ; 
	assign BufferedBusData = BUS_DATA;
	
	//Memory
	reg [7:0] Mem [2**RAMAddrWidth-1:0];

    // Initialise the memory for data preloading, initialising variables, and declaring constants	
	initial	$readmemh("C:/Users/zmccaf200/Downloads/cw2Improved/cw2Improved.srcs/constrs_1/imports/Downloads/RAM.txt", Mem);
	
												
	//single port ram
	always@(posedge CLK) begin
		// Brute-force RAM address decoding. Think of a simpler way...
		if((BUS_ADDR >= RAMBaseAddr) & (BUS_ADDR < RAMBaseAddr + 128)) begin
			if(BUS_WE) begin
				Mem[BUS_ADDR[6:0]] <= BufferedBusData;
				RAMBusWE <= 1'b0;
			end else
				RAMBusWE <= 1'b1;
		end else
			RAMBusWE <= 1'b0;
		
		Out 	<= Mem[BUS_ADDR[6:0]];
	end
	
endmodule
