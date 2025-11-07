`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/09 21:01:41
// Design Name: 
// Module Name: normalizer
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


module normalizer #(
    parameter CNT = 1000,
    parameter N = 10
)
(
    input clk,
    input rst_n,
    input [31:0] data_in,
    input start_en,
    input data_in_valid,
    output process_end_flag,
    output [31:0] data_out,
    output data_out_valid
);


localparam STATE_IDLE = 6'b000000;
localparam STATE_STORE = 6'b000001;
localparam STATE_CAL_MU = 6'b000010;
localparam STATE_CAL_SIGMA = 6'b000100;


reg [5:0] current_STATE = 6'b0;
reg [5:0] next_STATE = 6'b0;
reg SIGMA_en = 0;

// currunt state
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        current_STATE <= STATE_IDLE;
    end
    else begin
        current_STATE <= next_STATE;
    end
end

wire store_end_flag;
wire cal_mu_end_flag;
wire cal_sigma_end_flag;

// state transfer
always @(*) begin
    case(current_STATE)
        STATE_IDLE : next_STATE = start_en ? STATE_STORE : STATE_IDLE ;
        STATE_STORE : next_STATE = store_end_flag ? STATE_CAL_MU : STATE_STORE;
        STATE_CAL_MU : next_STATE = cal_mu_end_flag ? STATE_CAL_SIGMA : STATE_CAL_MU;
        STATE_CAL_SIGMA : next_STATE = cal_sigma_end_flag ? STATE_IDLE : STATE_CAL_SIGMA;
        default : next_STATE = current_STATE;
    endcase
end

// out logic
always @(*) begin
    case(current_STATE)
        STATE_IDLE:begin
            SIGMA_en = 0;
        end
        STATE_STORE:begin
            SIGMA_en = 0;
        end
        STATE_CAL_MU:begin
            SIGMA_en = 0;
        end
        STATE_CAL_SIGMA:begin
            SIGMA_en = 1;
        end
        default:begin
            SIGMA_en = 0;
        end
    endcase
end

reg [9:0] data_cnt = 10'd0;
reg data_cnt_en = 0;
localparam max_cnt = CNT;
assign store_end_flag = (data_cnt == max_cnt);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_cnt <= 0;
    end
    else begin
        if(data_cnt == max_cnt) begin
            data_cnt <= 0;
        end
        else if (data_in_valid)begin
            data_cnt <= data_cnt + 1;
        end
    end
end


(* ram_style="block" *) reg [31:0] MEM [0:CNT-1];
always @(posedge clk) begin
    if(data_in_valid) begin
        MEM[data_cnt] <= data_in;
    end
end

wire [31:0] shift_data_out_0;
wire shift_data_out_valid_0;
wire [31:0] acc_data_out_0;
wire acc_refresh;
wire [31:0] right_shift_data_in_0;

acc #(
    .BIT(32)
)
acc_inst_0(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(data_in_valid),
    .data_out_valid(acc_data_out_valid_0),
    .data_in(data_in),
    .data_out(acc_data_out_0),
    .ref(acc_refresh)
);

DFF_async #(
    .BIT(32)
)
DFF_inst_3(
    .clk(clk),
    .rst_n(rst_n),
    .Q(acc_data_out_0),
    .D(right_shift_data_in_0)
);

DFF_async #(
    .BIT(1)
)
DFF_inst_4(
    .clk(clk),
    .rst_n(rst_n),
    .Q(acc_data_out_valid_0),
    .D(right_shift_data_in_valid_0)
);

right_shift_N #(
    .N(N),
    .BIT(32)
)
right_shift_N_inst_0 (
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(right_shift_data_in_valid_0),
    .data_in(right_shift_data_in_0),
    .data_out(shift_data_out_0),
    .data_out_valid(shift_data_out_valid_0)
);

wire shift_data_out_valid_0_reg;

DFF_async #(
    .BIT(1)
)
DFF_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .Q(shift_data_out_valid_0),
    .D(shift_data_out_valid_0_reg)
);

DFF_async #(
    .BIT(1)
)
DFF_inst_2(
    .clk(clk),
    .rst_n(rst_n),
    .Q(store_end_flag),
    .D(cal_mu_end_flag)
);

reg [31:0] mu = 0;
reg [31:0] sigma = 0;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        mu <= 0;
    end
    else begin
        if(cal_mu_end_flag) begin
            mu <= shift_data_out_0;
        end
    end
end

wire sub_data_out_valid;
wire [31:0] sub_C_out;
reg sigma_en = 0;
reg sigma_en_reg = 0;
reg sigma_start_en = 0;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sigma_start_en <= 0;
    end
    else if (next_STATE == STATE_CAL_SIGMA) begin
        sigma_start_en <=  cal_mu_end_flag;
    end
end

reg [8:0] sigma_cnt = 0;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sigma_en <= 0;
    end
    else begin
        if(sigma_start_en) begin
            sigma_en <= 1;
        end 
        else if (sigma_cnt == max_cnt - 1)begin
            sigma_en <= 0;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sigma_cnt <= 0;
    end
    else begin
        if(sigma_en) begin
            sigma_cnt <= sigma_cnt + 1;
        end
        else if (sigma_cnt == max_cnt) begin
            sigma_cnt <= 0;
        end
    end
end

reg [31:0] read_data = 0;

sub #(
    .BIT(32)
)
sub_inst_0(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(sigma_en),
    .data_out_valid(sub_data_out_valid),
    .A_in(read_data),
    .B_in(mu),
    .C_out(sub_C_out)
);

wire [63:0] multi_out;
wire multi_out_valid;

multiplier #(
    .BIT(32)
)
multipiler_inst_0(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(sub_data_out_valid),
    .data_out_valid(multi_out_valid),
    .A_in(sub_C_out),
    .B_in(sub_C_out),
    .C_out(multi_out)
);

wire [63:0] acc_data_out_1;

acc #(
    .BIT(64)
)
acc_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(multi_out_valid),
    .data_out_valid(acc_data_out_valid_1),
    .data_in(multi_out),
    .data_out(acc_data_out_1),
    .ref(acc_refresh)
);

wire [63:0] sigma2_data_out;

right_shift_N #(
    .N(N),
    .BIT(64)
)
right_shift_N_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(acc_data_out_valid_1),
    .data_in(acc_data_out_1),
    .data_out(sigma2_data_out),
    .data_out_valid(sigma2_data_out_valid)
);

wire [31:0] fixed2float_data_out;
fixed2float_64 fixed2float_64_inst (
  .aclk(clk),                                  // input wire aclk
  .aclken(1'b1),                              // input wire aclken
  .aresetn(rst_n),                            // input wire aresetn
  .s_axis_a_tvalid(sigma2_data_out_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(sigma2_data_out),              // input wire [63 : 0] s_axis_a_tdata
  .m_axis_result_tvalid(fixed2float_data_out_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(fixed2float_data_out)    // output wire [31 : 0] m_axis_result_tdata
);


wire sqrt_data_out_valid;
wire [31:0] sqrt_data_out;

sqrt sqrt_inst (
  .aclk(clk),                                  // input wire aclk
  .aclken(1'b1),                              // input wire aclken
  .aresetn(rst_n),                            // input wire aresetn
  .s_axis_a_tvalid(fixed2float_data_out_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(fixed2float_data_out),              // input wire [31 : 0] s_axis_a_tdata
  .m_axis_result_tvalid(sqrt_data_out_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(sqrt_data_out)    // output wire [31 : 0] m_axis_result_tdata
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sigma <= 0;
    end 
    else if (sqrt_data_out_valid) begin
        sigma <= sqrt_data_out;
    end
end


assign cal_sigma_end_flag = sqrt_data_out_valid && (current_STATE == STATE_CAL_SIGMA);
reg [9:0] divide_data_cnt = 0;
reg divide_en = 0;
reg sigma_valid = 0;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        sigma_valid <= 0;
    end
    else begin
        if(cal_sigma_end_flag) begin
            sigma_valid <= 1;
        end
        else if (process_end_flag) begin
            sigma_valid <= 0;
        end
    end
end



always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        divide_data_cnt <= 0;
        divide_en <= 0;
    end
    else begin
        if(cal_sigma_end_flag) begin
            divide_en <= 1;
        end
        else if (divide_data_cnt == max_cnt - 1)begin
            divide_en <= 0;
        end
        if(divide_en) begin
            divide_data_cnt <= divide_data_cnt + 1;
        end
        else begin
            divide_data_cnt <= 0;
        end
    end
end


always @(posedge clk) begin
    if(sigma_en) begin
        read_data = MEM[sigma_cnt];
    end
    else if (divide_en) begin
        read_data = MEM[divide_data_cnt];
    end
    else begin
        read_data = 0;
    end
end

wire [31:0] sub_C_out1;

sub #(
    .BIT(32)
)
sub_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .data_in_valid(divide_en),
    .data_out_valid(sub1_data_out_valid),
    .A_in(read_data),
    .B_in(mu),
    .C_out(sub_C_out1)
);

wire [31:0] fixed2float_32_1_data_out;
wire fixed2float_32_1_data_out_valid;
fixed2float_32 fixed2float_32_inst_1 (
  .aclk(clk),                                  // input wire aclk
  .aclken(1'b1),                              // input wire aclken
  .aresetn(rst_n),                            // input wire aresetn
  .s_axis_a_tvalid(sub1_data_out_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(sub_C_out1),              // input wire [63 : 0] s_axis_a_tdata
  .m_axis_result_tvalid(fixed2float_32_1_data_out_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(fixed2float_32_1_data_out)    // output wire [31 : 0] m_axis_result_tdata
);

wire divide_data_in_valid;
wire [31:0] divide_data_in;

DFF_async #(
    .BIT(32)
)
DFF_inst_5(
    .clk(clk),
    .rst_n(rst_n),
    .Q(fixed2float_32_1_data_out),
    .D(divide_data_in)
);

DFF_async #(
    .BIT(1)
)
DFF_inst_6(
    .clk(clk),
    .rst_n(rst_n),
    .Q(fixed2float_32_1_data_out_valid),
    .D(divide_data_in_valid)
);

//wire [31:0] norm_data_out;
wire [31:0] norm_data_out_float;

divide_float divide_float_inst(
  .aclk(clk),                                  // input wire aclk
  .aclken(1'b1),                              // input wire aclken
  .aresetn(rst_n),                            // input wire aresetn
  .s_axis_a_tvalid(divide_data_in_valid),            // input wire s_axis_a_tvalid
  .s_axis_a_tdata(divide_data_in),              // input wire [31 : 0] s_axis_a_tdata
  .s_axis_b_tvalid(sigma_valid),            // input wire s_axis_b_tvalid
  .s_axis_b_tdata(sigma),              // input wire [31 : 0] s_axis_b_tdata
  .m_axis_result_tvalid(norm_data_out_float_valid),  // output wire m_axis_result_tvalid
  .m_axis_result_tdata(norm_data_out_float)    // output wire [31 : 0] m_axis_result_tdata
);

//float2fixed float2fixed_inst (
//  .aclk(clk),                                  // input wire aclk
//  .aclken(1'b1),                              // input wire aclken
//  .aresetn(rst_n),                            // input wire aresetn
//  .s_axis_a_tvalid(norm_data_out_float_valid),            // input wire s_axis_a_tvalid
//  .s_axis_a_tdata(norm_data_out_float),              // input wire [31 : 0] s_axis_a_tdata
//  .m_axis_result_tvalid(norm_data_out_valid),  // output wire m_axis_result_tvalid
//  .m_axis_result_tdata(norm_data_out)    // output wire [31 : 0] m_axis_result_tdata
//);


assign data_out = norm_data_out_float;
assign data_out_valid = norm_data_out_float_valid;

reg data_out_valid_reg = 0;
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin 
        data_out_valid_reg <= 0;
    end
    else begin
        data_out_valid_reg  <= data_out_valid;
    end
end


assign process_end_flag = data_out_valid_reg && ~data_out_valid;
assign acc_refresh = data_out_valid_reg && ~data_out_valid;


endmodule
