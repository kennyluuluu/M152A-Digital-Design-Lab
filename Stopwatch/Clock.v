`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:57:00 05/08/2018 
// Design Name: 
// Module Name:    Clock 
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
module Clock( clk, oneHz, twoHz, bigHz, blinkHz, tenHz
    );

	input clk;
	output oneHz, twoHz, bigHz, blinkHz, tenHz;
	
	reg oneHz, twoHz, bigHz, blinkHz, tenHz;
	
	reg [26:0] counterOneHz;
	reg [25:0] counterTwoHz;
	reg [17:0] counterBigHz;
	reg [24:0] counterBlinkHz;
    reg [22:0] counterTenHz;
	
	initial begin
		
		counterOneHz = 0;
		counterTwoHz = 0;
		counterBigHz = 0;
		counterBlinkHz = 0;
        counterTenHz = 0;
		oneHz = 0;
		twoHz = 0;
		bigHz = 0;
		blinkHz = 0;
        tenHz = 0;
	
	end
	
	always @ (posedge clk) begin
		
		counterOneHz = counterOneHz + 1;
		counterTwoHz = counterTwoHz + 1;
		counterBigHz = counterBigHz + 1;
		counterBlinkHz = counterBlinkHz + 1;
        counterTenHz = counterTenHz + 1;
		
		if(counterOneHz == 28'h2faf080) begin	//count to 50,000,000
			 oneHz = ~oneHz;
			 counterOneHz = 0;
		end
		
		if(counterTwoHz == 28'h17d7840) begin	//count to 25,000,000
			twoHz = ~twoHz;
			counterTwoHz = 0;
		end
		
		if(counterBigHz == 20'h186a0) begin	//count to 100,000
			bigHz = ~bigHz;
			counterBigHz = 0;
		end
		
		if(counterBlinkHz == 28'hbebc20) begin //count to 12,500,000
			blinkHz = ~blinkHz;
			counterBlinkHz = 0;
		end
        
        if(counterTenHz == 23'hf4240) begin //count to 1,000,000
            tenHz = ~tenHz;
            counterTenHz = 0;
        end
	end
	
endmodule
