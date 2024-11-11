`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Seven Segment Decoder Module
// This module decodes a 4-bit input into the corresponding 7-segment display pattern.
// It also controls the decimal point ('dot') segment.
//
// Inputs:
// - x: 4-bit binary value to be decoded and displayed on the 7-segment display
// - dot: Control signal for the decimal point segment
//
// Outputs:
// - seg: 8-bit segment control output for the 7-segment display (active low)
//         Bits [6:0] represent segments 'abcdefg'
//         Bit [7] represents the decimal point
//////////////////////////////////////////////////////////////////////////////////


module segDecoder(
    input [3:0] x, // 4-bit binary value to be decoded      
    input dot, // Control signal for the decimal point   
    output reg [7:0] seg // 8-bit segment control output
    );
    
    //Decoding operation
    always @ (x) 
    begin
    
    // switch case depending on input x: assigns which segments should light up
    case(x)
    //           Segment: abcdefg           
    
        4'h0: seg = 7'b0000001;
        4'h1: seg = 7'b1001111;
        4'h2: seg = 7'b0010010;
        4'h3: seg = 7'b0000110;
        4'h4: seg = 7'b1001100;
        4'h5: seg = 7'b0100100;
        4'h6: seg = 7'b0100000;
        4'h7: seg = 7'b0001111;
        4'h8: seg = 7'b0000000;
        4'h9: seg = 7'b0000100;
        4'hA: seg = 7'b0001000;
        4'hB: seg = 7'b1100000;
        4'hC: seg = 7'b0110001;
        4'hD: seg = 7'b1000010;
        4'hE: seg = 7'b0110000;
        4'hF: seg = 7'b0111000;
        
        default: seg =7'b1111111;   // cases from 10 to 15 keep all the segments OFF
                                    // as only nr 0->9 can be displayed per 1 digit
      
            
    endcase
    
    seg[7] = dot ? 0:1;  // ternery if dot high light up the dot (active low)
    end
 endmodule

