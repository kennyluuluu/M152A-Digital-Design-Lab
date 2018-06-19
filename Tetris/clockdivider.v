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
module clockdivider( clk, oneHz, twoHz, bigHz, blinkHz, DBHz ,vgaHz
    );

	input clk;
	output oneHz, twoHz, bigHz, blinkHz, DBHz, vgaHz;
	
	reg oneHz, twoHz, bigHz, blinkHz, DBHz, vgaHz;
	
	reg [27:0] counterOneHz;
	reg [27:0] counterTwoHz;
	reg [19:0] counterBigHz;
	reg [27:0] counterBlinkHz;
	reg [22:0] counterDBHz;
    reg [1:0] countervgaHz;
	
	initial begin
		
		counterOneHz = 0;
		counterTwoHz = 0;
		counterBigHz = 0;
		counterBlinkHz = 0;
		counterDBHz = 0;
        countervgaHz = 0;
		oneHz = 0;
		twoHz = 0;
		bigHz = 0;
		blinkHz = 0;
        DBHz = 0;
        vgaHz = 0;
	
	end
	
	always @ (posedge clk) begin
		
		counterOneHz = counterOneHz + 1;
		counterTwoHz = counterTwoHz + 1;
		counterBigHz = counterBigHz + 1;
		counterBlinkHz = counterBlinkHz + 1;
		counterDBHz = counterDBHz + 1;
        countervgaHz = countervgaHz + 1;
		
		/*if(counterOneHz == 28'h7d7840) begin	//count to 50,000,000
			 oneHz = ~oneHz;
			 counterOneHz = 0;
		end
		
		if(counterTwoHz == 24'hebc20) begin	//count to 25,000,000
			twoHz = ~twoHz;
			counterTwoHz = 0;
		end
	
		if(counterBigHz == 20'hc350) begin	//count to 100,000
			bigHz = ~bigHz;
			counterBigHz = 0;
		end
		
		if(counterBlinkHz == 24'h625a0) begin //count to 12,500,000
			blinkHz = ~blinkHz;
			counterBlinkHz = 0;
		end
        if(counterDBHz == 24'h312d0) begin //count to 1,000,000
            DBHz = ~DBHz;
            counterDBHz = 0;
        end
        if(countervgaHz == 1'h1) begin //count to 2 for 25Mhz
            vgaHz = ~vgaHz;
            countervgaHz = 0;
        end*/
		
		/*if(counterOneHz == 28'h2faf080) begin	//count to 50,000,000 //ACTUAL ONEHZ
			 oneHz = ~oneHz;
			 counterOneHz = 0;
		end*/
		if(counterOneHz == 28'h0faf080) begin	//count to 50,000,000
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
        if(counterDBHz == 23'hf4240) begin //count to 1,000,000
            DBHz = ~DBHz;
            counterDBHz = 0;
        end
        if(countervgaHz == 2'h2) begin //count to 2 for 25Mhz
            vgaHz = ~vgaHz;
            countervgaHz = 0;
        end
	end
	
endmodule