`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:04:11 04/12/2018 
// Design Name: 
// Module Name:    FPCVT 
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
module FPCVT(D,S,E,F);
	
	input [11:0] D;
	output S;
	output [2:0] E;
	output [3:0] F;
	
	wire [11:0] D, out1;
	wire S, fifthbit;
	wire [2:0] E, exponent;
	wire [3:0] F, significand; 
		
	TwotoSigned convert1(D,out1);
	assign S = out1[11];

	block2 count1 (out1[10:0],exponent,significand,fifthbit);
	
	rounding round1 (exponent,significand,fifthbit, E, F);
	
	
	
endmodule

module TwotoSigned(D,out);

	input [11:0] D;
	output [11:0] out;
	reg [10:0] mask;
	reg [11:0] out;
	wire [11:0] D;
	
	always @ *
	begin
		if (D == 12'b1000_0000_0000)
			out = 12'b1111_1111_1111;
		else
			begin
				if(D[11] == 1)
					mask = 11'b111_1111_1111;
				else
					mask = 11'b000_0000_0000;
				//mask = D >> 11;								// "Flip add one" logic
				out = (D[10:0] ^ mask[10:0]) + D[11]; 	// Only flips and adds if D[11] == 1 (aka number is <0)
				out[11] = D[11];
			end
	end
	
endmodule

module block2(in,exponent,significand,fifthbit);

	input [10:0] in;
	output [2:0] exponent;
	output [3:0] significand;
	output fifthbit;
	
	reg [2:0] exponent;
	reg [3:0] significand;
	reg fifthbit;
	
	always @ *
	begin
		if(in[10] == 1) begin
			exponent = 3'b111;
			significand = in[10:7];
			fifthbit = in[6];
		end
		else if(in[9] == 1) begin
			exponent = 3'b110;
			significand = in[9:6];
			fifthbit = in[5];
		end
		else if(in[8] == 1) begin
			exponent = 3'b101;
			significand = in[8:5];
			fifthbit = in[4];
		end
		else if(in[7] == 1) begin
			exponent = 3'b100;
			significand = in[7:4];
			fifthbit = in[3];
		end
		else if(in[6] == 1) begin
			exponent = 3'b011;
			significand = in[6:3];
			fifthbit = in[2];
		end
		else if(in[5] == 1) begin
			exponent = 3'b010;
			significand = in[5:2];
			fifthbit = in[1];
		end
		else if(in[4] == 1) begin
			exponent = 3'b001;
			significand = in[4:1];
			fifthbit = in[0];
		end
		else begin
			exponent = 3'b000;
			significand = in[3:0];
			fifthbit = 0;
		end
	end


endmodule

module rounding(exponent,significand,fifthbit, E, F);

	input [2:0] exponent;
	input [3:0] significand;
	input fifthbit;
	output [2:0] E;
	output [3:0] F;
	
	reg [3:0] F;
	reg [2:0] E;
	
	always @ * begin
		if (significand == 4'b1111 && fifthbit) begin
			if (exponent == 3'b111) begin
					E = exponent;
					F = significand;
				end
			else
				begin
					E = exponent + 1;
					F = 4'b1000;
				end
		end
		else begin
			F = significand + fifthbit;
			E = exponent;
		end
	end

endmodule
