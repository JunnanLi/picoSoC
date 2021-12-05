/*
 *  uart_hardware -- Hardware for uart.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.20
 *  Description: top module of uart. 
 */
module uart(
  input                 clk_50m_i,
  input                 rst_n_i,
  output  wire          uart_tx_o,
  input                 uart_rx_i,

  input         [31:0]  addr_32b_i,
  input                 wren_i,
  input                 rden_i,
  input         [31:0]  din_32b_i,
  output  wire  [31:0]  dout_32b_o,
  output  wire          dout_32b_valid_o,
  output  wire          interrupt_o
);

//* clk for sampling rx/tx;
(* mark_debug = "true"*)wire  rxclk_en, txclk_en;

//* data and valid signals;
(* mark_debug = "true"*)wire  uart_dataTx_valid, uart_dataRx_valid;
(* mark_debug = "true"*)wire  [7:0] uart_dataTx, uart_dataRx;
(* mark_debug = "true"*)wire  uart_tx_busy_o;

//* gen rx/tx sample clk;
baud_rate_gen uart_baud(
  .clk_50m_i(clk_50m_i),
  .rst_n_i(rst_n_i),
  .rxclk_en_o(rxclk_en),
  .txclk_en_o(txclk_en)
);
//* 8b din -> 1b tx;
transmitter uart_tx(
  .clk_50m_i(clk_50m_i),
  .rst_n_i(rst_n_i),
  .din_8b_i(uart_dataTx),
  .wren_i(uart_dataTx_valid),
  .clken_i(txclk_en),
  .tx_o(uart_tx_o),
  .tx_busy_o(uart_tx_busy_o)
);
//* 1b rx -> 8b dout;
receiver uart_rx(
  .clk_50m_i(clk_50m_i),
  .rst_n_i(rst_n_i),
  .clken_i(rxclk_en),
  .dout_8b_o(uart_dataRx),
  .dout_valid_o(uart_dataRx_valid),
  .rx_i(uart_rx_i)
);

uart_control uart_ctl(
  .clk_50m_i(clk_50m_i),
  .rst_n_i(rst_n_i),
  .addr_32b_i(addr_32b_i),
  .wren_i(wren_i),
  .rden_i(rden_i),
  .din_32b_i(din_32b_i),
  .dout_32b_o(dout_32b_o),
  .dout_32b_valid_o(dout_32b_valid_o),
  .interrupt_o(interrupt_o),

  .din_8b_i(uart_dataRx),
  .din_valid_i(uart_dataRx_valid),
  .dout_8b_o(uart_dataTx),
  .dout_valid_o(uart_dataTx_valid),
  .tx_busy_i(uart_tx_busy_o)
);

endmodule
