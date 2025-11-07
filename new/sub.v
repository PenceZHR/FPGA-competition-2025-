`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 12:54:09
// Design Name: 
// Module Name: sub
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


module sub #(
    parameter BIT = 32
)
(
    input clk,
    input rst_n,
    input data_in_valid,
    output reg data_out_valid,
    input [BIT-1:0] A_in,
    input [BIT-1:0] B_in,
    output reg [BIT-1:0] C_out
    );

wire  signed [BIT-1:0] A_in_signed;
wire  signed [BIT-1:0] B_in_signed;
assign A_in_signed = A_in;
assign B_in_signed = B_in;
    
    
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        C_out <= 0;
        data_out_valid <= 0;
    end
    else begin
        C_out <= A_in - B_in;
        data_out_valid <= data_in_valid;
    end
end

endmodule
