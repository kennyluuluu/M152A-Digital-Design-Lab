`timescale 1ns / 1ps

//=========== VGA Components for 640x480p ===========//

/*module PLL(clk, pixelclk);	//setting DE10-Lite 50Mhz clk to 25Mhz pixel clk
	
	input clk;
	output pixelclk;
	
	reg pixelclk;
	
	always @ (posedge clk50) begin
		pixelclk = (pixelclk) ? 1'b0 : 1'b1;	//Cuts frequency in half
	end
	
endmodule*/

module hsync(pixelclk, hsync_out, blank_out, newline_out);

	parameter TOTAL_COUNTER = 800;
	parameter SYNC = 96;
	parameter BACKPORCH = 48;
	parameter DISPLAY = 640;
	parameter FRONTPORCH = 16;

	input pixelclk;
	output hsync_out, blank_out, newline_out;
	
	
	reg hsync_out, blank_out, newline_out;
	reg [15:0] counter = 16'b0;
	
	always @ (posedge pixelclk) begin	//counter
		
		if(counter < TOTAL_COUNTER)						//reset counter if every 800 clk cycles
			counter <= counter + 16'b0000000000000001;
		else
			counter <= 16'b0;
			
	end
	
	always @ (posedge pixelclk) begin	//hsync
	
		if(counter < (DISPLAY + FRONTPORCH))
			hsync_out <= 1;
		else if(counter >= (DISPLAY + FRONTPORCH) && counter < (DISPLAY + FRONTPORCH + SYNC))
			hsync_out <= 0;
		else if(counter >= (DISPLAY + FRONTPORCH + SYNC))	
			hsync_out <= 1;	
			
	end
	
	always @ (posedge pixelclk) begin	//blank
													//high during display interval
		if(counter < DISPLAY)
			blank_out <= 0;
		else
			blank_out <= 1;
		
	end
	
	always @ (posedge pixelclk) begin	//newline
	
		if(counter == 0)
			newline_out <= 1;
		else
			newline_out <= 0;
	
	end

endmodule

module vsync(newline_in, vsync_out, blank_out);

	parameter TOTAL_COUNTER = 525;
	parameter SYNC = 2;
	parameter BACKPORCH = 33;
	parameter DISPLAY = 480;
	parameter FRONTPORCH = 10;

	input newline_in;
	output vsync_out, blank_out;
	
	reg vsync_out, blank_out;
	reg [15:0] counter = 16'b0;
	
	always @ (posedge newline_in) begin	//counter
		if(counter < TOTAL_COUNTER)
			counter <= counter + 16'b0000000000000001;
		else
			counter <= 16'b0;
	end
	
	always @ (posedge newline_in) begin	//vsync
		if(counter < (DISPLAY + FRONTPORCH))
			vsync_out <= 1;
		else if(counter >= (DISPLAY + FRONTPORCH) && counter < (DISPLAY + FRONTPORCH + SYNC))
			vsync_out <= 0;
		else if(counter >= (DISPLAY + FRONTPORCH + SYNC))
			vsync_out <= 1;
	end
	
	always @ (posedge newline_in) begin	//blank
		if(counter < DISPLAY)
			blank_out <= 0;
		else
			blank_out <= 1;
	end

endmodule


module data(clk, board, hblank, vblank, r, g, b, falling_t, falling_space, falling_row, falling_col);

	input clk, hblank, vblank;
    input [199:0] board;
    
    input [2:0] falling_t;
    input [15:0] falling_space;
    input [4:0] falling_row;
    input [3:0] falling_col;
    
	output [2:0] r, g;
    output [1:0] b;
	
	reg [2:0] r, g;
    reg [1:0] b;
    reg [11:0] horizontalcounter;
    reg [11:0] verticalcounter;
    reg [4:0] curRow;
    reg [3:0] curCol;
	
    initial begin
      horizontalcounter = 0;
      verticalcounter = 0;
      curRow = 0;
      curCol = 0;
    end
    
	always @ (posedge clk) begin
        horizontalcounter <= horizontalcounter + 1;
        if(horizontalcounter >= 800) begin // 800 is hsync total counter
            horizontalcounter <= 0;
            verticalcounter <= verticalcounter + 1;
            if(verticalcounter >= 525) begin   // 525 is vsync total counter
                verticalcounter <= 0;
            end
        end
		if (hblank == 1 || vblank == 1) begin //buffer
			r <= 0;
			g <= 0;
			b <= 0;
		end
		else begin //not buffer
            curRow = 19-(verticalcounter-40)/20;
            curCol = (horizontalcounter-220)/20;
            if(verticalcounter < 40 || verticalcounter > 440 || horizontalcounter < 220 || horizontalcounter > 420) begin //outside of board
              r <= 3'b100;
              g <= 3'b100;
              b <= 2'b10;
            end
            else begin  //board colors
              if ( board[(19-(verticalcounter-40)/20)*10+((horizontalcounter-220)/20)] ) begin // valid colors
                r <= 3'b001;
                g <= 3'b110;
                b <= 2'b01;
              end
              else if (curRow+2-falling_row<4 && curCol+2-falling_col<4 &&
                       falling_space[(curRow+2-falling_row)*4+curCol+2-falling_col]) begin
                 // falling piece
                 r <= 3'b000;
                 g <= 3'b010;
                 b <= 2'b11;
              end
              else begin //invalid colors
              r <= 3'b110;
              g <= 3'b110;
              b <= 2'b10;
              end
            end
		end
        
	end

endmodule

module vgacontroller(vgaHz, board, vsync, hsync, r, g, b, falling_t, falling_space, falling_row, falling_col);

	input vgaHz;
    input [199:0] board;
    input [2:0] falling_t;
    input [15:0] falling_space;
    input [4:0] falling_row;
    input [3:0] falling_col;
	output vsync, hsync;
	output [2:0] r, g;
    output [1:0] b;
	
	wire vgaHz, hblank, vblank, newline;
	
	/*PLL clockdivider(clk50, pixelclk);*/
	
	hsync horizontal(vgaHz, hsync, hblank, newline);
	vsync vertical(newline, vsync, vblank);
	
	data display(vgaHz, board, hblank, vblank, r, g, b, falling_t, falling_space, falling_row, falling_col);
	
endmodule

