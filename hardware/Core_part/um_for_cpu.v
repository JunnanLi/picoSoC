/*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2021-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.12.03
 *  Description: This module is used to connect pico_top with configuration,
 *    and uart.
 */

module um_for_cpu(
  input               clk,
  input               rst_n,
    
  input               data_in_valid,
  input       [133:0] data_in,  // 2'b01 is head, 2'b00 is body, and 2'b10 is tail;
  output wire         data_out_valid,
  output wire [133:0] data_out,

  input               clk_50m,
  input               uart_rx,
  output wire         uart_tx,

  //* left for packet process;
  output wire         mem_wren,
  output wire         mem_rden,
  output wire [31:0]  mem_addr,
  output wire [31:0]  mem_wdata,
  input       [31:0]  mem_rdata,
  output wire         cpu_ready
);

  /** TODO:*/

  (* mark_debug = "true"*)wire          conf_rden, conf_wren;
  (* mark_debug = "true"*)wire [31:0]   conf_addr, conf_wdata, conf_rdata;
  (* mark_debug = "true"*)wire          conf_sel;
  (* mark_debug = "true"*)wire          print_valid;
  (* mark_debug = "true"*)wire [7:0]    print_value;
  // (* mark_debug = "true"*)wire          data_valid_confMem;
  // (* mark_debug = "true"*)wire [133:0]  data_confMem;
  // fifo interface
  reg           rden_uart;
  wire [7:0]    dout_uart_8b;
  wire          empty_uart;
  
  //* left for packet process;
  assign cpu_ready  = 1'b1;
  assign mem_wren   = 1'b0;
  assign mem_rden   = 1'b0;
  assign mem_addr   = 32'b0;
  assign mem_wdata  = 32'b0;

  pico_top picoTop(
    .clk(clk),
    .resetn(rst_n),

    .conf_rden(conf_rden),
    .conf_wren(conf_wren),
    .conf_addr(conf_addr),
    .conf_wdata(conf_wdata),
    .conf_rdata(conf_rdata),
    .conf_sel(conf_sel),

    .print_valid(print_valid),
    .print_value(print_value)
  );

  conf_mem confMem(
    .clk(clk),
    .resetn(rst_n),

    .data_in_valid(data_in_valid),
    .data_in(data_in),
    .data_out_valid(data_out_valid),
    .data_out(data_out),

    .conf_rden(conf_rden),
    .conf_wren(conf_wren),
    .conf_addr(conf_addr),
    .conf_wdata(conf_wdata),
    .conf_rdata(conf_rdata),
    .conf_sel(conf_sel)
  );

  asfifo_8b_512 asfifo_uart (
    .rst(!rst_n),         // input wire rst
    .wr_clk(clk),         // input wire wr_clk
    .rd_clk(clk_50m),     // input wire rd_clk
    .din(print_value),    // input wire [7 : 0] din
    .wr_en(print_valid),  // input wire wr_en
    .rd_en(rden_uart),    // input wire rd_en
    .dout(dout_uart_8b),  // output wire [7 : 0] dout
    .full(),              // output wire full
    .empty(empty_uart)    // output wire empty
  );

  (* mark_debug = "true"*)reg   [31:0]  addr_32b_i;
  (* mark_debug = "true"*)reg           wren_i,rden_i;
  (* mark_debug = "true"*)reg   [31:0]  din_32b_i;
  (* mark_debug = "true"*)wire  [31:0]  dout_32b_o;
  (* mark_debug = "true"*)wire          dout_32b_valid_o;
  (* mark_debug = "true"*)wire          interrupt_o;

  uart uart_inst(
    .clk_50m_i(clk_50m),
    .rst_n_i(rst_n),
    .uart_tx_o(uart_tx),
    .uart_rx_i(uart_rx),
    .addr_32b_i(addr_32b_i),
    .wren_i(wren_i),
    .rden_i(rden_i),
    .din_32b_i(din_32b_i),
    .dout_32b_o(dout_32b_o),
    .dout_32b_valid_o(dout_32b_valid_o),
    .interrupt_o(interrupt_o)
  );

  /** output print value */
  reg [3:0]   cnt_wait_clk;
  always @(posedge clk_50m or negedge rst_n) begin
    if (!rst_n) begin
      // reset
      rden_uart       <= 1'b0;
      wren_i          <= 1'b0;
      rden_i          <= 1'b0;
      din_32b_i       <= 32'b0;
      addr_32b_i      <= 32'b0;
      cnt_wait_clk    <= 4'b0;
    end
    else begin
      rden_uart       <= 1'b0;
      rden_i          <= 1'b0;
      wren_i          <= 1'b0;
      cnt_wait_clk    <= 4'b1 + cnt_wait_clk;
      // if(interrupt_o == 1'b1 && cnt_wait_clk == 4'b0) begin
      //   rden_i        <= 1'b1;
      //   addr_32b_i    <= 32'h10010000;
      // end
      if(empty_uart == 1'b0 && cnt_wait_clk == 4'b0) begin
        rden_uart     <= 1'b1;
        wren_i        <= 1'b1;
        addr_32b_i    <= 32'h10010004;
        din_32b_i     <= {24'b0,dout_uart_8b};
      end
    end
  end

  
endmodule    
