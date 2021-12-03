/*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2019-2020 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.12.03
 *  Description: This module is the top module of pico.
 */
 `timescale 1 ns / 1 ps

module Pico_top(
  input                 clk,
  input                 resetn,
  // interface for configuring memory
  input                 conf_rden,
  input                 conf_wren,
  input         [31:0]  conf_addr,
  input         [31:0]  conf_wdata,
  output  wire  [31:0]  conf_rdata,
  input                 conf_sel,
  // interface for outputing "print"
  output  reg           print_valid,
  output  reg   [7:0]   print_value
);

/** sram interface for instruction and data*/
  (* mark_debug = "true"*)wire        mem_valid;            //  read/write is valid;
  (* mark_debug = "true"*)wire        mem_instr;            //  read instr, not used;
  (* mark_debug = "true"*)wire        mem_wren;             //  write data request
  (* mark_debug = "true"*)wire        mem_rden;             //  read data request
  (* mark_debug = "true"*)wire        mem_ready;            //  read/write ready;
  (* mark_debug = "true"*)wire [31:0] mem_addr;             //  write/read addr
  (* mark_debug = "true"*)wire [31:0] mem_wdata;            //  write data
  (* mark_debug = "true"*)wire [3:0]  mem_wstrb;            //  write wstrb
  (* mark_debug = "true"*)wire [31:0] mem_rdata;            //  data

  reg  [31:0] clk_counter;          //  timer;
  reg         finish_tag;           //  finish_tag is 0 when cpu writes 0x20000000;

  (* mark_debug = "true"*)wire        trap;

picorv32_simplified picorv32(
  .clk(clk),
  .resetn(resetn&~conf_sel&finish_tag),
  .trap(trap),
  .mem_valid(mem_valid),
  .mem_instr(mem_instr),
  .mem_ready(mem_ready),
  .mem_addr(mem_addr),
  .mem_wdata(mem_wdata),
  .mem_wstrb(mem_wstrb),
  .mem_rdata(mem_rdata),
  .mem_la_read(),
  .mem_la_write(),
  .mem_la_addr(),
  .mem_la_wdata(),
  .mem_la_wstrb(),
  .irq(32'b0),
  .eoi(),
  .trace_valid(),
  .trace_data()
);


memory mem(
  .clk(clk),
  .resetn(resetn),
  .mem_wren(mem_wren),
  .mem_rden(mem_rden),
  .mem_addr({2'b0,mem_addr[31:2]}),
  .mem_wdata(mem_wdata),
  .mem_wstrb(mem_wstrb),
  .mem_rdata(mem_rdata),
  .mem_ready(mem_ready),

  .conf_sel(conf_sel),
  .conf_rden(conf_rden),
  .conf_wren(conf_wren),
  .conf_addr(conf_addr),
  .conf_wdata(conf_wdata),
  .conf_rdata(conf_rdata)
);

  //* assign memory interface signals;
  assign mem_wren = mem_valid & (|mem_wstrb);
  assign mem_rden = mem_valid & (mem_wstrb == 4'b0);

  //* assign finish_tag;
  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      finish_tag      <= 1'b1;
    end
    else begin
      if(mem_addr == 32'h20000000 && mem_wren == 1'b1)
        finish_tag    <= 1'b0;
      else
        finish_tag    <= finish_tag|conf_sel;
    end
  end

  //* assign print;
  always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      print_value     <= 8'b0;
      print_valid     <= 1'b0;
    end
    else begin
      if(mem_wren == 1'b1 && mem_addr == 32'h10000000 && mem_ready == 1'b1) begin
        print_valid   <= 1'b1;
        print_value   <= mem_wdata[7:0];
        $write("%c", mem_wdata[7:0]);
        $fflush();
      end
      else begin
        print_valid   <= 1'b0;
      end
    end
  end


  // always @(posedge clk or negedge resetn) begin
  //   if(!resetn) begin

  //   end
  //   else begin
           
  //   end
  //   if(mem_addr_toPipe == 32'h200000012 && mem_rden_toPipe)
  //    $display("read addr12 clk_count: %d", clk_count);
  //   else if(mem_addr_toPipe == 32'h200000011 && mem_rden_toPipe)
  //            $display("read addr11 clk_count: %d", clk_count);
  //   if(mem_addr_toPipe == 32'h20000003 && mem_wren_toPipe)
  //    $display("write clk_count: %d", clk_count);
  // end

endmodule

