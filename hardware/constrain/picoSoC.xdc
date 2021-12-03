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








