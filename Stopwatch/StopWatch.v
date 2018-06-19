`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:56:19 05/08/2018 
// Design Name: 
// Module Name:    StopWatch 
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
module StopWatch( clk, sw, btnReset, btnPause, seg, an
    );

	input clk, btnReset, btnPause;
	input [2:0] sw;
	output [7:0] seg;
	output [3:0] an;
	
	wire oneHz, twoHz, bigHz, blinkHz, tenHz;
	wire [2:0] counter3, counter1;
	wire [3:0] counter2, counter0;
	wire tempblinkHz;
	wire Resetout, Pauseout;
	reg isPaused;
	
	Clock mainclock(clk, oneHz, twoHz, bigHz, blinkHz, tenHz);
	
	Counter maincounter(clk, oneHz, twoHz, sw[1:0], counter3, counter2, counter1, counter0, sw[2], Resetout, isPaused);

	SevenSegDisplay maindisplay(counter3, counter2, counter1, counter0, seg, an, bigHz, tempblinkHz, sw[1:0]);
	
	Debouncer maindebounce(tenHz, btnPause, btnReset, Pauseout, Resetout);
	
	//assign statement
	assign tempblinkHz = blinkHz & sw[2];

	initial begin
		isPaused = 0;
	end
		
	always @ (posedge Pauseout)
		isPaused <= isPaused + 1;

endmodule
