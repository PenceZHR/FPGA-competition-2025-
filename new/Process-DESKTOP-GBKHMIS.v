`timescale 1ns / 1ps
module Process #(
    parameter CNT = 256
)
(
    input clk,
    input rst_n,
    input data_in_valid,
    input [351:0] data_in,
    input start_flag,
    output [703:0] data_out,
    output data_out_valid,
//    input [4:0] rd_ch,
    input rd_en
    );

ila_process ila_process_inst_0 (
	.clk(clk), // input wire clk
	.probe0(data_in_valid), // input wire [0:0]  probe0  
	.probe1(start_flag), // input wire [0:0]  probe1 
	.probe2(data_in), // input wire [0:0]  probe2 
	.probe3(data_out_valid), // input wire [0:0]  probe3 
	.probe4(data_out) // input wire [0:0]  probe4
);



assign fir_data_in_valid = data_in_valid;

localparam STATE_IDLE = 4'b0000;
localparam STATE_GET_DATA = 4'b0001;
localparam STATE_NORM0_TO_FIFO = 4'b0010;
localparam STATE_NORM1_TO_FIFO = 4'b0100;

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
// state transfer
always @(*) begin
    case(current_state)
        STATE_IDLE : next_state = process_start_en ? STATE_GET_DATA : STATE_IDLE ;
        STATE_GET_DATA : next_state = store_end_flag ? STATE_NORM0_TO_FIFO : STATE_GET_DATA;
        STATE_NORM0_TO_FIFO : next_state = FIR_NORM0_end_flag ?  STATE_NORM1_TO_FIFO: STATE_NORM0_TO_FIFO;
        STATE_NORM1_TO_FIFO : next_state = FIR_NORM1_end_flag ? STATE_IDLE : STATE_NORM1_TO_FIFO;
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
        if(data_in_cnt == 255) begin
            data_in_cnt <= 0;
        end
        else if (data_in_valid_reg) begin
            data_in_cnt <= data_in_cnt + 1;
        end
    end
end

assign store_end_flag = (current_state == STATE_GET_DATA) && (data_in_cnt == 255);
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
    .N(8)
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

// FIR_NORM_data_out[351:0] -> 11x32b FIFOs (inst_0 .. inst_10)
FIFO_32 FIFO_32_inst_0 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[351:320]),  // 32b
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_0)
);

FIFO_32 FIFO_32_inst_1 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[319:288]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_1)
);

FIFO_32 FIFO_32_inst_2 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[287:256]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_2)
);

FIFO_32 FIFO_32_inst_3 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[255:224]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_3)
);

FIFO_32 FIFO_32_inst_4 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[223:192]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_4)
);

FIFO_32 FIFO_32_inst_5 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[191:160]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_5)
);

FIFO_32 FIFO_32_inst_6 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[159:128]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_6)
);

FIFO_32 FIFO_32_inst_7 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[127:96]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_7)
);

FIFO_32 FIFO_32_inst_8 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[95:64]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_8)
);

FIFO_32 FIFO_32_inst_9 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[63:32]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_9)
);

FIFO_32 FIFO_32_inst_10 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[31:0]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM0_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_10)
);

FIFO_32 FIFO_32_inst_11 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[351:320]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_11)
);

FIFO_32 FIFO_32_inst_12 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[319:288]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_12)
);

FIFO_32 FIFO_32_inst_13 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[287:256]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_13)
);

FIFO_32 FIFO_32_inst_14 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[255:224]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_14)
);

FIFO_32 FIFO_32_inst_15 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[223:192]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_15)
);

FIFO_32 FIFO_32_inst_16 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[191:160]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_16)
);

FIFO_32 FIFO_32_inst_17 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[159:128]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_17)
);

FIFO_32 FIFO_32_inst_18 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[127:96]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_18)
);

FIFO_32 FIFO_32_inst_19 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[95:64]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_19)
);

FIFO_32 FIFO_32_inst_20 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[63:32]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_20)
);

FIFO_32 FIFO_32_inst_21 (
  .clk   (clk),
  .srst  (~rst_n),
  .din   (FIR_NORM_data_out[31:0]),
  .wr_en (FIR_NORM_data_out_valid && (current_state == STATE_NORM1_TO_FIFO)),
  .rd_en (rd_en),
  .dout  (dout_21)
);

assign process_end_flag = (current_state == STATE_NORM1_TO_FIFO) && FIR_NORM_end_flag;
assign data_out = {dout_0, dout_1, dout_2, dout_3, dout_4, dout_5, dout_6, dout_7, dout_8, dout_9, dout_10, dout_11, dout_12, dout_13, dout_14, dout_15, dout_16, dout_17, dout_18, dout_19, dout_20, dout_21};
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
always @(*) begin
    

end

endmodule
