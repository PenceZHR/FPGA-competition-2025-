`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/22 08:54:10
// Design Name: 
// Module Name: FIR_NORM
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


module FIR_NORM #(
    parameter CNT = 1000,
    parameter N = 10
)
(
    input clk,
    input rst_n,
    input start_flag,
    input [175:0] data_in,
    input data_in_valid,
    output [351:0] data_out,
    output data_out_valid,
    output process_end_flag
);

wire [351:0] fir_data_out;
wire [31:0] data_in_ch0, data_in_ch1, data_in_ch2, data_in_ch3, data_in_ch4, data_in_ch5, data_in_ch6,
             data_in_ch7, data_in_ch8, data_in_ch9, data_in_ch10;
wire fir_data_out_valid;

wire [31:0] data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7, data_out8, data_out9, data_out10;

fir_compiler_0 fir_compiler_inst(
  .aresetn(rst_n),                        // input wire aresetn
  .aclk(clk),                              // input wire aclk
  .aclken(1'b1),                          // input wire aclken
  .s_axis_data_tvalid(data_in_valid),  // input wire s_axis_data_tvalid
  .s_axis_data_tready(fir_data_out_ready),  // output wire s_axis_data_tready
  .s_axis_data_tdata(data_in),    // input wire [175 : 0] s_axis_data_tdata
  .m_axis_data_tvalid(fir_data_out_valid),  // output wire m_axis_data_tvalid
  .m_axis_data_tdata(fir_data_out)    // output wire [439 : 0] m_axis_data_tdata
);

wire fir_data_out_valid_reg;
wire norm_start_en;

DFF_async #(
    .BIT(1)
)
DFF_inst5(
    .clk(clk),
    .rst_n(rst_n),
    .Q(fir_data_out_valid),
    .D(fir_data_out_valid_reg)
);

reg process_en = 0;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        process_en <= 0;
    end
    else if(start_flag) begin
        process_en <= 1;
    end
    else if(process_end_flag) begin
        process_en <= 0;
    end
end

assign norm_start_en = fir_data_out_valid && ~fir_data_out_valid_reg;
wire norm_data_in_valid;
assign norm_data_in_valid = fir_data_out_valid_reg;
wire [351:0] FIR_data_out_reg;

DFF_async #(
    .BIT(352)
)
DFF_inst6(
    .clk(clk),
    .rst_n(rst_n),
    .Q(fir_data_out),
    .D(FIR_data_out_reg)
);

assign data_in_ch0  = FIR_data_out_reg[351:320];
assign data_in_ch1  = FIR_data_out_reg[319:288];
assign data_in_ch2  = FIR_data_out_reg[287:256];
assign data_in_ch3  = FIR_data_out_reg[255:224];
assign data_in_ch4  = FIR_data_out_reg[223:192];
assign data_in_ch5  = FIR_data_out_reg[191:160];
assign data_in_ch6  = FIR_data_out_reg[159:128];
assign data_in_ch7  = FIR_data_out_reg[127:96];
assign data_in_ch8  = FIR_data_out_reg[95:64];
assign data_in_ch9  = FIR_data_out_reg[63:32];
assign data_in_ch10 = FIR_data_out_reg[31:0];

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst0(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch0),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag0),
    .data_out         (data_out0),
    .data_out_valid   (data_out_valid0)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst1(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch1),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag1),
    .data_out         (data_out1),
    .data_out_valid   (data_out_valid1)
);

normalizer #(
    .CNT(CNT),
    .N(N)
)normalizer_inst2(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch2),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag2),
    .data_out         (data_out2),
    .data_out_valid   (data_out_valid2)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst3(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch3),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag3),
    .data_out         (data_out3),
    .data_out_valid   (data_out_valid3)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst4(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch4),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag4),
    .data_out         (data_out4),
    .data_out_valid   (data_out_valid4)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst5(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch5),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag5),
    .data_out         (data_out5),
    .data_out_valid   (data_out_valid5)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst6(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch6),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag6),
    .data_out         (data_out6),
    .data_out_valid   (data_out_valid6)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst7(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch7),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag7),
    .data_out         (data_out7),
    .data_out_valid   (data_out_valid7)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst8(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch8),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag8),
    .data_out         (data_out8),
    .data_out_valid   (data_out_valid8)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst9(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch9),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag9),
    .data_out         (data_out9),
    .data_out_valid   (data_out_valid9)
);

normalizer #(
    .CNT(CNT),
    .N(N)
) normalizer_inst10(
    .clk              (clk),
    .rst_n            (rst_n),
    .start_en         (norm_start_en),
    .data_in          (data_in_ch10),
    .data_in_valid    (norm_data_in_valid),
    .process_end_flag (process_end_flag10),
    .data_out         (data_out10),
    .data_out_valid   (data_out_valid10)
);

assign data_out_valid = data_out_valid0 || data_out_valid1 || data_out_valid2 || data_out_valid3 || data_out_valid4 || 
                            data_out_valid5 || data_out_valid6 || data_out_valid7 || data_out_valid8 || data_out_valid9 || data_out_valid10;
assign data_out = {data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7, data_out8, data_out9, data_out10};
assign process_end_flag = process_end_flag0 | process_end_flag1 | process_end_flag2 | process_end_flag3 | process_end_flag4 | 
                process_end_flag5 | process_end_flag6 | process_end_flag7 | process_end_flag8 | process_end_flag9 | process_end_flag10;


endmodule
