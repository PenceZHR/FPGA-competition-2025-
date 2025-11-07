`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/18 23:39:35
// Design Name: 
// Module Name: pre_process_top
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


module pre_process_top(
    input clk,
    input rst_n,
    output sd_clk,
    output sd_cs,
    output sd_mosi,
    input sd_miso,
    output clk_1khz,
    output sd_init_done,
    output clk_250hz,
    input start_flag
);

wire [511:0] sig_out;

sig_gen sig_gen_inst(
    .clk(clk),
    .rst_n(rst_n),
    .sig_out(sig_out),
    .sd_clk(sd_clk),
    .sd_cs(sd_cs),
    .sd_mosi(sd_mosi),
    .sd_miso(sd_miso),
    .clk_1khz(clk_1khz),
    .sd_init_done(sd_init_done),
    .clk_250hz(clk_250hz)
);
clk_wiz_fir clk_fir_inst0
(
    // Clock out ports
    .clk_out1(clk_500Mhz),     // output clk_out1
    .clk_out2(clk_300Mhz),     // output clk_out2
    // Status and control signals
    .reset(~rst_n), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1
// INST_TAG_END ------ End INSTANTIATION Template ---------

wire [703:0] process_data_out;

Process Process_inst(
    .clk(clk),
    .clk_500Mhz(clk_500Mhz),
    .clk_300Mhz(clk_300Mhz),
    .rst_n(rst_n),
    .data_in_valid(clk_250hz),
    .data_in(sig_out),
    .start_flag(start_flag),
    .data_out(process_data_out),
    .data_out_valid(process_data_out_valid)
 );





endmodule
