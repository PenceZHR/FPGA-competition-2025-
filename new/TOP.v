`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/20 12:40:47
// Design Name: 
// Module Name: TOP
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


module Process_Top #(
    parameter CNT = 1000,
    parameter N = 10
)
(
    input clk,
    input rst_n,
    input [15:0] data_in,
    input data_in_valid,
    input [4:0] ch,
    input start_flag,
    output process_data_out_valid,
    output [31:0] process_data_out,
    output data_out_last
);
       
    
wire [351:0] data_out;
wire data_out_valid;

Data_Acq Data_Acq_inst(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .data_in_valid(data_in_valid),
    .ch(ch),
    .data_out(data_out),
    .data_out_valid(data_out_valid)
    );
//ila_0 ila_inst_0 (
//	.clk(clk), // input wire clk
//	.probe0(data_in), // input wire [15:0]  probe0  
//	.probe1(data_in_valid), // input wire [0:0]  probe1 
//	.probe2(ch), // input wire [4:0]  probe2
//	.probe3(start_flag), // input wire [4:0]  probe2
//	.probe4(process_data_out_valid) // input wire [4:0]  probe2
//);
   

wire process_data_in_valid;
wire [351:0] process_data_in;

DFF_async#(
    .BIT(1)
)
DFF_inst_0(
    .clk(clk),
    .rst_n(rst_n),
    .Q(data_out_valid),
    .D(process_data_in_valid)
);

DFF_async #(
    .BIT(352)
)
DFF_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .Q(data_out),
    .D(process_data_in)
);

Process #(
    .CNT(CNT),
    .N(N)
) Process_inst(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(process_data_in_valid),
    .data_in(process_data_in),
    .start_flag(start_flag),
    .data_out(process_data_out),
    .data_out_valid(process_data_out_valid),
    .data_out_last(data_out_last)
);

endmodule
