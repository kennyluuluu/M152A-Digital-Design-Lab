`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:05:12 05/24/2018 
// Design Name: 
// Module Name:    Tetris 
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
module Tetris(//inputs
				  clk, 
				  btnLeft, btnRight, btnCW, btnCCW, btnRst,
				  swPause,
				  //outputs
				  vgaRed, vgaGreen, vgaBlue, Hsync, Vsync,
                  seg, an);
    
    input clk;
    input btnLeft, btnRight, btnCW, btnCCW, btnRst;
	input swPause;
	 
    output [2:0] vgaRed, vgaGreen;
    output [1:0] vgaBlue;
    output Hsync, Vsync;
    output [7:0] seg;
    output [3:0] an;
    
    wire oneHz, twoHz, bigHz, blinkHz, DBHz, vgaHz;
    wire [4:0] row;
    wire [3:0] col;
    wire setSignal;
    wire [199:0] board;
    
    wire [2:0] falling_t;
    wire [15:0] falling_space;
    wire [4:0] falling_row;
    wire [3:0] falling_col;
    
	 wire is_btnLeft_posedge, is_btnRight_posedge, is_btnCW_posedge, is_btnCCW_posedge, is_btnRst_posedge;
    
    wire [14:0] score;
    
    wire block;
    assign block = board[row*10+col]; //MSB is valid bit
	 
	 wire [4:0] setRow;
	 wire [3:0] setCol;
	 wire [15:0] setSpace;
    
    reg isPaused;
    
    initial begin
        isPaused = 0;
    end

    clockdivider clock(clk, oneHz, twoHz, bigHz, blinkHz, DBHz, vgaHz);
    
    vgacontroller vga(// inputs
                      vgaHz, board,
                      //outputs
                      Vsync, Hsync, vgaRed, vgaGreen, vgaBlue,
                      //inputs from falling
                      falling_t, falling_space, falling_row, falling_col
                      );  //block input
    
    board mainboard(// inputs
                    clk, row, col, setSignal, falling_t, setSpace, setRow, setCol, is_btnRst_posedge,
                    // outputs
                    board, score);
    
    ScoreDisplay maindisplay(score, seg, an, bigHz, DBHz);
    
	 Debouncer maindebounce(//inputs
									DBHz, btnLeft, btnRight, btnCW, btnCCW, btnRst,
									//outputs
									is_btnLeft_posedge, is_btnRight_posedge, is_btnCW_posedge, is_btnCCW_posedge, is_btnRst_posedge);
	
    gameController mainController(// inputs
                                  bigHz, swPause, oneHz, is_btnLeft_posedge, is_btnRight_posedge, is_btnCCW_posedge, is_btnCW_posedge, is_btnRst_posedge, block,
                                  // outputs
                                  row, col, setSignal, falling_t, falling_space, falling_row, falling_col, setSpace, setRow, setCol);

endmodule
