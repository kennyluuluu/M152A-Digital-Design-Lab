`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:53 05/10/2018 
// Design Name: 
// Module Name:    SevenSegDisplay 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ScoreDisplay(score, seg, an, bigHz, gameoverHz
    );

	input [14:0] score;		// value 0-9999
	input gameoverHz, bigHz;
	
	output [7:0] seg;
	output [3:0] an;
	
	reg [1:0] anCounter;
	reg [3:0] an;
	reg [7:0] seg;
	
	initial begin
		anCounter <= 0;
	end
				
	always @ (posedge bigHz) begin			
		if(anCounter == 0) begin
			an <= 4'b1110;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg(score%10);
		end
		else if(anCounter == 1) begin
			an <= 4'b1101;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg((score%100 - score%10)/10);
		end
		else if(anCounter == 2) begin
			an <= 4'b1011;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg((score%1000 - score%100 -  score%10)/100);
		end
		else if(anCounter == 3) begin
			an <= 4'b0111;
			anCounter <= 0;
			seg <= binaryToSeg((score - score%1000 -score%100 -score%10)/1000);
		end
	end
	
	function [7:0] binaryToSeg;
		input [3:0] digit;
		begin
			case(digit)
				4'h0: binaryToSeg = 8'b11000000;
				4'h1: binaryToSeg = 8'b11111001;
				4'h2: binaryToSeg = 8'b10100100;
				4'h3: binaryToSeg = 8'b10110000;
				4'h4: binaryToSeg = 8'b10011001;
				4'h5: binaryToSeg = 8'b10010010;
				4'h6: binaryToSeg = 8'b10000010;
				4'h7: binaryToSeg = 8'b11111000;
				4'h8: binaryToSeg = 8'b10000000;
				4'h9: binaryToSeg = 8'b10010000;
			endcase
		end
	endfunction

endmodule
