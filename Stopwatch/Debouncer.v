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
module Debouncer(clk, btnPause, btnReset, is_btnPause_posedge, is_btnReset_posedge 
    );

	input clk, btnPause, btnReset;
	output is_btnPause_posedge, is_btnReset_posedge;
	
	wire btnPause, btnReset,clk;
	wire is_btnPause_posedge, is_btnReset_posedge;
	reg [2:0] step_dp, step_dr;
	
	always @ (posedge clk) begin		
		step_dp[2:0] <= {btnPause, step_dp[2:1]};
		step_dr[2:0] <= {btnReset, step_dr[2:1]};
	end
	
	assign is_btnPause_posedge = ~ step_dp[0] & step_dp[1];
	assign is_btnReset_posedge = ~ step_dr[0] & step_dr[1];


endmodule
