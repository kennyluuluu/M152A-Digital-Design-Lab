module gameController(
  // Inputs
  refreshClock,
  isPaused,
  fallClock,
  move_L,
  move_R,
  rot_L,
  rot_R,
  ////////
  reset,
  ///////////
  req_block,
  // Outputs
  row_out,
  col_out,
  setSignal,
  falling_t,
  falling_space,
  falling_row,
  falling_col,
  set_space,
  setRow,
  setCol
);

  input wire refreshClock, isPaused, fallClock, move_L, move_R, rot_L, rot_R, reset;
  input req_block;

  output reg [4:0] row_out;
  output reg [3:0] col_out;
  output reg [15:0] set_space;
  output reg [4:0] setRow;
  output reg [3:0] setCol;
  output reg setSignal;

  output reg [2:0] falling_t;
  reg [1:0] falling_orient;
  output reg [15:0] falling_space;
  output reg [4:0] falling_row;
  output reg [3:0] falling_col;

  reg [2:0] mL_buf;
  reg [2:0] mR_buf;
  reg [2:0] rL_buf;
  reg [2:0] rR_buf;
  reg [2:0] fC_buf;

  reg [15:0] pieceBuffer;
  
  ////////////
  reg[2:0] reset_buf;
  wire isRst;
  assign isRst = reset_buf[2] & ~reset_buf[1];
  ////////////
  reg flag;
  reg gameOver;

  //reg [799:0] dynamicBoard;

  initial begin
    pieceBuffer = 0;
    falling_row = 18;
    falling_col = 6;
    falling_t = 1;
    falling_orient = 1;
    falling_space = pieceToBits(falling_t, falling_orient);
    flag = 0;
    gameOver = 0;
    mL_buf = 0;
    mR_buf = 0;
    rL_buf = 0;
    rR_buf = 0;
    fC_buf = 0;
	 setSignal = 0;
	 //////
	 reset_buf = 0;
	 ///////
	 set_space = 0;
	 setRow = 0;
	 setCol = 0;
  end

  reg [5:0] i;
  reg [2:0] j;
  always @ (posedge refreshClock) begin
	 setSignal = 0;
    mL_buf = {move_L, mL_buf[2:1]};
    mR_buf = {move_R, mR_buf[2:1]};
    rL_buf = {rot_L, rL_buf[2:1]};
    rR_buf = {rot_R, rR_buf[2:1]};
    fC_buf = {fallClock, fC_buf[2:1]};
	 
	 ////////////
	 reset_buf = {reset, reset_buf[2:1]};
	 if (isRst) begin
		 pieceBuffer = 0;
		 falling_row = 18;
		 falling_col = 6;
		 falling_t = falling_space%7;
		 falling_orient = 1;
		 falling_space = pieceToBits(falling_t, falling_orient);
		 flag = 0;
		 gameOver = 0;
		 mL_buf = 0;
		 mR_buf = 0;
		 rL_buf = 0;
		 rR_buf = 0;
		 fC_buf = 0;
		 setSignal = 0;
		 reset_buf = 0;
	 end
	 ///////////////
    if (!gameOver && !isPaused) begin
        // FALL
        if (fC_buf[1:0] == 2'b10) begin
          // check if any spaces below falling piece are filled
          // if yes, add piece to static board and generate new piece
          for (i = 0; i < 4 && flag == 0; i = i + 1)
				for (j = 0; j < 4; j = j + 1)
              if (falling_space[i*4+j]) begin
                row_out = falling_row + i - 3;
                col_out = falling_col + j - 2;
                // the top module will automatically get requested block
                if (falling_row + i - 2 == 0 || req_block)
                  flag = 1;
              end
        
          // flag denotes the space was full
          if (flag) begin
            if (falling_row == 18)
                gameOver = 1;
            else begin
                set_space = falling_space;
					 setRow = falling_row/* + 2*/;
					 setCol = falling_col/* + 2*/;
					 setSignal = 1;
                falling_t = (falling_space*falling_col)%7;
                falling_space = pieceToBits(falling_t, falling_orient);
                falling_row = 18;
                falling_col = 6;
            end
            // non-random assignment of the next block
          end
          // if not, move falling block down by one
          else
            falling_row = falling_row - 1;
		  end
        // MOVE LEFT
        flag = 0;
        if (mL_buf[1:0] == 2'b10) begin
          // check if any blocks to left are already filled
          for (i = 0; i < 4 && flag == 0; i = i + 1)
				for (j = 0; j < 4; j = j + 1)
              if (falling_space[i*4+j]) begin
                row_out = falling_row + i - 2;
                col_out = falling_col + j - 3;
                if (falling_col + j == 2 || req_block)
                    flag = 1;
              end

          // if no (flag was not set), move falling left by one
          if (!flag)
            falling_col = falling_col - 1;
        end

        // MOVE RIGHT
        flag = 0;
        if (mR_buf[1:0] == 2'b10) begin
          // check if any blocks to left are already filled
          for (i = 0; i < 4 && flag == 0; i = i + 1)
				for (j = 0; j < 4; j = j + 1)
              if (falling_space[i*4+j]) begin
                row_out = falling_row + i - 2;
                col_out = falling_col + j - 1;
                if (falling_col + j == 11 || req_block)
                    flag = 1;
              end

          // if no (flag was not set), move falling left by one
          if (!flag)
            falling_col = falling_col + 1;
        end

        // ROTATE LEFT
        flag = 0;
        if (rL_buf[1:0] == 2'b10) begin
          pieceBuffer = pieceToBits(falling_t, falling_orient + 1);
          for (i = 0; i < 4 && flag == 0; i = i + 1)
				for (j = 0; j < 4; j = j + 1)
					if (pieceBuffer[i*4+j]) begin
					  row_out = falling_row + i - 2;
					  col_out = falling_col + j - 2;
					  if (falling_row + i < 2 || falling_col + j < 2 || req_block)
						 flag = 1;
					end
          if (!flag) begin
            falling_orient = falling_orient + 1;
          end
        end

        // ROTATE RIGHT
        flag = 0;
        if (rR_buf[1:0] == 2'b10) begin
          pieceBuffer = pieceToBits(falling_t, falling_orient - 1);
          for (i = 0; i < 4 && flag == 0; i = i + 1)
				for (j = 0; j < 4; j = j + 1)
					if (pieceBuffer[i*4+j]) begin
					  row_out = falling_row + i - 2;
					  col_out = falling_col + j - 2;
					  if (falling_row + i < 2 || falling_col + j < 2 || req_block)
						 flag = 1;
					end
          if (!flag)
            falling_orient = falling_orient - 1; 
        end
	 end
  end

  function [15:0] pieceToBits;
	 input [2:0] type;
    input [1:0] orient;
		begin
			case(type)
				3'h0: pieceToBits = 16'b0000011001100000;

				3'h1: case(orient[0])
                1'b0: pieceToBits = 16'b0000000011110000;
                1'b1: pieceToBits = 16'b0010001000100010;
              endcase

			  3'h2: case(orient[0])
						 1'b0: pieceToBits = 16'b0000011000110000;
						 1'b1: pieceToBits = 16'b0000000100110010;
					  endcase

			  3'h3: case(orient[0])
						 1'b0: pieceToBits = 16'b0000001101100000;
						 1'b1: pieceToBits = 16'b0000001000110001;
					  endcase

			  3'h4: case(orient)
						 2'h0: pieceToBits = 16'b0000010001110000;
						 2'h1: pieceToBits = 16'b0000001100100010;
						 2'h2: pieceToBits = 16'b0000000001110001;
						 2'h3: pieceToBits = 16'b0000001000100110;
					  endcase

			  3'h5: case(orient)
						 2'h0: pieceToBits = 16'b0000000101110000;
						 2'h1: pieceToBits = 16'b0000001000100011;
						 2'h2: pieceToBits = 16'b0000000001110100;
						 2'h3: pieceToBits = 16'b0000011000100010;
					  endcase

			  3'h6: case(orient)
						 2'h0: pieceToBits = 16'b0000001001110000;
						 2'h1: pieceToBits = 16'b0000001000110010;
						 2'h2: pieceToBits = 16'b0000000001110010;
						 2'h3: pieceToBits = 16'b0000001001100010;
              endcase
			endcase
		end
	endfunction
endmodule
