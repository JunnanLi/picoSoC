########################################################
#port 0
set_property PACKAGE_PIN N17 [get_ports {rgmii_td[0]}]
set_property PACKAGE_PIN N18 [get_ports {rgmii_td[1]}]
set_property PACKAGE_PIN N19 [get_ports {rgmii_td[2]}]
set_property PACKAGE_PIN N20 [get_ports {rgmii_td[3]}]
set_property PACKAGE_PIN J17 [get_ports mdio_mdc]
set_property PACKAGE_PIN J16 [get_ports mdio_mdio_io]
set_property PACKAGE_PIN L19 [get_ports phy_reset_n]
set_property PACKAGE_PIN K19 [get_ports rgmii_rxc]
set_property PACKAGE_PIN K20 [get_ports rgmii_rx_ctl]
set_property PACKAGE_PIN J18 [get_ports {rgmii_rd[0]}]
set_property PACKAGE_PIN K18 [get_ports {rgmii_rd[1]}]
set_property PACKAGE_PIN J15 [get_ports {rgmii_rd[2]}]
set_property PACKAGE_PIN K15 [get_ports {rgmii_rd[3]}]
set_property PACKAGE_PIN R21 [get_ports rgmii_txc]
set_property PACKAGE_PIN R20 [get_ports rgmii_tx_ctl]

set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_mdio_io]
set_property IOSTANDARD LVCMOS33 [get_ports phy_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rxc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_rd[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_txc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_tx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {rgmii_td[3]}]


set_property SLEW FAST [get_ports rgmii_tx_ctl]
set_property SLEW FAST [get_ports rgmii_txc]
set_property SLEW FAST [get_ports {rgmii_td[3]}]
set_property SLEW FAST [get_ports {rgmii_td[2]}]
set_property SLEW FAST [get_ports {rgmii_td[1]}]
set_property SLEW FAST [get_ports {rgmii_td[0]}]
set_property SLEW SLOW [get_ports phy_reset_n]


set_property PACKAGE_PIN A17 [get_ports rst_n]
set_property PACKAGE_PIN Y9 [get_ports sys_clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]
set_property UNAVAILABLE_DURING_CALIBRATION true [get_ports mdio_mdio_io]

create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports sys_clk]
create_clock -period 8.000 -name RGMII_RXC_0 -waveform {0.000 4.000} [get_ports rgmii_rxc]
create_clock -period 8.000 -name RGMII_TXC_0 -waveform {0.000 4.000} [get_ports rgmii_txc]

set_input_delay -clock RGMII_RXC_0 -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -clock_fall -min -add_delay -1.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]
set_input_delay -clock RGMII_RXC_0 -clock_fall -max -add_delay -0.700 [get_ports {{rgmii_rd[0]} {rgmii_rd[1]} {rgmii_rd[2]} {rgmii_rd[3]} rgmii_rx_ctl}]

set_output_delay -clock RGMII_TXC_0 -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -clock_fall -min -add_delay -0.500 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]
set_output_delay -clock RGMII_TXC_0 -clock_fall -max -add_delay 1.000 [get_ports {{rgmii_td[0]} {rgmii_td[1]} {rgmii_td[2]} {rgmii_td[3]} rgmii_tx_ctl}]










create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_to_125m/inst/clk_out1]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {pkt2gmii/head_tag[0]} {pkt2gmii/head_tag[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 134 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {pkt2gmii/dout_pkt[0]} {pkt2gmii/dout_pkt[1]} {pkt2gmii/dout_pkt[2]} {pkt2gmii/dout_pkt[3]} {pkt2gmii/dout_pkt[4]} {pkt2gmii/dout_pkt[5]} {pkt2gmii/dout_pkt[6]} {pkt2gmii/dout_pkt[7]} {pkt2gmii/dout_pkt[8]} {pkt2gmii/dout_pkt[9]} {pkt2gmii/dout_pkt[10]} {pkt2gmii/dout_pkt[11]} {pkt2gmii/dout_pkt[12]} {pkt2gmii/dout_pkt[13]} {pkt2gmii/dout_pkt[14]} {pkt2gmii/dout_pkt[15]} {pkt2gmii/dout_pkt[16]} {pkt2gmii/dout_pkt[17]} {pkt2gmii/dout_pkt[18]} {pkt2gmii/dout_pkt[19]} {pkt2gmii/dout_pkt[20]} {pkt2gmii/dout_pkt[21]} {pkt2gmii/dout_pkt[22]} {pkt2gmii/dout_pkt[23]} {pkt2gmii/dout_pkt[24]} {pkt2gmii/dout_pkt[25]} {pkt2gmii/dout_pkt[26]} {pkt2gmii/dout_pkt[27]} {pkt2gmii/dout_pkt[28]} {pkt2gmii/dout_pkt[29]} {pkt2gmii/dout_pkt[30]} {pkt2gmii/dout_pkt[31]} {pkt2gmii/dout_pkt[32]} {pkt2gmii/dout_pkt[33]} {pkt2gmii/dout_pkt[34]} {pkt2gmii/dout_pkt[35]} {pkt2gmii/dout_pkt[36]} {pkt2gmii/dout_pkt[37]} {pkt2gmii/dout_pkt[38]} {pkt2gmii/dout_pkt[39]} {pkt2gmii/dout_pkt[40]} {pkt2gmii/dout_pkt[41]} {pkt2gmii/dout_pkt[42]} {pkt2gmii/dout_pkt[43]} {pkt2gmii/dout_pkt[44]} {pkt2gmii/dout_pkt[45]} {pkt2gmii/dout_pkt[46]} {pkt2gmii/dout_pkt[47]} {pkt2gmii/dout_pkt[48]} {pkt2gmii/dout_pkt[49]} {pkt2gmii/dout_pkt[50]} {pkt2gmii/dout_pkt[51]} {pkt2gmii/dout_pkt[52]} {pkt2gmii/dout_pkt[53]} {pkt2gmii/dout_pkt[54]} {pkt2gmii/dout_pkt[55]} {pkt2gmii/dout_pkt[56]} {pkt2gmii/dout_pkt[57]} {pkt2gmii/dout_pkt[58]} {pkt2gmii/dout_pkt[59]} {pkt2gmii/dout_pkt[60]} {pkt2gmii/dout_pkt[61]} {pkt2gmii/dout_pkt[62]} {pkt2gmii/dout_pkt[63]} {pkt2gmii/dout_pkt[64]} {pkt2gmii/dout_pkt[65]} {pkt2gmii/dout_pkt[66]} {pkt2gmii/dout_pkt[67]} {pkt2gmii/dout_pkt[68]} {pkt2gmii/dout_pkt[69]} {pkt2gmii/dout_pkt[70]} {pkt2gmii/dout_pkt[71]} {pkt2gmii/dout_pkt[72]} {pkt2gmii/dout_pkt[73]} {pkt2gmii/dout_pkt[74]} {pkt2gmii/dout_pkt[75]} {pkt2gmii/dout_pkt[76]} {pkt2gmii/dout_pkt[77]} {pkt2gmii/dout_pkt[78]} {pkt2gmii/dout_pkt[79]} {pkt2gmii/dout_pkt[80]} {pkt2gmii/dout_pkt[81]} {pkt2gmii/dout_pkt[82]} {pkt2gmii/dout_pkt[83]} {pkt2gmii/dout_pkt[84]} {pkt2gmii/dout_pkt[85]} {pkt2gmii/dout_pkt[86]} {pkt2gmii/dout_pkt[87]} {pkt2gmii/dout_pkt[88]} {pkt2gmii/dout_pkt[89]} {pkt2gmii/dout_pkt[90]} {pkt2gmii/dout_pkt[91]} {pkt2gmii/dout_pkt[92]} {pkt2gmii/dout_pkt[93]} {pkt2gmii/dout_pkt[94]} {pkt2gmii/dout_pkt[95]} {pkt2gmii/dout_pkt[96]} {pkt2gmii/dout_pkt[97]} {pkt2gmii/dout_pkt[98]} {pkt2gmii/dout_pkt[99]} {pkt2gmii/dout_pkt[100]} {pkt2gmii/dout_pkt[101]} {pkt2gmii/dout_pkt[102]} {pkt2gmii/dout_pkt[103]} {pkt2gmii/dout_pkt[104]} {pkt2gmii/dout_pkt[105]} {pkt2gmii/dout_pkt[106]} {pkt2gmii/dout_pkt[107]} {pkt2gmii/dout_pkt[108]} {pkt2gmii/dout_pkt[109]} {pkt2gmii/dout_pkt[110]} {pkt2gmii/dout_pkt[111]} {pkt2gmii/dout_pkt[112]} {pkt2gmii/dout_pkt[113]} {pkt2gmii/dout_pkt[114]} {pkt2gmii/dout_pkt[115]} {pkt2gmii/dout_pkt[116]} {pkt2gmii/dout_pkt[117]} {pkt2gmii/dout_pkt[118]} {pkt2gmii/dout_pkt[119]} {pkt2gmii/dout_pkt[120]} {pkt2gmii/dout_pkt[121]} {pkt2gmii/dout_pkt[122]} {pkt2gmii/dout_pkt[123]} {pkt2gmii/dout_pkt[124]} {pkt2gmii/dout_pkt[125]} {pkt2gmii/dout_pkt[126]} {pkt2gmii/dout_pkt[127]} {pkt2gmii/dout_pkt[128]} {pkt2gmii/dout_pkt[129]} {pkt2gmii/dout_pkt[130]} {pkt2gmii/dout_pkt[131]} {pkt2gmii/dout_pkt[132]} {pkt2gmii/dout_pkt[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 4 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {pkt2gmii/state_div[0]} {pkt2gmii/state_div[1]} {pkt2gmii/state_div[2]} {pkt2gmii/state_div[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {UMforCPU/tm/picorv32/cpu_state[0]} {UMforCPU/tm/picorv32/cpu_state[1]} {UMforCPU/tm/picorv32/cpu_state[2]} {UMforCPU/tm/picorv32/cpu_state[3]} {UMforCPU/tm/picorv32/cpu_state[4]} {UMforCPU/tm/picorv32/cpu_state[5]} {UMforCPU/tm/picorv32/cpu_state[6]} {UMforCPU/tm/picorv32/cpu_state[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 32 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {UMforCPU/tm/mem_rdata[0]} {UMforCPU/tm/mem_rdata[1]} {UMforCPU/tm/mem_rdata[2]} {UMforCPU/tm/mem_rdata[3]} {UMforCPU/tm/mem_rdata[4]} {UMforCPU/tm/mem_rdata[5]} {UMforCPU/tm/mem_rdata[6]} {UMforCPU/tm/mem_rdata[7]} {UMforCPU/tm/mem_rdata[8]} {UMforCPU/tm/mem_rdata[9]} {UMforCPU/tm/mem_rdata[10]} {UMforCPU/tm/mem_rdata[11]} {UMforCPU/tm/mem_rdata[12]} {UMforCPU/tm/mem_rdata[13]} {UMforCPU/tm/mem_rdata[14]} {UMforCPU/tm/mem_rdata[15]} {UMforCPU/tm/mem_rdata[16]} {UMforCPU/tm/mem_rdata[17]} {UMforCPU/tm/mem_rdata[18]} {UMforCPU/tm/mem_rdata[19]} {UMforCPU/tm/mem_rdata[20]} {UMforCPU/tm/mem_rdata[21]} {UMforCPU/tm/mem_rdata[22]} {UMforCPU/tm/mem_rdata[23]} {UMforCPU/tm/mem_rdata[24]} {UMforCPU/tm/mem_rdata[25]} {UMforCPU/tm/mem_rdata[26]} {UMforCPU/tm/mem_rdata[27]} {UMforCPU/tm/mem_rdata[28]} {UMforCPU/tm/mem_rdata[29]} {UMforCPU/tm/mem_rdata[30]} {UMforCPU/tm/mem_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {UMforCPU/tm/mem_wdata[0]} {UMforCPU/tm/mem_wdata[1]} {UMforCPU/tm/mem_wdata[2]} {UMforCPU/tm/mem_wdata[3]} {UMforCPU/tm/mem_wdata[4]} {UMforCPU/tm/mem_wdata[5]} {UMforCPU/tm/mem_wdata[6]} {UMforCPU/tm/mem_wdata[7]} {UMforCPU/tm/mem_wdata[8]} {UMforCPU/tm/mem_wdata[9]} {UMforCPU/tm/mem_wdata[10]} {UMforCPU/tm/mem_wdata[11]} {UMforCPU/tm/mem_wdata[12]} {UMforCPU/tm/mem_wdata[13]} {UMforCPU/tm/mem_wdata[14]} {UMforCPU/tm/mem_wdata[15]} {UMforCPU/tm/mem_wdata[16]} {UMforCPU/tm/mem_wdata[17]} {UMforCPU/tm/mem_wdata[18]} {UMforCPU/tm/mem_wdata[19]} {UMforCPU/tm/mem_wdata[20]} {UMforCPU/tm/mem_wdata[21]} {UMforCPU/tm/mem_wdata[22]} {UMforCPU/tm/mem_wdata[23]} {UMforCPU/tm/mem_wdata[24]} {UMforCPU/tm/mem_wdata[25]} {UMforCPU/tm/mem_wdata[26]} {UMforCPU/tm/mem_wdata[27]} {UMforCPU/tm/mem_wdata[28]} {UMforCPU/tm/mem_wdata[29]} {UMforCPU/tm/mem_wdata[30]} {UMforCPU/tm/mem_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 4 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {UMforCPU/tm/mem_wstrb[0]} {UMforCPU/tm/mem_wstrb[1]} {UMforCPU/tm/mem_wstrb[2]} {UMforCPU/tm/mem_wstrb[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {UMforCPU/tm/mem_addr[0]} {UMforCPU/tm/mem_addr[1]} {UMforCPU/tm/mem_addr[2]} {UMforCPU/tm/mem_addr[3]} {UMforCPU/tm/mem_addr[4]} {UMforCPU/tm/mem_addr[5]} {UMforCPU/tm/mem_addr[6]} {UMforCPU/tm/mem_addr[7]} {UMforCPU/tm/mem_addr[8]} {UMforCPU/tm/mem_addr[9]} {UMforCPU/tm/mem_addr[10]} {UMforCPU/tm/mem_addr[11]} {UMforCPU/tm/mem_addr[12]} {UMforCPU/tm/mem_addr[13]} {UMforCPU/tm/mem_addr[14]} {UMforCPU/tm/mem_addr[15]} {UMforCPU/tm/mem_addr[16]} {UMforCPU/tm/mem_addr[17]} {UMforCPU/tm/mem_addr[18]} {UMforCPU/tm/mem_addr[19]} {UMforCPU/tm/mem_addr[20]} {UMforCPU/tm/mem_addr[21]} {UMforCPU/tm/mem_addr[22]} {UMforCPU/tm/mem_addr[23]} {UMforCPU/tm/mem_addr[24]} {UMforCPU/tm/mem_addr[25]} {UMforCPU/tm/mem_addr[26]} {UMforCPU/tm/mem_addr[27]} {UMforCPU/tm/mem_addr[28]} {UMforCPU/tm/mem_addr[29]} {UMforCPU/tm/mem_addr[30]} {UMforCPU/tm/mem_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 32 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {cntPkt_gmii2pkt[0]} {cntPkt_gmii2pkt[1]} {cntPkt_gmii2pkt[2]} {cntPkt_gmii2pkt[3]} {cntPkt_gmii2pkt[4]} {cntPkt_gmii2pkt[5]} {cntPkt_gmii2pkt[6]} {cntPkt_gmii2pkt[7]} {cntPkt_gmii2pkt[8]} {cntPkt_gmii2pkt[9]} {cntPkt_gmii2pkt[10]} {cntPkt_gmii2pkt[11]} {cntPkt_gmii2pkt[12]} {cntPkt_gmii2pkt[13]} {cntPkt_gmii2pkt[14]} {cntPkt_gmii2pkt[15]} {cntPkt_gmii2pkt[16]} {cntPkt_gmii2pkt[17]} {cntPkt_gmii2pkt[18]} {cntPkt_gmii2pkt[19]} {cntPkt_gmii2pkt[20]} {cntPkt_gmii2pkt[21]} {cntPkt_gmii2pkt[22]} {cntPkt_gmii2pkt[23]} {cntPkt_gmii2pkt[24]} {cntPkt_gmii2pkt[25]} {cntPkt_gmii2pkt[26]} {cntPkt_gmii2pkt[27]} {cntPkt_gmii2pkt[28]} {cntPkt_gmii2pkt[29]} {cntPkt_gmii2pkt[30]} {cntPkt_gmii2pkt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 8 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {gmiiTxd_calCRC[0]} {gmiiTxd_calCRC[1]} {gmiiTxd_calCRC[2]} {gmiiTxd_calCRC[3]} {gmiiTxd_calCRC[4]} {gmiiTxd_calCRC[5]} {gmiiTxd_calCRC[6]} {gmiiTxd_calCRC[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 32 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {cnt_calcCRC[0]} {cnt_calcCRC[1]} {cnt_calcCRC[2]} {cnt_calcCRC[3]} {cnt_calcCRC[4]} {cnt_calcCRC[5]} {cnt_calcCRC[6]} {cnt_calcCRC[7]} {cnt_calcCRC[8]} {cnt_calcCRC[9]} {cnt_calcCRC[10]} {cnt_calcCRC[11]} {cnt_calcCRC[12]} {cnt_calcCRC[13]} {cnt_calcCRC[14]} {cnt_calcCRC[15]} {cnt_calcCRC[16]} {cnt_calcCRC[17]} {cnt_calcCRC[18]} {cnt_calcCRC[19]} {cnt_calcCRC[20]} {cnt_calcCRC[21]} {cnt_calcCRC[22]} {cnt_calcCRC[23]} {cnt_calcCRC[24]} {cnt_calcCRC[25]} {cnt_calcCRC[26]} {cnt_calcCRC[27]} {cnt_calcCRC[28]} {cnt_calcCRC[29]} {cnt_calcCRC[30]} {cnt_calcCRC[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 32 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {UMforCPU/conf_wdata[0]} {UMforCPU/conf_wdata[1]} {UMforCPU/conf_wdata[2]} {UMforCPU/conf_wdata[3]} {UMforCPU/conf_wdata[4]} {UMforCPU/conf_wdata[5]} {UMforCPU/conf_wdata[6]} {UMforCPU/conf_wdata[7]} {UMforCPU/conf_wdata[8]} {UMforCPU/conf_wdata[9]} {UMforCPU/conf_wdata[10]} {UMforCPU/conf_wdata[11]} {UMforCPU/conf_wdata[12]} {UMforCPU/conf_wdata[13]} {UMforCPU/conf_wdata[14]} {UMforCPU/conf_wdata[15]} {UMforCPU/conf_wdata[16]} {UMforCPU/conf_wdata[17]} {UMforCPU/conf_wdata[18]} {UMforCPU/conf_wdata[19]} {UMforCPU/conf_wdata[20]} {UMforCPU/conf_wdata[21]} {UMforCPU/conf_wdata[22]} {UMforCPU/conf_wdata[23]} {UMforCPU/conf_wdata[24]} {UMforCPU/conf_wdata[25]} {UMforCPU/conf_wdata[26]} {UMforCPU/conf_wdata[27]} {UMforCPU/conf_wdata[28]} {UMforCPU/conf_wdata[29]} {UMforCPU/conf_wdata[30]} {UMforCPU/conf_wdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {UMforCPU/print_value[0]} {UMforCPU/print_value[1]} {UMforCPU/print_value[2]} {UMforCPU/print_value[3]} {UMforCPU/print_value[4]} {UMforCPU/print_value[5]} {UMforCPU/print_value[6]} {UMforCPU/print_value[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 32 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {cntPkt_asynRecvPkt[0]} {cntPkt_asynRecvPkt[1]} {cntPkt_asynRecvPkt[2]} {cntPkt_asynRecvPkt[3]} {cntPkt_asynRecvPkt[4]} {cntPkt_asynRecvPkt[5]} {cntPkt_asynRecvPkt[6]} {cntPkt_asynRecvPkt[7]} {cntPkt_asynRecvPkt[8]} {cntPkt_asynRecvPkt[9]} {cntPkt_asynRecvPkt[10]} {cntPkt_asynRecvPkt[11]} {cntPkt_asynRecvPkt[12]} {cntPkt_asynRecvPkt[13]} {cntPkt_asynRecvPkt[14]} {cntPkt_asynRecvPkt[15]} {cntPkt_asynRecvPkt[16]} {cntPkt_asynRecvPkt[17]} {cntPkt_asynRecvPkt[18]} {cntPkt_asynRecvPkt[19]} {cntPkt_asynRecvPkt[20]} {cntPkt_asynRecvPkt[21]} {cntPkt_asynRecvPkt[22]} {cntPkt_asynRecvPkt[23]} {cntPkt_asynRecvPkt[24]} {cntPkt_asynRecvPkt[25]} {cntPkt_asynRecvPkt[26]} {cntPkt_asynRecvPkt[27]} {cntPkt_asynRecvPkt[28]} {cntPkt_asynRecvPkt[29]} {cntPkt_asynRecvPkt[30]} {cntPkt_asynRecvPkt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 8 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {gmiiRxd_asfifo[0]} {gmiiRxd_asfifo[1]} {gmiiRxd_asfifo[2]} {gmiiRxd_asfifo[3]} {gmiiRxd_asfifo[4]} {gmiiRxd_asfifo[5]} {gmiiRxd_asfifo[6]} {gmiiRxd_asfifo[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 32 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {cntPkt_pkt2gmii[0]} {cntPkt_pkt2gmii[1]} {cntPkt_pkt2gmii[2]} {cntPkt_pkt2gmii[3]} {cntPkt_pkt2gmii[4]} {cntPkt_pkt2gmii[5]} {cntPkt_pkt2gmii[6]} {cntPkt_pkt2gmii[7]} {cntPkt_pkt2gmii[8]} {cntPkt_pkt2gmii[9]} {cntPkt_pkt2gmii[10]} {cntPkt_pkt2gmii[11]} {cntPkt_pkt2gmii[12]} {cntPkt_pkt2gmii[13]} {cntPkt_pkt2gmii[14]} {cntPkt_pkt2gmii[15]} {cntPkt_pkt2gmii[16]} {cntPkt_pkt2gmii[17]} {cntPkt_pkt2gmii[18]} {cntPkt_pkt2gmii[19]} {cntPkt_pkt2gmii[20]} {cntPkt_pkt2gmii[21]} {cntPkt_pkt2gmii[22]} {cntPkt_pkt2gmii[23]} {cntPkt_pkt2gmii[24]} {cntPkt_pkt2gmii[25]} {cntPkt_pkt2gmii[26]} {cntPkt_pkt2gmii[27]} {cntPkt_pkt2gmii[28]} {cntPkt_pkt2gmii[29]} {cntPkt_pkt2gmii[30]} {cntPkt_pkt2gmii[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {gmiiTxd_modifyPKT[0]} {gmiiTxd_modifyPKT[1]} {gmiiTxd_modifyPKT[2]} {gmiiTxd_modifyPKT[3]} {gmiiTxd_modifyPKT[4]} {gmiiTxd_modifyPKT[5]} {gmiiTxd_modifyPKT[6]} {gmiiTxd_modifyPKT[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 134 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {pktData_gmii[0]} {pktData_gmii[1]} {pktData_gmii[2]} {pktData_gmii[3]} {pktData_gmii[4]} {pktData_gmii[5]} {pktData_gmii[6]} {pktData_gmii[7]} {pktData_gmii[8]} {pktData_gmii[9]} {pktData_gmii[10]} {pktData_gmii[11]} {pktData_gmii[12]} {pktData_gmii[13]} {pktData_gmii[14]} {pktData_gmii[15]} {pktData_gmii[16]} {pktData_gmii[17]} {pktData_gmii[18]} {pktData_gmii[19]} {pktData_gmii[20]} {pktData_gmii[21]} {pktData_gmii[22]} {pktData_gmii[23]} {pktData_gmii[24]} {pktData_gmii[25]} {pktData_gmii[26]} {pktData_gmii[27]} {pktData_gmii[28]} {pktData_gmii[29]} {pktData_gmii[30]} {pktData_gmii[31]} {pktData_gmii[32]} {pktData_gmii[33]} {pktData_gmii[34]} {pktData_gmii[35]} {pktData_gmii[36]} {pktData_gmii[37]} {pktData_gmii[38]} {pktData_gmii[39]} {pktData_gmii[40]} {pktData_gmii[41]} {pktData_gmii[42]} {pktData_gmii[43]} {pktData_gmii[44]} {pktData_gmii[45]} {pktData_gmii[46]} {pktData_gmii[47]} {pktData_gmii[48]} {pktData_gmii[49]} {pktData_gmii[50]} {pktData_gmii[51]} {pktData_gmii[52]} {pktData_gmii[53]} {pktData_gmii[54]} {pktData_gmii[55]} {pktData_gmii[56]} {pktData_gmii[57]} {pktData_gmii[58]} {pktData_gmii[59]} {pktData_gmii[60]} {pktData_gmii[61]} {pktData_gmii[62]} {pktData_gmii[63]} {pktData_gmii[64]} {pktData_gmii[65]} {pktData_gmii[66]} {pktData_gmii[67]} {pktData_gmii[68]} {pktData_gmii[69]} {pktData_gmii[70]} {pktData_gmii[71]} {pktData_gmii[72]} {pktData_gmii[73]} {pktData_gmii[74]} {pktData_gmii[75]} {pktData_gmii[76]} {pktData_gmii[77]} {pktData_gmii[78]} {pktData_gmii[79]} {pktData_gmii[80]} {pktData_gmii[81]} {pktData_gmii[82]} {pktData_gmii[83]} {pktData_gmii[84]} {pktData_gmii[85]} {pktData_gmii[86]} {pktData_gmii[87]} {pktData_gmii[88]} {pktData_gmii[89]} {pktData_gmii[90]} {pktData_gmii[91]} {pktData_gmii[92]} {pktData_gmii[93]} {pktData_gmii[94]} {pktData_gmii[95]} {pktData_gmii[96]} {pktData_gmii[97]} {pktData_gmii[98]} {pktData_gmii[99]} {pktData_gmii[100]} {pktData_gmii[101]} {pktData_gmii[102]} {pktData_gmii[103]} {pktData_gmii[104]} {pktData_gmii[105]} {pktData_gmii[106]} {pktData_gmii[107]} {pktData_gmii[108]} {pktData_gmii[109]} {pktData_gmii[110]} {pktData_gmii[111]} {pktData_gmii[112]} {pktData_gmii[113]} {pktData_gmii[114]} {pktData_gmii[115]} {pktData_gmii[116]} {pktData_gmii[117]} {pktData_gmii[118]} {pktData_gmii[119]} {pktData_gmii[120]} {pktData_gmii[121]} {pktData_gmii[122]} {pktData_gmii[123]} {pktData_gmii[124]} {pktData_gmii[125]} {pktData_gmii[126]} {pktData_gmii[127]} {pktData_gmii[128]} {pktData_gmii[129]} {pktData_gmii[130]} {pktData_gmii[131]} {pktData_gmii[132]} {pktData_gmii[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 32 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {UMforCPU/conf_rdata[0]} {UMforCPU/conf_rdata[1]} {UMforCPU/conf_rdata[2]} {UMforCPU/conf_rdata[3]} {UMforCPU/conf_rdata[4]} {UMforCPU/conf_rdata[5]} {UMforCPU/conf_rdata[6]} {UMforCPU/conf_rdata[7]} {UMforCPU/conf_rdata[8]} {UMforCPU/conf_rdata[9]} {UMforCPU/conf_rdata[10]} {UMforCPU/conf_rdata[11]} {UMforCPU/conf_rdata[12]} {UMforCPU/conf_rdata[13]} {UMforCPU/conf_rdata[14]} {UMforCPU/conf_rdata[15]} {UMforCPU/conf_rdata[16]} {UMforCPU/conf_rdata[17]} {UMforCPU/conf_rdata[18]} {UMforCPU/conf_rdata[19]} {UMforCPU/conf_rdata[20]} {UMforCPU/conf_rdata[21]} {UMforCPU/conf_rdata[22]} {UMforCPU/conf_rdata[23]} {UMforCPU/conf_rdata[24]} {UMforCPU/conf_rdata[25]} {UMforCPU/conf_rdata[26]} {UMforCPU/conf_rdata[27]} {UMforCPU/conf_rdata[28]} {UMforCPU/conf_rdata[29]} {UMforCPU/conf_rdata[30]} {UMforCPU/conf_rdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 32 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list {UMforCPU/conf_addr[0]} {UMforCPU/conf_addr[1]} {UMforCPU/conf_addr[2]} {UMforCPU/conf_addr[3]} {UMforCPU/conf_addr[4]} {UMforCPU/conf_addr[5]} {UMforCPU/conf_addr[6]} {UMforCPU/conf_addr[7]} {UMforCPU/conf_addr[8]} {UMforCPU/conf_addr[9]} {UMforCPU/conf_addr[10]} {UMforCPU/conf_addr[11]} {UMforCPU/conf_addr[12]} {UMforCPU/conf_addr[13]} {UMforCPU/conf_addr[14]} {UMforCPU/conf_addr[15]} {UMforCPU/conf_addr[16]} {UMforCPU/conf_addr[17]} {UMforCPU/conf_addr[18]} {UMforCPU/conf_addr[19]} {UMforCPU/conf_addr[20]} {UMforCPU/conf_addr[21]} {UMforCPU/conf_addr[22]} {UMforCPU/conf_addr[23]} {UMforCPU/conf_addr[24]} {UMforCPU/conf_addr[25]} {UMforCPU/conf_addr[26]} {UMforCPU/conf_addr[27]} {UMforCPU/conf_addr[28]} {UMforCPU/conf_addr[29]} {UMforCPU/conf_addr[30]} {UMforCPU/conf_addr[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 134 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list {UMforCPU/data_confMem[0]} {UMforCPU/data_confMem[1]} {UMforCPU/data_confMem[2]} {UMforCPU/data_confMem[3]} {UMforCPU/data_confMem[4]} {UMforCPU/data_confMem[5]} {UMforCPU/data_confMem[6]} {UMforCPU/data_confMem[7]} {UMforCPU/data_confMem[8]} {UMforCPU/data_confMem[9]} {UMforCPU/data_confMem[10]} {UMforCPU/data_confMem[11]} {UMforCPU/data_confMem[12]} {UMforCPU/data_confMem[13]} {UMforCPU/data_confMem[14]} {UMforCPU/data_confMem[15]} {UMforCPU/data_confMem[16]} {UMforCPU/data_confMem[17]} {UMforCPU/data_confMem[18]} {UMforCPU/data_confMem[19]} {UMforCPU/data_confMem[20]} {UMforCPU/data_confMem[21]} {UMforCPU/data_confMem[22]} {UMforCPU/data_confMem[23]} {UMforCPU/data_confMem[24]} {UMforCPU/data_confMem[25]} {UMforCPU/data_confMem[26]} {UMforCPU/data_confMem[27]} {UMforCPU/data_confMem[28]} {UMforCPU/data_confMem[29]} {UMforCPU/data_confMem[30]} {UMforCPU/data_confMem[31]} {UMforCPU/data_confMem[32]} {UMforCPU/data_confMem[33]} {UMforCPU/data_confMem[34]} {UMforCPU/data_confMem[35]} {UMforCPU/data_confMem[36]} {UMforCPU/data_confMem[37]} {UMforCPU/data_confMem[38]} {UMforCPU/data_confMem[39]} {UMforCPU/data_confMem[40]} {UMforCPU/data_confMem[41]} {UMforCPU/data_confMem[42]} {UMforCPU/data_confMem[43]} {UMforCPU/data_confMem[44]} {UMforCPU/data_confMem[45]} {UMforCPU/data_confMem[46]} {UMforCPU/data_confMem[47]} {UMforCPU/data_confMem[48]} {UMforCPU/data_confMem[49]} {UMforCPU/data_confMem[50]} {UMforCPU/data_confMem[51]} {UMforCPU/data_confMem[52]} {UMforCPU/data_confMem[53]} {UMforCPU/data_confMem[54]} {UMforCPU/data_confMem[55]} {UMforCPU/data_confMem[56]} {UMforCPU/data_confMem[57]} {UMforCPU/data_confMem[58]} {UMforCPU/data_confMem[59]} {UMforCPU/data_confMem[60]} {UMforCPU/data_confMem[61]} {UMforCPU/data_confMem[62]} {UMforCPU/data_confMem[63]} {UMforCPU/data_confMem[64]} {UMforCPU/data_confMem[65]} {UMforCPU/data_confMem[66]} {UMforCPU/data_confMem[67]} {UMforCPU/data_confMem[68]} {UMforCPU/data_confMem[69]} {UMforCPU/data_confMem[70]} {UMforCPU/data_confMem[71]} {UMforCPU/data_confMem[72]} {UMforCPU/data_confMem[73]} {UMforCPU/data_confMem[74]} {UMforCPU/data_confMem[75]} {UMforCPU/data_confMem[76]} {UMforCPU/data_confMem[77]} {UMforCPU/data_confMem[78]} {UMforCPU/data_confMem[79]} {UMforCPU/data_confMem[80]} {UMforCPU/data_confMem[81]} {UMforCPU/data_confMem[82]} {UMforCPU/data_confMem[83]} {UMforCPU/data_confMem[84]} {UMforCPU/data_confMem[85]} {UMforCPU/data_confMem[86]} {UMforCPU/data_confMem[87]} {UMforCPU/data_confMem[88]} {UMforCPU/data_confMem[89]} {UMforCPU/data_confMem[90]} {UMforCPU/data_confMem[91]} {UMforCPU/data_confMem[92]} {UMforCPU/data_confMem[93]} {UMforCPU/data_confMem[94]} {UMforCPU/data_confMem[95]} {UMforCPU/data_confMem[96]} {UMforCPU/data_confMem[97]} {UMforCPU/data_confMem[98]} {UMforCPU/data_confMem[99]} {UMforCPU/data_confMem[100]} {UMforCPU/data_confMem[101]} {UMforCPU/data_confMem[102]} {UMforCPU/data_confMem[103]} {UMforCPU/data_confMem[104]} {UMforCPU/data_confMem[105]} {UMforCPU/data_confMem[106]} {UMforCPU/data_confMem[107]} {UMforCPU/data_confMem[108]} {UMforCPU/data_confMem[109]} {UMforCPU/data_confMem[110]} {UMforCPU/data_confMem[111]} {UMforCPU/data_confMem[112]} {UMforCPU/data_confMem[113]} {UMforCPU/data_confMem[114]} {UMforCPU/data_confMem[115]} {UMforCPU/data_confMem[116]} {UMforCPU/data_confMem[117]} {UMforCPU/data_confMem[118]} {UMforCPU/data_confMem[119]} {UMforCPU/data_confMem[120]} {UMforCPU/data_confMem[121]} {UMforCPU/data_confMem[122]} {UMforCPU/data_confMem[123]} {UMforCPU/data_confMem[124]} {UMforCPU/data_confMem[125]} {UMforCPU/data_confMem[126]} {UMforCPU/data_confMem[127]} {UMforCPU/data_confMem[128]} {UMforCPU/data_confMem[129]} {UMforCPU/data_confMem[130]} {UMforCPU/data_confMem[131]} {UMforCPU/data_confMem[132]} {UMforCPU/data_confMem[133]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list UMforCPU/conf_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list UMforCPU/conf_sel]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list UMforCPU/conf_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list UMforCPU/data_valid_confMem]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list pkt2gmii/empty_pkt]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list gmiiEn_asfifo]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list gmiiEn_calCRC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list gmiiEn_checkCRC]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list gmiiEn_modifyPKT]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list UMforCPU/tm/mem_instr]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list UMforCPU/tm/mem_rden]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list UMforCPU/tm/mem_ready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list UMforCPU/tm/mem_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list UMforCPU/tm/mem_wren]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list pktData_valid_gmii]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list UMforCPU/print_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list pkt2gmii/rden_pkt]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list UMforCPU/tm/trap]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_125m]
