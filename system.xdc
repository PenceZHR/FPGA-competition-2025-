# LCD
#PWM_0

#LCD Red
#LCD Green
#LCD Blue

# GPIO0
#pl led 54-56
set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[0]}]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[1]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[2]}]
#pl key 57-58
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[3]}]
set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[4]}]
#touch key 59
set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[5]}]
#beeper 60
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[6]}]
#lcd rst 61
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[7]}]
#lcd touch rst 62
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[8]}]
#lcd touch int 63
set_property -dict {PACKAGE_PIN U19 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[9]}]
#cam pwdn 64
set_property -dict {PACKAGE_PIN V15 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[10]}]
#cam rst 65
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[11]}]
#pl pyh rst 66
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {gpio0_tri_io[12]}]

# I2C
# eeprom & rtc & audio iic
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports i2c0_scl_io]
set_property -dict {PACKAGE_PIN F17 IOSTANDARD LVCMOS33} [get_ports i2c0_sda_io]
#lcd touch & hdmi iic
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports i2c1_scl_io]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS33} [get_ports i2c1_sda_io]
#cmos iic

# HDMI

# µ¥Ä¿ÉãÏñÍ·
#create_clock -period 7.8125 -name cmos_pclk [get_ports cmos_pclk]



set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {data_in_0[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ch_0[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ch_0[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ch_0[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ch_0[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ch_0[0]}]
set_property PACKAGE_PIN U8 [get_ports {ch_0[4]}]
set_property PACKAGE_PIN V8 [get_ports {ch_0[3]}]
set_property PACKAGE_PIN U7 [get_ports {ch_0[2]}]
set_property PACKAGE_PIN T5 [get_ports {ch_0[1]}]
set_property PACKAGE_PIN T11 [get_ports {ch_0[0]}]
set_property PACKAGE_PIN K14 [get_ports {data_in_0[15]}]
set_property PACKAGE_PIN J14 [get_ports {data_in_0[14]}]
set_property PACKAGE_PIN U20 [get_ports {data_in_0[11]}]
set_property PACKAGE_PIN N18 [get_ports {data_in_0[10]}]
set_property PACKAGE_PIN N17 [get_ports {data_in_0[9]}]
set_property PACKAGE_PIN V20 [get_ports {data_in_0[8]}]
set_property PACKAGE_PIN R17 [get_ports {data_in_0[7]}]
set_property PACKAGE_PIN W19 [get_ports {data_in_0[6]}]
set_property PACKAGE_PIN P16 [get_ports {data_in_0[5]}]
set_property PACKAGE_PIN Y19 [get_ports {data_in_0[4]}]
set_property PACKAGE_PIN R18 [get_ports {data_in_0[3]}]
set_property PACKAGE_PIN V18 [get_ports {data_in_0[2]}]
set_property PACKAGE_PIN U17 [get_ports {data_in_0[1]}]
set_property PACKAGE_PIN Y16 [get_ports {data_in_0[0]}]
set_property PACKAGE_PIN W15 [get_ports start_flag_0]
set_property PACKAGE_PIN M15 [get_ports {data_in_0[13]}]
set_property PACKAGE_PIN L16 [get_ports {data_in_0[12]}]
set_property PACKAGE_PIN W14 [get_ports data_in_valid_0]

set_property IOSTANDARD LVCMOS33 [get_ports data_in_valid_0]
set_property IOSTANDARD LVCMOS33 [get_ports start_flag_0]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
