//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
//Date        : Thu Nov  6 19:58:41 2025
//Host        : DESKTOP-GBKHMIS running 64-bit major release  (build 9200)
//Command     : generate_target phosphor_7020_wrapper.bd
//Design      : phosphor_7020_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module phosphor_7020_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    ch_0,
    data_in_0,
    data_in_valid_0,
    gpio0_tri_io,
    i2c0_scl_io,
    i2c0_sda_io,
    i2c1_scl_io,
    i2c1_sda_io,
    start_flag_0);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input [4:0]ch_0;
  input [15:0]data_in_0;
  input data_in_valid_0;
  inout [12:0]gpio0_tri_io;
  inout i2c0_scl_io;
  inout i2c0_sda_io;
  inout i2c1_scl_io;
  inout i2c1_sda_io;
  input start_flag_0;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire [4:0]ch_0;
  wire [15:0]data_in_0;
  wire data_in_valid_0;
  wire [0:0]gpio0_tri_i_0;
  wire [1:1]gpio0_tri_i_1;
  wire [10:10]gpio0_tri_i_10;
  wire [11:11]gpio0_tri_i_11;
  wire [12:12]gpio0_tri_i_12;
  wire [2:2]gpio0_tri_i_2;
  wire [3:3]gpio0_tri_i_3;
  wire [4:4]gpio0_tri_i_4;
  wire [5:5]gpio0_tri_i_5;
  wire [6:6]gpio0_tri_i_6;
  wire [7:7]gpio0_tri_i_7;
  wire [8:8]gpio0_tri_i_8;
  wire [9:9]gpio0_tri_i_9;
  wire [0:0]gpio0_tri_io_0;
  wire [1:1]gpio0_tri_io_1;
  wire [10:10]gpio0_tri_io_10;
  wire [11:11]gpio0_tri_io_11;
  wire [12:12]gpio0_tri_io_12;
  wire [2:2]gpio0_tri_io_2;
  wire [3:3]gpio0_tri_io_3;
  wire [4:4]gpio0_tri_io_4;
  wire [5:5]gpio0_tri_io_5;
  wire [6:6]gpio0_tri_io_6;
  wire [7:7]gpio0_tri_io_7;
  wire [8:8]gpio0_tri_io_8;
  wire [9:9]gpio0_tri_io_9;
  wire [0:0]gpio0_tri_o_0;
  wire [1:1]gpio0_tri_o_1;
  wire [10:10]gpio0_tri_o_10;
  wire [11:11]gpio0_tri_o_11;
  wire [12:12]gpio0_tri_o_12;
  wire [2:2]gpio0_tri_o_2;
  wire [3:3]gpio0_tri_o_3;
  wire [4:4]gpio0_tri_o_4;
  wire [5:5]gpio0_tri_o_5;
  wire [6:6]gpio0_tri_o_6;
  wire [7:7]gpio0_tri_o_7;
  wire [8:8]gpio0_tri_o_8;
  wire [9:9]gpio0_tri_o_9;
  wire [0:0]gpio0_tri_t_0;
  wire [1:1]gpio0_tri_t_1;
  wire [10:10]gpio0_tri_t_10;
  wire [11:11]gpio0_tri_t_11;
  wire [12:12]gpio0_tri_t_12;
  wire [2:2]gpio0_tri_t_2;
  wire [3:3]gpio0_tri_t_3;
  wire [4:4]gpio0_tri_t_4;
  wire [5:5]gpio0_tri_t_5;
  wire [6:6]gpio0_tri_t_6;
  wire [7:7]gpio0_tri_t_7;
  wire [8:8]gpio0_tri_t_8;
  wire [9:9]gpio0_tri_t_9;
  wire i2c0_scl_i;
  wire i2c0_scl_io;
  wire i2c0_scl_o;
  wire i2c0_scl_t;
  wire i2c0_sda_i;
  wire i2c0_sda_io;
  wire i2c0_sda_o;
  wire i2c0_sda_t;
  wire i2c1_scl_i;
  wire i2c1_scl_io;
  wire i2c1_scl_o;
  wire i2c1_scl_t;
  wire i2c1_sda_i;
  wire i2c1_sda_io;
  wire i2c1_sda_o;
  wire i2c1_sda_t;
  wire start_flag_0;

  IOBUF gpio0_tri_iobuf_0
       (.I(gpio0_tri_o_0),
        .IO(gpio0_tri_io[0]),
        .O(gpio0_tri_i_0),
        .T(gpio0_tri_t_0));
  IOBUF gpio0_tri_iobuf_1
       (.I(gpio0_tri_o_1),
        .IO(gpio0_tri_io[1]),
        .O(gpio0_tri_i_1),
        .T(gpio0_tri_t_1));
  IOBUF gpio0_tri_iobuf_10
       (.I(gpio0_tri_o_10),
        .IO(gpio0_tri_io[10]),
        .O(gpio0_tri_i_10),
        .T(gpio0_tri_t_10));
  IOBUF gpio0_tri_iobuf_11
       (.I(gpio0_tri_o_11),
        .IO(gpio0_tri_io[11]),
        .O(gpio0_tri_i_11),
        .T(gpio0_tri_t_11));
  IOBUF gpio0_tri_iobuf_12
       (.I(gpio0_tri_o_12),
        .IO(gpio0_tri_io[12]),
        .O(gpio0_tri_i_12),
        .T(gpio0_tri_t_12));
  IOBUF gpio0_tri_iobuf_2
       (.I(gpio0_tri_o_2),
        .IO(gpio0_tri_io[2]),
        .O(gpio0_tri_i_2),
        .T(gpio0_tri_t_2));
  IOBUF gpio0_tri_iobuf_3
       (.I(gpio0_tri_o_3),
        .IO(gpio0_tri_io[3]),
        .O(gpio0_tri_i_3),
        .T(gpio0_tri_t_3));
  IOBUF gpio0_tri_iobuf_4
       (.I(gpio0_tri_o_4),
        .IO(gpio0_tri_io[4]),
        .O(gpio0_tri_i_4),
        .T(gpio0_tri_t_4));
  IOBUF gpio0_tri_iobuf_5
       (.I(gpio0_tri_o_5),
        .IO(gpio0_tri_io[5]),
        .O(gpio0_tri_i_5),
        .T(gpio0_tri_t_5));
  IOBUF gpio0_tri_iobuf_6
       (.I(gpio0_tri_o_6),
        .IO(gpio0_tri_io[6]),
        .O(gpio0_tri_i_6),
        .T(gpio0_tri_t_6));
  IOBUF gpio0_tri_iobuf_7
       (.I(gpio0_tri_o_7),
        .IO(gpio0_tri_io[7]),
        .O(gpio0_tri_i_7),
        .T(gpio0_tri_t_7));
  IOBUF gpio0_tri_iobuf_8
       (.I(gpio0_tri_o_8),
        .IO(gpio0_tri_io[8]),
        .O(gpio0_tri_i_8),
        .T(gpio0_tri_t_8));
  IOBUF gpio0_tri_iobuf_9
       (.I(gpio0_tri_o_9),
        .IO(gpio0_tri_io[9]),
        .O(gpio0_tri_i_9),
        .T(gpio0_tri_t_9));
  IOBUF i2c0_scl_iobuf
       (.I(i2c0_scl_o),
        .IO(i2c0_scl_io),
        .O(i2c0_scl_i),
        .T(i2c0_scl_t));
  IOBUF i2c0_sda_iobuf
       (.I(i2c0_sda_o),
        .IO(i2c0_sda_io),
        .O(i2c0_sda_i),
        .T(i2c0_sda_t));
  IOBUF i2c1_scl_iobuf
       (.I(i2c1_scl_o),
        .IO(i2c1_scl_io),
        .O(i2c1_scl_i),
        .T(i2c1_scl_t));
  IOBUF i2c1_sda_iobuf
       (.I(i2c1_sda_o),
        .IO(i2c1_sda_io),
        .O(i2c1_sda_i),
        .T(i2c1_sda_t));
  phosphor_7020 phosphor_7020_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .ch_0(ch_0),
        .data_in_0(data_in_0),
        .data_in_valid_0(data_in_valid_0),
        .gpio0_tri_i({gpio0_tri_i_12,gpio0_tri_i_11,gpio0_tri_i_10,gpio0_tri_i_9,gpio0_tri_i_8,gpio0_tri_i_7,gpio0_tri_i_6,gpio0_tri_i_5,gpio0_tri_i_4,gpio0_tri_i_3,gpio0_tri_i_2,gpio0_tri_i_1,gpio0_tri_i_0}),
        .gpio0_tri_o({gpio0_tri_o_12,gpio0_tri_o_11,gpio0_tri_o_10,gpio0_tri_o_9,gpio0_tri_o_8,gpio0_tri_o_7,gpio0_tri_o_6,gpio0_tri_o_5,gpio0_tri_o_4,gpio0_tri_o_3,gpio0_tri_o_2,gpio0_tri_o_1,gpio0_tri_o_0}),
        .gpio0_tri_t({gpio0_tri_t_12,gpio0_tri_t_11,gpio0_tri_t_10,gpio0_tri_t_9,gpio0_tri_t_8,gpio0_tri_t_7,gpio0_tri_t_6,gpio0_tri_t_5,gpio0_tri_t_4,gpio0_tri_t_3,gpio0_tri_t_2,gpio0_tri_t_1,gpio0_tri_t_0}),
        .i2c0_scl_i(i2c0_scl_i),
        .i2c0_scl_o(i2c0_scl_o),
        .i2c0_scl_t(i2c0_scl_t),
        .i2c0_sda_i(i2c0_sda_i),
        .i2c0_sda_o(i2c0_sda_o),
        .i2c0_sda_t(i2c0_sda_t),
        .i2c1_scl_i(i2c1_scl_i),
        .i2c1_scl_o(i2c1_scl_o),
        .i2c1_scl_t(i2c1_scl_t),
        .i2c1_sda_i(i2c1_sda_i),
        .i2c1_sda_o(i2c1_sda_o),
        .i2c1_sda_t(i2c1_sda_t),
        .start_flag_0(start_flag_0));
endmodule
