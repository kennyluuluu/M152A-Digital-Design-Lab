`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:24:14 05/15/2018 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer(clk, btnLeft, btnRight, btnCW, btnCCW, btnRst, 
                      is_btnLeft_posedge, is_btnRight_posedge,  is_btnCW_posedge, is_btnCCW_posedge, is_btnRst_posedge
    );

	input clk, btnLeft, btnRight, btnCW, btnCCW, btnRst;
	output is_btnLeft_posedge, is_btnRight_posedge, is_btnCW_posedge, is_btnCCW_posedge, is_btnRst_posedge;
	
	wire btnLeft, btnRight, btnCW, btnCCW, btnRst, clk;
	wire is_btnLeft_posedge, is_btnRight_posedge, is_btnCW_posedge, is_btnCCW_posedge, is_btnRst_posedge;
	reg [2:0] step_dL, step_dR, step_dCW, step_dCCW, step_dRst;
	
	always @ (posedge clk) begin		
		step_dL[2:0] <= {btnLeft, step_dL[2:1]};
		step_dR[2:0] <= {btnRight, step_dR[2:1]};
		step_dCW[2:0] <= {btnCW, step_dCW[2:1]};
		step_dCCW[2:0] <= {btnCCW, step_dCCW[2:1]};
		step_dRst[2:0] <= {btnRst, step_dRst[2:1]};
	end
	
	assign is_btnLeft_posedge = ~ step_dL[0] & step_dL[1];
	assign is_btnRight_posedge = ~ step_dR[0] & step_dR[1];
	assign is_btnCW_posedge = ~ step_dCW[0] & step_dCW[1];
	assign is_btnCCW_posedge = ~ step_dCCW[0] & step_dCCW[1];
	assign is_btnRst_posedge = ~ step_dRst[0] & step_dRst[1];


endmodule
