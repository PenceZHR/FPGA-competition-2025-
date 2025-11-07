`timescale 1ns / 1ps
module Process #(
    parameter CNT = 1000,
    parameter N = 10
)
(
    input clk,
    input rst_n,
    input data_in_valid,
    input [351:0] data_in,
    input start_flag,
    output reg [31:0] data_out,
    output data_out_valid,
    output data_out_last
    );

localparam STATE_IDLE = 4'b0000;
localparam STATE_GET_DATA = 4'b0001;
localparam STATE_NORM0_TO_FIFO = 4'b0010;
localparam STATE_NORM1_TO_FIFO = 4'b0100;
localparam STATE_TRANSMIT = 4'b1000;

wire store_end_flag_reg;
wire FIFO_rd_en_0, FIFO_rd_en_1;
wire [31:0] dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, dout_8, dout_9,
            dout_10, dout_11, dout_12, dout_13, dout_14, dout_15, dout_16, dout_17, dout_18, dout_19, dout_20, dout_21;


wire process_end_flag;
reg start_flag_reg0 = 0;
reg start_flag_reg1 = 0;
wire FIR_NORM0_end_flag;
wire FIR_NORM1_end_flag;
wire FIR_NORM_end_flag;
assign FIR_NORM_end_flag = FIR_NORM0_end_flag || FIR_NORM1_end_flag;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        start_flag_reg0 <= 0;
        start_flag_reg1 <= 0;
    end
    else begin
        start_flag_reg0 <= start_flag;
        start_flag_reg1 <= start_flag_reg0;
    end
end 

wire process_start_en;
assign process_start_en = start_flag_reg0 && ~start_flag_reg1;
wire FIR_NORM_process_end_flag;
reg [3:0] current_state = 0;
reg [3:0] next_state = 0;
//state transfer
always  @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        current_state <= 0;
    end
    else begin
        current_state <= next_state;
    end
end
wire store_end_flag;
reg TRANSMIT_end_flag = 0;
// state transfer
always @(*) begin
    case(current_state)
        STATE_IDLE : next_state = process_start_en ? STATE_GET_DATA : STATE_IDLE ;
        STATE_GET_DATA : next_state = store_end_flag ? STATE_NORM0_TO_FIFO : STATE_GET_DATA;
        STATE_NORM0_TO_FIFO : next_state = FIR_NORM0_end_flag ?  STATE_NORM1_TO_FIFO: STATE_NORM0_TO_FIFO;
        STATE_NORM1_TO_FIFO : next_state = FIR_NORM1_end_flag ? STATE_TRANSMIT : STATE_NORM1_TO_FIFO;
        STATE_TRANSMIT : next_state = TRANSMIT_end_flag ? STATE_IDLE : STATE_TRANSMIT; 
        default : next_state = current_state;
    endcase
end

assign FIR_NORM0_end_flag = ( current_state == STATE_NORM0_TO_FIFO ) && FIR_NORM_process_end_flag;
assign FIR_NORM1_end_flag = ( current_state == STATE_NORM1_TO_FIFO ) && FIR_NORM_process_end_flag;

wire FIFO_16_wr_en;
assign FIFO_16_wr_en = data_in_valid && (current_state == STATE_GET_DATA);
wire [175:0] FIFO_dout_0;
wire [175:0] FIFO_dout_1;

FIFO_16 FIFO_inst_0 (
  .clk(clk),      // input wire clk
  .srst(~rst_n),    // input wire srst
  .din(data_in[351:176]),      // 
  .wr_en(FIFO_16_wr_en),  // input wire wr_en
  .rd_en(FIFO_rd_en_0),  // input wire rd_en
  .dout(FIFO_dout_0)    // 
);

FIFO_16 FIFO_inst_1 (
  .clk(clk),      // input wire clk
  .srst(~rst_n),    // input wire srst
  .din(data_in[175:0]),      // 
  .wr_en(FIFO_16_wr_en),  // input wire wr_en
  .rd_en(FIFO_rd_en_1),  // input wire rd_en
  .dout(FIFO_dout_1)    // 
);

wire data_in_valid_reg;
reg [9:0] data_in_cnt = 0;
DFF_async #(
    .BIT(1)
)
DFF_inst_1(
    .clk(clk),
    .rst_n(rst_n),
    .Q(data_in_valid),
    .D(data_in_valid_reg)
);

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_in_cnt <= 0;
    end
    else if (current_state == STATE_GET_DATA) begin
        if(data_in_cnt == CNT-1) begin
            data_in_cnt <= 0;
        end
        else if (data_in_valid_reg) begin
            data_in_cnt <= data_in_cnt + 1;
        end
    end
end

assign store_end_flag = (current_state == STATE_GET_DATA) && (data_in_cnt == CNT-1);
reg clear_start_flag = 0;
wire clear_read_en;
clear_fifo #(
    .CNT(CNT)
)
clear_fifo_inst0(
    .clk(clk),
    .rst_n(rst_n),
    .start_flag(clear_start_flag),
    .read_en(clear_read_en)
);

DFF_async #(
    .BIT(1)
)
DFF_inst_3(
    .clk(clk),
    .rst_n(rst_n),
    .Q(store_end_flag),
    .D(store_end_flag_reg)
);

wire FIR_NORM_end_flag_reg;

always @(*) begin
    case(current_state)
        STATE_IDLE:clear_start_flag = 0;
        STATE_GET_DATA:clear_start_flag = 0;
        STATE_NORM0_TO_FIFO:clear_start_flag = store_end_flag_reg;
        STATE_NORM1_TO_FIFO:clear_start_flag = FIR_NORM_end_flag_reg;
        default:clear_start_flag = 0;
    endcase
end

assign FIFO_rd_en_0 = (current_state == STATE_NORM0_TO_FIFO) ? clear_read_en : 0;
assign FIFO_rd_en_1 = (current_state == STATE_NORM1_TO_FIFO) ? clear_read_en : 0;

wire [351:0] FIR_NORM_data_out;
wire FIR_NORM_data_out_valid;
wire clear_rd_en_reg;

DFF_async #(
    .BIT(1)
)
DFF_inst_0(
    .clk(clk),
    .rst_n(rst_n),
    .Q(clear_read_en),
    .D(clear_read_en_reg)
);

reg [175:0] FIR_NORM_data_in = 0;
assign FIR_NORM_data_in_valid = (current_state == STATE_NORM0_TO_FIFO || current_state == STATE_NORM1_TO_FIFO ) && clear_read_en_reg;

always @(*) begin
    case(current_state)
        STATE_NORM0_TO_FIFO:FIR_NORM_data_in = FIFO_dout_0;
        STATE_NORM1_TO_FIFO:FIR_NORM_data_in = FIFO_dout_1;
        default:FIR_NORM_data_in = 0;
    endcase
end

wire FIR_NORM_start_flag;
assign FIR_NORM_start_flag = store_end_flag || FIR_NORM0_end_flag;

FIR_NORM #(
    .CNT(CNT),
    .N(N)
)
FIR_NORM_inst(
    .clk(clk),
    .rst_n(rst_n),
    .data_in(FIR_NORM_data_in),
    .start_flag(FIR_NORM_start_flag),
    .data_in_valid(FIR_NORM_data_in_valid),
    .data_out(FIR_NORM_data_out),
    .data_out_valid(FIR_NORM_data_out_valid),
    .process_end_flag(FIR_NORM_process_end_flag)
);

DFF_async #(
    .BIT(1)
)
DFF_inst_2(
    .clk(clk),
    .rst_n(rst_n),
    .Q(FIR_NORM_end_flag),
    .D(FIR_NORM_end_flag_reg)
);

wire rd_en;

// FIR_NORM_data_out[351:0] -> 11x32b FIFOs (inst_0 .. inst_10)
FIFO_32 FIFO_32_inst_0 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[351:320]),  // 32b
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en0),
  .dout  (dout_0)
);

FIFO_32 FIFO_32_inst_1 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[319:288]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en1),
  .dout  (dout_1)
);

FIFO_32 FIFO_32_inst_2 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[287:256]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en2),
  .dout  (dout_2)
);

FIFO_32 FIFO_32_inst_3 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[255:224]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en3),
  .dout  (dout_3)
);

FIFO_32 FIFO_32_inst_4 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[223:192]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en4),
  .dout  (dout_4)
);

FIFO_32 FIFO_32_inst_5 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[191:160]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en5),
  .dout  (dout_5)
);

FIFO_32 FIFO_32_inst_6 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[159:128]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en6),
  .dout  (dout_6)
);

FIFO_32 FIFO_32_inst_7 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[127:96]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en7),
  .dout  (dout_7)
);

FIFO_32 FIFO_32_inst_8 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[95:64]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en8),
  .dout  (dout_8)
);

FIFO_32 FIFO_32_inst_9 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[63:32]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en9),
  .dout  (dout_9)
);

FIFO_32 FIFO_32_inst_10 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[31:0]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en10),
  .dout  (dout_10)
);

FIFO_32 FIFO_32_inst_11 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[351:320]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en11),
  .dout  (dout_11)
);

FIFO_32 FIFO_32_inst_12 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[319:288]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en12),
  .dout  (dout_12)
);

FIFO_32 FIFO_32_inst_13 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[287:256]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en13),
  .dout  (dout_13)
);

FIFO_32 FIFO_32_inst_14 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[255:224]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en14),
  .dout  (dout_14)
);

FIFO_32 FIFO_32_inst_15 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[223:192]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en15),
  .dout  (dout_15)
);

FIFO_32 FIFO_32_inst_16 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[191:160]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en16),
  .dout  (dout_16)
);

FIFO_32 FIFO_32_inst_17 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[159:128]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en17),
  .dout  (dout_17)
);

FIFO_32 FIFO_32_inst_18 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[127:96]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en18),
  .dout  (dout_18)
);

FIFO_32 FIFO_32_inst_19 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[95:64]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en19),
  .dout  (dout_19)
);

FIFO_32 FIFO_32_inst_20 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[63:32]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en20),
  .dout  (dout_20)
);

FIFO_32 FIFO_32_inst_21 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[31:0]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en21),
  .dout  (dout_21)
);

assign process_end_flag = (current_state == STATE_TRANSMIT) && FIR_NORM_end_flag;
assign rd_en = rd_en0 || rd_en1 || rd_en2 || rd_en3 || rd_en4 || 
                   rd_en5 || rd_en6 || rd_en7 || rd_en8 || rd_en9 || 
                   rd_en10 || rd_en11 || rd_en12 || rd_en13 || rd_en14 || 
                   rd_en15 || rd_en16 || rd_en17 || rd_en18 || rd_en19 || 
                   rd_en20 || rd_en21;

DFF_async #(
    .BIT(1)
)
DFF_inst_4(
    .clk(clk),
    .rst_n(rst_n),
    .Q(rd_en),
    .D(data_out_valid)
);
//clear fifo 2
clear_fifo #(
    .CNT(CNT)
)
clear_fifo_inst1(
    .clk(clk),
    .rst_n(rst_n),
    .start_flag(clear_start_flag_1),
    .read_en(clear_read_en_1)
);

localparam MAX_CH_CNT = 22;
reg [4:0] ch_cnt = 0;
reg [9:0] data_cnt;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        TRANSMIT_end_flag <= 0;
        ch_cnt <= 0;
        data_cnt <= 0;
    end
    else begin
        if(current_state == STATE_TRANSMIT) begin
            if((ch_cnt == MAX_CH_CNT - 1) && (data_cnt == CNT - 1)) begin
                TRANSMIT_end_flag <= 1;
                ch_cnt <= 0;
                data_cnt <= 0;
            end                            
            else begin
                TRANSMIT_end_flag <= 0;
                if(data_cnt == CNT - 1) begin
                    data_cnt <= 0;
                    ch_cnt <= ch_cnt + 1;
                end
                else begin
                    data_cnt <= data_cnt + 1;
                    ch_cnt <= ch_cnt;
                end
            end
        end
        else begin
            TRANSMIT_end_flag <= 0;
            ch_cnt <= 0;
            data_cnt <= 0;
        end
    end
end

wire [4:0] ch_cnt_reg;
DFF_async #(
    .BIT(5)
)
DFF_inst_5(
    .clk(clk),
    .rst_n(rst_n),
    .Q(ch_cnt),
    .D(ch_cnt_reg)
);

always @(*) begin
    case(ch_cnt_reg)
        5'd0:  data_out = dout_0;
        5'd1:  data_out = dout_1;
        5'd2:  data_out = dout_2;
        5'd3:  data_out = dout_3;
        5'd4:  data_out = dout_4;
        5'd5:  data_out = dout_5;
        5'd6:  data_out = dout_6;
        5'd7:  data_out = dout_7;
        5'd8:  data_out = dout_8;
        5'd9:  data_out = dout_9;
        5'd10: data_out = dout_10;
        5'd11: data_out = dout_11;
        5'd12: data_out = dout_12;
        5'd13: data_out = dout_13;
        5'd14: data_out = dout_14;
        5'd15: data_out = dout_15;
        5'd16: data_out = dout_16;
        5'd17: data_out = dout_17;
        5'd18: data_out = dout_18;
        5'd19: data_out = dout_19;
        5'd20: data_out = dout_20;
        5'd21: data_out = dout_21;
        default: data_out = 0;  // 或者设为0等其他安全值
    endcase
end

assign rd_en0  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd0);
assign rd_en1  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd1);
assign rd_en2  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd2);
assign rd_en3  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd3);
assign rd_en4  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd4);
assign rd_en5  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd5);
assign rd_en6  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd6);
assign rd_en7  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd7);
assign rd_en8  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd8);
assign rd_en9  = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd9);
assign rd_en10 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd10);
assign rd_en11 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd11);
assign rd_en12 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd12);
assign rd_en13 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd13);
assign rd_en14 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd14);
assign rd_en15 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd15);
assign rd_en16 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd16);
assign rd_en17 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd17);
assign rd_en18 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd18);
assign rd_en19 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd19);
assign rd_en20 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd20);
assign rd_en21 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd21);

wire data_out_last_0;
assign data_out_last_0 = (current_state == STATE_TRANSMIT) && (ch_cnt == 5'd21) && (data_cnt == CNT - 1);

DFF_async #(
    .BIT(5)
)
DFF_inst_6(
    .clk(clk),
    .rst_n(rst_n),
    .Q(data_out_last_0),
    .D(data_out_last)
);



endmodule
