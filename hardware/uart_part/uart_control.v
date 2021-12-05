/*
 *  uart_hardware -- Hardware for uart.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.20
 *  Description: controller of uart. 
 */
module uart_control(
  input                 clk_50m_i,
  input                 rst_n_i,
  input         [31:0]  addr_32b_i,
  input                 wren_i,
  input                 rden_i,
  input         [31:0]  din_32b_i,
  output  reg           dout_32b_valid_o,
  output  reg   [31:0]  dout_32b_o,
  output  wire          interrupt_o,

  input         [7:0]   din_8b_i,
  input                 din_valid_i,
  output  wire  [7:0]   dout_8b_o,
  output  wire          dout_valid_o,
  input                 tx_busy_i
);

parameter BASE_ADDR     = 32'h10010000;

//* fifo;
(* mark_debug = "true"*)reg           rden_rx,rden_tx,wren_tx;
(* mark_debug = "true"*)reg     [7:0] din_tx;
(* mark_debug = "true"*)wire    [7:0] dout_rx,dout_tx;
(* mark_debug = "true"*)wire          empty_rx,empty_tx;

//* registers (8b);
/*------------------------------------------------------------------------------------
 *    name    | offset  |  description
 *------------------------------------------------------------------------------------
 *   UART_RBR |   0x0   | Receive Buffer Register, read-only,
 *            |         |   read 8b data from rx_fifo
 *------------------------------------------------------------------------------------
 *   UART_THR |   0x4   | Transmitter Holding Register, write-only, 
 *                      |   write 8b data to tx_fifo
 *------------------------------------------------------------------------------------
 *   UART_DLL |   0x8   | Divisor Latch LSB, read/write, configure baud rate (low 8b)
 *------------------------------------------------------------------------------------
 *   UART_DLM |   0xc   | Divisor Latch MSB, read/write, configure baud rate (high 8b)
 *------------------------------------------------------------------------------------
 *   UART_IER |   0x10  | Interrupt Enable Register, read/write
 *            |         |   2: 1 means open check-error interrupt
 *            |         |   1: 1 means open TX-FIFO-empty interrupt
 *            |         |   0: 1 means open RX-FIFO-Threshold interrupt
 *------------------------------------------------------------------------------------
 *   UART_IIR |   0x14  | Interrupt Idenfitication Register, read
 *            |         |   [3:0]: 4 is TX-FIFO-empty interrupt, 8 is RX-FIFO-Threshold interrupt
 *            |         |         12 is check-error interrupt
 *------------------------------------------------------------------------------------
 *   UART_FCR |   0x18  | FIFO Control Register, write-only
 *            |         |   [7:6]: trigger threshold, 0 is 1B, 1 is 2B, 2 is 4B, 3 is 8B
 *            |         |   2: '1' means reset TX-FIFO
 *            |         |   1: '1' means reset RX-FIFO
 *------------------------------------------------------------------------------------
 *   UART_LCR |   0x1c  | Line Control Register, read/write
 *            |         |   7: read/write, '1' for configuring UART_DLL/UART_DLM
 *            |         |   [5:4]: read/write, check mode, 0 is odd, 1 is even, 2 is space, 3 is mark
 *            |         |   3: read/write, '1' for opening check mode
 *            |         |   2: read/write, number of stop bit, 0 is 1-bit, 1 is 2-bit 
 *            |         |   [1:0]: read/write, lenth of each transmittion, 0 is 5bit, 1 is 6bit, 2 is 7bit, 3 is 8bit
 *------------------------------------------------------------------------------------
 *   UART_LSR |   0x20  | Line State Register, read-only
 *            |         |   5: read-only, '1' means TX-FIFO is empty
 *            |         |   2: read-only, '1' means meeting check error
 *            |         |   0: read-only, '1' means RX-FIFO is not empty
 *------------------------------------------------------------------------------------
 */

assign dout_8b_o = dout_tx;
assign dout_valid_o = rden_tx;
//* TODO...
assign interrupt_o = ~empty_rx;

reg   [3:0] state_reg;
localparam    IDLE_S          = 4'd0;

always @(posedge clk_50m_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    rden_rx           <= 1'b0;
    rden_tx           <= 1'b0;
    wren_tx           <= 1'b0;
    din_tx            <= 8'b0;
    dout_32b_valid_o  <= 1'b0;
    dout_32b_o        <= 32'b0;
  end
  else begin
    //* read tx_fifo, and write tx;
    if(empty_tx == 1'b0 && rden_tx == 1'b0 && tx_busy_i == 1'b0) begin
      rden_tx         <= 1'b1;
    end
    else begin
      rden_tx         <= 1'b0;
    end

    //* read/write registers;
    dout_32b_valid_o  <= 1'b0;
    wren_tx           <= 1'b0;
    rden_rx           <= 1'b0;
    case(state_reg)
      IDLE_S: begin
        if(addr_32b_i[31:16] == BASE_ADDR[31:16]) begin
          //* TODO...
          if(addr_32b_i[5:2] == 4'h0 && rden_i == 1'b1) begin
            dout_32b_valid_o  <= 1'b1;
            dout_32b_o        <= dout_rx;
            rden_rx           <= 1'b1;
          end
          else if(addr_32b_i[5:2] == 4'h1 && wren_i == 1'b1) begin
            wren_tx           <= 1'b1;
            din_tx            <= din_32b_i[7:0];
          end
        end
      end
      default: begin
        state_reg     <= IDLE_S;
      end
    endcase
  end
end



fifo_8b_512 data_rx(
  .clk(clk_50m_i),
  .srst(!rst_n_i),
  .din(din_8b_i),
  .wr_en(din_valid_i),
  .rd_en(rden_rx),
  .dout(dout_rx),
  .full(),
  .empty(empty_rx),
  .data_count()
);

fifo_8b_512 data_tx(
  .clk(clk_50m_i),
  .srst(!rst_n_i),
  .din(din_tx),
  .wr_en(wren_tx),
  .rd_en(rden_tx),
  .dout(dout_tx),
  .full(),
  .empty(empty_tx),
  .data_count()
);

endmodule
