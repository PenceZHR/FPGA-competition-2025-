`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/22 00:33:43
// Design Name: 
// Module Name: clear_fifo
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


module clear_fifo #(
    parameter CNT = 256    
)
(
    input clk,
    input rst_n,
    input start_flag,
    output reg read_en 
);

reg [9:0] cnt = 0;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        read_en <= 0;
        cnt <= 0;
    end
    else begin
        if(start_flag) begin
            read_en <= 1;
        end
        else if(cnt == CNT - 1) begin
            read_en <= 0;            
        end
        if(cnt == CNT - 1) begin

            cnt <= 0;
        end
        else if(read_en) begin
            cnt <= cnt + 1;
        end
    end 

end

endmodule
