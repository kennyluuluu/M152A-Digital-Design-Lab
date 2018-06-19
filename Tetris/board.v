`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:47:11 05/29/2018 
// Design Name: 
// Module Name:    block 
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
module board(
  // Inputs
  refreshClock,
  row,
  col,
  setSignal,
  blockType_in,
  setSpace,
  setRow,
  setCol,
  ////////
  reset,
  ///////////
  // Outputs
  outBoard,
  //block,
  playerScore
);
  input setSignal, reset;
  input refreshClock;
  input [4:0] row;
  input [3:0] col;
  input [2:0] blockType_in;
  input [4:0] setRow;
  input [3:0] setCol;
  input [15:0] setSpace;
  ////////////
  reg[2:0] reset_buf;
  wire isRst;
  assign isRst = reset_buf[2] & ~reset_buf[1];
  ////////////

  reg [2:0] set_buf;

  //output [3:0] block;
  /** Most significant bit indicates if block present
    * Next three bits represent block type:
    * 0: O-block
    * 1: I-block
    * 2: S-block
    * 3: Z-block
    * 4: L-block
    * 5: J-block
    * 6: T-block
    */
  output reg [14:0] playerScore;

  output reg [199:0] outBoard;
  
  reg [2:0] numFullRows;
  reg inside;
  
  reg [4:0] i, j;
  initial begin
    playerScore = 20'b0;
    numFullRows = 3'b0;
    outBoard = 200'b0;
	 reset_buf = 0;
    set_buf = 0;
	 outBoard = 200'b0;
	 i = 0;
  end
  
  always @ (posedge refreshClock) begin

	 reset_buf = {reset, reset_buf[2:1]};
	 if (isRst) begin
		playerScore = 20'b0;
		numFullRows = 3'b0;
		outBoard = 200'b0;
		reset_buf = 0;
		i = 0;
	 end
	 
	 set_buf = {setSignal, set_buf[2:1]};
    
    for (i = 0; i < 20; i = i + 1) begin
	  if(isFullRow(19-i)) begin
			numFullRows = numFullRows + 1;
			for (j = 19-i; j < 19; j = j + 1)
				 outBoard[(j+1)*10 - 1 -: 10] = outBoard[(j+2)*10 - 1 -: 10];
			outBoard[199 -: 10] = 10'b0;
	  end
    end

    playerScore = playerScore + 20*rowsToScore(numFullRows);
    numFullRows = 3'b0;

    if (set_buf[1:0] == 2'b10)
      for (i = 0; i < 4; i = i + 1)
			for (j = 0; j < 4; j = j + 1)
				if (setSpace[i*4 + j])
					outBoard[(setRow+i-2)*10+(setCol+j-2)] = 1;
				
  end

  function isFullRow;
    input k;
    begin
      isFullRow = outBoard[k*10 + 0] & outBoard[k*10 + 1] &
                  outBoard[k*10 + 2] & outBoard[k*10 + 3] &
						outBoard[k*10 + 4] & outBoard[k*10 + 5] &
						outBoard[k*10 + 6] & outBoard[k*10 + 7] &
						outBoard[k*10 + 8] & outBoard[k*10 + 9];
    end
  endfunction

  // function returns score/20, to make return value smaller
  function [5:0] rowsToScore;
    input [2:0] n_rows;
    begin
      case(n_rows)
        3'h0: rowsToScore = 6'h00;
        3'h1: rowsToScore = 6'h02;
        3'h2: rowsToScore = 6'h05;
        3'h3: rowsToScore = 6'h0F;
        3'h4: rowsToScore = 6'h3C;
      endcase
    end
  endfunction

endmodule





    /*
    //for (i = 0; i < 20; i = i + 1) begin
      if(isFullRow(0)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(0*40) + 40] = outBoard[759:(0*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
        for (temp_i = i; i < 19; i = i + 1) begin
          for (j = 0; j < 10; j = j + 1) begin
            board[i*10 + j] = board[(i+1)*10 + j];
          end
        end * /
		  //board[199:i*10] = {0,board[199:i*10+10]};
        //i = temp_i - 1;
      end
      if(isFullRow(1)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(1*40) + 40] = outBoard[759:(1*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(2)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(2*40) + 40] = outBoard[759:(2*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(3)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(3*40) + 40] = outBoard[759:(3*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(4)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(4*40) + 40] = outBoard[759:(4*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(5)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(5*40) + 40] = outBoard[759:(5*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(6)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(6*40) + 40] = outBoard[759:(6*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(7)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(7*40) + 40] = outBoard[759:(7*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(8)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(8*40) + 40] = outBoard[759:(8*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(9)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(9*40) + 40] = outBoard[759:(9*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(10)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(10*40) + 40] = outBoard[759:(10*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(11)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(11*40) + 40] = outBoard[759:(11*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(12)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(12*40) + 40] = outBoard[759:(12*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(13)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(13*40) + 40] = outBoard[759:(13*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(14)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(14*40) + 40] = outBoard[759:(14*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(15)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(15*40) + 40] = outBoard[759:(15*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(16)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(16*40) + 40] = outBoard[759:(16*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(17)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(17*40) + 40] = outBoard[759:(17*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(18)) begin
        numFullRows = numFullRows + 1;
        outBoard[799:(18*40) + 40] = outBoard[759:(18*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      if(isFullRow(19)) begin
        numFullRows = numFullRows + 1;
        //outBoard[799:(19*40) + 40] = outBoard[759:(19*40)]; //delete full row and shift down one row
        outBoard[799:760] = 0;  //make topmost row empty
      end
      */
    //end