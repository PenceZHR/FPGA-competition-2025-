`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/17 08:48:46
// Design Name: 
// Module Name: acc
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


module acc #(
    parameter BIT = 32
)
(
    input clk,
    input rst_n,
    input data_in_valid,
    input [BIT-1:0] data_in,
    output reg data_out_valid,
    output reg [BIT-1:0] data_out,
    input ref
);
reg [BIT-1:0] sum = 0;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    sum <= 0;
    data_out <= 0;
    data_out_valid <= 0;
  end else begin
    if (ref) begin
      sum <= 0;
    end else if (data_in_valid) begin
      sum <= sum + data_in;
    end
    // 输出打一拍（或在 data_in_valid 边界输出，看你协议）
    data_out <= sum;
    data_out_valid <= data_in_valid; // 或者按你的需要产生脉冲
  end
end

endmodule
