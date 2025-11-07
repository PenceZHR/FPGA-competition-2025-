`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/15 09:51:41
// Design Name: 
// Module Name: right_shift_N
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


module right_shift_N #(
    parameter N = 4,
    parameter BIT = 40
)
(
    input clk,
    input rst_n,
    input data_in_valid,
    input [BIT-1:0] data_in,
    output reg [BIT-1:0] data_out,
    output reg data_out_valid
    );
    
    
wire signed [BIT-1:0] data_in_signed;
assign data_in_signed = data_in;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_out <= 0;
        data_out_valid <= 0;
    end
    else if(data_in_valid) begin
        data_out_valid <= data_in_valid;
        data_out <= data_in_signed >>> N;
    end
    else begin
        data_out <= 0;
        data_out_valid <= 0;
    end
end


    
    
endmodule
