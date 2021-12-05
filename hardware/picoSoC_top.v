/*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2021-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.12.03
 *  Description: Top Module of picoSoC_hardware.
 *  Noted:
 *    1) rgmii2gmii & gmii_rx2rgmii are processed by language templates;
 *    2) rgmii_rx is constrained by set_input_delay "-2.0 ~ -0.7";
 *    3) 134b pkt data definition: 
 *      [133:132] head tag, 2'b01 is head, 2'b10 is tail;
 *      [131:128] valid tag, 4'b1111 means sixteen 8b data is valid;
 *      [127:0]   pkt data, invalid part is padded with 0;
 *    4) the riscv-32i core is a simplified picoRV32
 */

`timescale 1ns / 1ps

module picoSoC_top(
  //* system input, clk;
  input               sys_clk,
  input               rst_n,
  //* rgmii port;
  output  wire        mdio_mdc,
  inout               mdio_mdio_io,
  // output  wire        phy_reset_n,
  input         [3:0] rgmii_rd,
  input               rgmii_rx_ctl,
  input               rgmii_rxc,
  output  wire  [3:0] rgmii_td,
  output  wire        rgmii_tx_ctl,
  output  wire        rgmii_txc,
  //* uart rx/tx
  input               uart_rx,    //* fpga receive data, lefted;
  output  wire        uart_tx     //* fpga send data
);

  //* clock & locker;
  wire  clk_125m, clk_50m;
  wire  locked;   // locked =1 means generating 125M clock successfully;

  //* connected wire
  //* speed_mode, clock_speed, mdio (gmii_to_rgmii IP)
  wire  [1:0]   speed_mode, clock_speed;
  wire          mdio_gem_mdc, mdio_gem_o, mdio_gem_t;
  wire          mdio_gem_i;
  
  //* assign phy_reset_n = 1, haven't been used;
  // assign phy_reset_n = rst_n;

  //* assign mdio_mdc = 0, haven't been used;
  assign mdio_mdc = 1'b0;

  //* system reset signal, low is active;
  wire sys_rst_n;
  assign sys_rst_n = rst_n & locked;

  //* gen 125M clock;
  clk_wiz_0 clk_to_125m(
    // Clock out ports
    .clk_out1(clk_125m),        // output 125m;
    .clk_out2(clk_50m),         // output 50m;
    // Status and control signals
    .reset(!rst_n),             // input reset
    .locked(locked),            // output locked
    // Clock in ports
    .clk_in1(sys_clk)
    // .clk_in1_p(sys_clk_p),  // input clk_in1_p
    // .clk_in1_n(sys_clk_n)   // input clk_in1_n
  );
  
  (* mark_debug = "true"*)wire  [133:0] pktData_gmii, pktData_um;
  (* mark_debug = "true"*)wire          pktData_valid_gmii, pktData_valid_um;

  soc_runtime runtime(
    .clk_125m(clk_125m),
    .sys_rst_n(sys_rst_n),
    //* rgmii;
    .rgmii_rd(rgmii_rd),            // input
    .rgmii_rx_ctl(rgmii_rx_ctl),    // input
    .rgmii_rxc(rgmii_rxc),          // input

    .rgmii_txc(rgmii_txc),          // output
    .rgmii_td(rgmii_td),            // output
    .rgmii_tx_ctl(rgmii_tx_ctl),    // output

    //* um;
    .pktData_valid_gmii(pktData_valid_gmii),
    .pktData_gmii(pktData_gmii),
    .pktData_valid_um(pktData_valid_um),
    .pktData_um(pktData_um)
  );

  um_for_cpu UMforCPU(
    .clk(clk_125m),
    .rst_n(sys_rst_n),
    .data_in_valid(pktData_valid_gmii),
    .data_in(pktData_gmii),
    .data_out_valid(pktData_valid_um),
    .data_out(pktData_um),

    //* uart;
    .clk_50m(clk_50m),
    .uart_rx(uart_rx),
    .uart_tx(uart_tx),

    //* left for packet process;
    .mem_wren(),
    .mem_rden(),
    .mem_addr(),
    .mem_wdata(),
    .mem_rdata(32'b0),
    .cpu_ready()
  );

  
  

endmodule
