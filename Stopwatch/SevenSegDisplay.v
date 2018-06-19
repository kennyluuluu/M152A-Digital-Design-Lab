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
module SevenSegDisplay( counter3, counter2, counter1, counter0, seg, an, bigHz, blinkHz, sel
    );

	input [2:0] counter3, counter1;
	input [3:0] counter2, counter0;
	input bigHz, blinkHz;
	input [1:0] sel;
	
	output [7:0] seg;
	output [3:0] an;
	
	reg [1:0] anCounter;
	reg [3:0] an;
	reg [7:0] seg;
	
	initial begin
		anCounter = 0;
	end
	
	always @ (posedge bigHz) begin
		if(anCounter == 0) begin
			if(sel == 2'b00 && blinkHz)
				an <= 4'b1111;
			else
				an <= 4'b1110;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg(counter0);
		end
		else if(anCounter == 1) begin
			if(sel == 2'b01 && blinkHz)
				an <= 4'b1111;
			else
				an <= 4'b1101;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg({0,counter1});
		end
		else if(anCounter == 2) begin
			if(sel == 2'b10 && blinkHz)
				an <= 4'b1111;
			else
				an <= 4'b1011;
			anCounter <= anCounter + 1;
			seg <= binaryToSeg(counter2);
		end
		else if(anCounter == 3) begin
			if(sel == 2'b11 && blinkHz)
				an <= 4'b1111;
			else
				an <= 4'b0111;
			anCounter <= 0;
			seg <= binaryToSeg({0,counter3});
		end
	end
	
	function [7:0] binaryToSeg;
		input [3:0] counter;
		begin
			case(counter)
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
