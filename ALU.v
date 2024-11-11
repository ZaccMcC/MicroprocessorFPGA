`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
    // ARETHMETIC LOGIC UNIT (ALU) module
    // This module performs math operations and outputs the result for the processor on the OUT_RESULT signal
    //
    // Parameters:
    // - 
    // - 
    //
    // Inputs:
    // - CLK: Clock signal to synchronize the processor operations
    // - RESET: Reset signal to initialize or reset the processor state
    // - IN_A: 8-bit value of register A, used in the math operations
    // - IN_B: 8-bit value of register B, used in the math operations
    // - ALU_Op_Code: 4-bit signal, specifies the particular math operation to perform, read from ProgMemoryOut[7:4] in processor module
    //
    // Outputs:
    // - OUT_RESULT: 8-bit signal, contains result of math operation
//////////////////////////////////////////////////////////////////////////////////


module ALU(
	//standard signals
	input 					CLK,
	input					RESET,
	//I/O
	input		[7:0]			IN_A,
	input		[7:0]			IN_B,
	input		[3:0]			ALU_Op_Code,
	output	[7:0]				OUT_RESULT
	);
	
	reg [7:0] Out;
	//Arithmetic Computation
	always@(posedge CLK) begin
		if(RESET)
			Out 		<= 0;
		else begin 
			case (ALU_Op_Code)
				//Maths Operations
				//Add A + B
				4'h0:		Out <= IN_A + IN_B;
				//Subtract A - B
				4'h1:		Out <= IN_A - IN_B;
				//Multiply A * B
				4'h2:		Out <= IN_A * IN_B;
				//Shift Left A << 1
				4'h3:		Out <= IN_A << 1;
				//Shift Right A >> 1
				4'h4:		Out <= IN_A >> 1;
				//Increment A+1
				4'h5:		Out <= IN_A + 1'b1;
				//Increment B+1
				4'h6:		Out <= IN_B + 1'b1;
				//Decrement A-1
				4'h7:		Out <= IN_A - 1'b1;
				//Decrement B+1
				4'h8:		Out <= IN_B - 1'b1;
				// In/Equality Operations
				//A == B
				4'h9:		Out <= (IN_A == IN_B) ? 8'h01 : 8'h00;
				//A > B
				4'hA:		Out <= (IN_A > IN_B) ? 8'h01 : 8'h00;
				//A < B
				4'hB:		Out <= (IN_A < IN_B) ? 8'h01 : 8'h00;
				//Default A
				default: Out <= IN_A;
			endcase
		end
	end
		
	assign OUT_RESULT = Out;
	
endmodule

