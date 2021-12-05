/*
 *  uart_hardware -- Hardware for uart.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.20
 *  Description: generating clk for sampling rx/tx data. 
 */
module baud_rate_gen(
  input       clk_50m_i,
  input       rst_n_i,
  output wire rxclk_en_o,
  output wire txclk_en_o
);
parameter CLK_HZ        = 50000000,
          RX_ACC_MAX    = CLK_HZ / (115200 * 16),
          TX_ACC_MAX    = CLK_HZ / 115200,
          // RX_ACC_MAX    = 1,
          // TX_ACC_MAX    = 31,
          RX_ACC_WIDTH  = $clog2(RX_ACC_MAX)+1,
          TX_ACC_WIDTH  = $clog2(TX_ACC_MAX)+1;

reg [RX_ACC_WIDTH - 1:0] rx_acc;
reg [TX_ACC_WIDTH - 1:0] tx_acc;

assign rxclk_en_o = (rx_acc == 5'd0);
assign txclk_en_o = (tx_acc == 9'd0);

always @(posedge clk_50m_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    rx_acc      <= 0;
    tx_acc      <= 0;
  end
  else begin
    //* rx;
    if(rx_acc == RX_ACC_MAX[RX_ACC_WIDTH - 1:0])
      rx_acc    <= 0;
    else
      rx_acc    <= rx_acc + {{(RX_ACC_WIDTH - 1){1'b0}},1'b1};
    //* tx;
    if (tx_acc == TX_ACC_MAX[TX_ACC_WIDTH - 1:0])
      tx_acc    <= 0;
    else
      tx_acc    <= tx_acc + {{(TX_ACC_WIDTH - 1){1'b0}},1'b1};
  end
end

endmodule
