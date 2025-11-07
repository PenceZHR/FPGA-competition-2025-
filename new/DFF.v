`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/20 13:20:25
// Design Name: 
// Module Name: DFF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module DFF_async #(
    parameter BIT = 1
)
(
    input clk,
    input rst_n,
    input [BIT-1:0] Q,
    output reg [BIT-1:0] D
    );
    
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        D <= 0;
    end
    else begin
        D <= Q;
    end
end
endmodule
