`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:53:38 05/08/2018 
// Design Name: 
// Module Name:    Counter 
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
module Counter( refreshClock, oneHz, twoHz, select, counter3, counter2, counter1, counter0, isAdj, reset, isPaused
    );
	
	input refreshClock, oneHz,twoHz,select,isAdj,reset,isPaused;
	output counter3,counter2,counter1,counter0;
	
	wire[1:0] select;
	wire isAdj;
	wire clock;
	wire reset, isPaused;
	
	reg [2:0] counter3;
	reg [3:0] counter2;
	reg [2:0] counter1;
	reg [3:0] counter0;
	reg [2:0] oneHzBuf;
	reg [2:0] twoHzBuf;

	initial begin
		counter3 = 0;
		counter2 = 0;
		counter1 = 0;
		counter0 = 0;
	end


	always @ (posedge refreshClock) begin
		if (reset) begin
			counter3 = 0;
			counter2 = 0;
			counter1 = 0;
			counter0 = 0;
		end
		else if (oneHzBuf[1:0] == 2'b10 && !isPaused && !isAdj) begin
			counter0 = counter0 + 1;		//increment LSB
			if (counter0 == 4'b1010) begin	//check for overflow
				counter0 = 0;
				counter1 = counter1 + 1;
			end
			if (counter1 == 3'b110) begin
				counter1 = 0;
				counter2 = counter2 + 1;
			end
			if (counter2 == 4'b1010) begin
				counter2 = 0;
				counter3 = counter3 + 1;
			end
			if (counter3 == 3'b110)
				counter3 = 0;
		end
		else if (twoHzBuf[1:0] == 2'b10 && !isPaused && isAdj) begin
			if (select == 2'b00)	//increment the counter based on select
				counter0 = counter0 + 1;
			if (select == 2'b01)
				counter1 = counter1 + 1;
			if (select == 2'b10)
				counter2 = counter2 + 1;
			if (select == 2'b11)
				counter3 = counter3 + 1;
			
			if (counter0 == 4'b1010) begin	//check for overflow within selected counter
				counter0 = 0;
			end
			if (counter1 == 3'b110) begin
				counter1 = 0;
			end
			if (counter2 == 4'b1010) begin
				counter2 = 0;
			end
			if (counter3 == 3'b110)
				counter3 = 0;
		end
		oneHzBuf = {oneHz, oneHzBuf[2:1]};
		twoHzBuf = {twoHz, twoHzBuf[2:1]};
	end
	
endmodule
