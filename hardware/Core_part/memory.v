/*
 *  iCore_hardware -- Hardware for TuMan RISC-V (RV32I) Processor Core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2020.01.01
 *  Description: This module is used to store instruction & data. 
 *   And we use "conf_sel" to distinguish configuring or running mode.
 */

`timescale 1 ns / 1 ps

module memory(
  input                 clk,
  input                 resetn,
  // interface for cpu
  input                 mem_wren,     
  input                 mem_rden,
  input         [31:0]  mem_addr,
  input         [3:0]   mem_wstrb,
  input         [31:0]  mem_wdata,
  output  wire  [31:0]  mem_rdata,
  output  wire          mem_ready,

  // interface for configuration
  input                 conf_sel,   // 1 is configuring;
  input                 conf_rden,
  input                 conf_wren,
  input         [31:0]  conf_addr,
  input         [31:0]  conf_wdata,
  output  wire  [31:0]  conf_rdata
);
  // selete one ram for writing;
  wire          [3:0]   wren_mem;
  

  // mux of configuration or cpu writing
  assign wren_mem[0] = mem_wstrb[0]? mem_wren: 1'b0;
  assign wren_mem[1] = mem_wstrb[1]? mem_wren: 1'b0;
  assign wren_mem[2] = mem_wstrb[2]? mem_wren: 1'b0;
  assign wren_mem[3] = mem_wstrb[3]? mem_wren: 1'b0;

  genvar i_ram;
  generate
    for (i_ram = 0; i_ram < 4; i_ram = i_ram+1) begin: ram_mem
      ram_8_16384 sram_for_mem(
        .clka(clk),
        .wea(conf_wren),
        .addra(conf_addr[13:0]),
        .dina(conf_wdata[i_ram*8+7:i_ram*8]),
        .douta(conf_rdata[i_ram*8+7:i_ram*8]),
        .clkb(clk),
        .web(wren_mem[i_ram]),
        .addrb(mem_addr[13:0]),
        .dinb(mem_wdata[i_ram*8+7:i_ram*8]),
        .doutb(mem_rdata[i_ram*8+7:i_ram*8])
      );
  end
  endgenerate

  //* assign mem_ready;
  reg [3:0] temp_ready;
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      temp_ready    <= 3'b0;
    end
    else begin
      temp_ready    <= {temp_ready[1:0],(mem_wren|mem_rden)};
    end
  end
  assign mem_ready  = temp_ready[1]&(~temp_ready[2]);


endmodule



