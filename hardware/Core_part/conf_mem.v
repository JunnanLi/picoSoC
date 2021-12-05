 /*
 *  picoSoC_hardware -- SoC Hardware for RISCV-32I core.
 *
 *  Copyright (C) 2021-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.12.03
 *  Description: This module is used to configure itcm and dtcm of CPU, 
 *   and output "print" in program running on cpu.
 */

`timescale 1 ns / 1 ps

module conf_mem(
  input               clk,
  input               resetn,

  input               data_in_valid,  // input data valid
  input       [133:0] data_in,    

  output  reg         data_out_valid, // output data valid
  (* mark_debug = "true"*)output  reg [133:0] data_out,       // output data

  output  reg         conf_rden,      // configure interface
  output  reg         conf_wren,
  output  reg [31:0]  conf_addr,
  output  reg [31:0]  conf_wdata,
  input       [31:0]  conf_rdata,
  (* mark_debug = "true"*)output  reg         conf_sel        // '1' means configuring is valid;
);


/** state_conf is used to configure (read or write) itcm and dtcm
* stat_out is used to output "print" in the program running on CPU
*/
(* mark_debug = "true"*)reg [3:0] state_conf, state_out;
parameter IDLE_S      = 4'd0,
          READ_META_1 = 4'd1,
          WR_SEL_S    = 4'd3,
          RD_SEL_S    = 4'd4,
          WR_PROG_S   = 4'd5,
          RD_PROG_S   = 4'd6,
          DISCARD_S   = 4'd7,
          SEND_HEAD_0 = 4'd3,
          SEND_HEAD_1 = 4'd4,
          SEND_HEAD_2 = 4'd5,
          SEND_HEAD_3 = 4'd6;

/** read_sel_tag is used to identify whether need to read "sel", i.e., 
*   running mode of CPU
*/
reg     read_sel_tag[1:0];

/** state machine for configuring itcm and dtcm:
*   1) distinguish action type according to ethernet_type filed;
*   2) configure running mode, i.e., "conf_sel_dtcm", 0 is configure, 
*     while 1 is running;
*   3) read running mode, i.e., toggle "read_sel_tag[0]";
*   4) write program, including itcm and dtcm;
*   5) read program, including itcm and dtcm;
*/
always @(posedge clk or negedge resetn) begin
  if (!resetn) begin
    // reset
    conf_rden             <= 1'b0;
    conf_wren             <= 1'b0;
    conf_addr             <= 32'b0;
    conf_wdata            <= 32'b0;
    conf_sel              <= 1'b1;

    state_conf            <= IDLE_S;
    read_sel_tag[0]       <= 1'b0;
  end
  else begin
    case(state_conf)
      IDLE_S: begin
        conf_wren         <= 1'b0;
        conf_rden         <= 1'b0;
        if(data_in_valid == 1'b1 && data_in[133:132] == 2'b01 &&
          data_in[31:24] == 8'h90) begin
            (*full_case, parallel_case*)
            case(data_in[17:16])
              2'd1: state_conf  <= WR_SEL_S;
              2'd2: state_conf  <= RD_SEL_S;
              2'd3: state_conf  <= WR_PROG_S;
              2'd0: state_conf  <= RD_PROG_S;
            endcase
        end
        else begin
          state_conf      <= IDLE_S;
        end
      end
      WR_SEL_S: begin
        conf_sel          <= data_in[16];
        state_conf        <= DISCARD_S;
      end
      RD_SEL_S: begin
        state_conf        <= DISCARD_S;
        read_sel_tag[0]   <= ~read_sel_tag[0];
      end
      WR_PROG_S: begin
        conf_wren         <= 1'b1;
        conf_addr         <= data_in[47:16];
        conf_wdata        <= data_in[79:48];

        if(data_in[133:132] == 2'b10) begin
          state_conf      <= IDLE_S;
        end
        else begin
          state_conf      <= WR_PROG_S;
        end
      end
      RD_PROG_S: begin
        // TODO:
        state_conf        <= DISCARD_S;
        conf_rden         <= 1'b1;
        conf_addr         <= data_in[47:16];
      end
      DISCARD_S: begin
        conf_rden         <= 1'b0;
        if(data_in[133:132] == 2'b10)
          state_conf      <= IDLE_S;
        else
          state_conf      <= DISCARD_S;
      end
      default: begin
        state_conf        <= IDLE_S;
      end
    endcase
  end
end


/** register and wire */
reg   [31:0]  addr_temp[1:0]; // maintain address for reading program;
reg           rden_temp[1:0]; // maintain action type;
reg           rdreq_rdata;    // fifo interface of reading program
wire          empty_rdata;  
wire  [63:0]  q_rdata;    

/** state machine used for maintaining address and action type of reading 
 ** program
 **/
always @(posedge clk or negedge resetn) begin
  if (!resetn) begin
    // reset
    {addr_temp[0],addr_temp[1]}   <= 64'b0;
    {rden_temp[0],rden_temp[1]}   <= 2'b0;
  end
  else begin
    {addr_temp[1],addr_temp[0]}   <= {addr_temp[0],conf_addr};
    {rden_temp[1],rden_temp[0]}   <= {rden_temp[0],conf_rden};
  end
end

/** fifo used to buffer reading result*/
  fifo_64b_512 rdata_buffer(
    .clk(clk),
    .srst(!resetn),
    .din({conf_rdata, addr_temp[1]}),
    .wr_en(rden_temp[1]),
    .rd_en(rdreq_rdata),
    .dout(q_rdata),
    .full(),
    .empty(empty_rdata)
  );

/** state machine used to output reading result or print value:
*   1) configure metadata_0&1 (according to fast packet format);
*   2) output reading result or print value which is distinguished
*     by ethernet_type filed;
*/
always @(posedge clk or negedge resetn) begin
  if (!resetn) begin
    // reset
    data_out_valid          <= 1'b0;
    data_out                <= 134'b0;
    read_sel_tag[1]         <= 1'b0;

    rdreq_rdata             <= 1'b0;
  end
  else begin
    case(state_out)
      IDLE_S: begin
        data_out_valid      <= 1'b0;
        if(read_sel_tag[1] != read_sel_tag[0] || empty_rdata == 1'b0) begin
          state_out         <= SEND_HEAD_0;
        end
        else begin
          state_out         <= IDLE_S;
        end
      end
      SEND_HEAD_0: begin
        data_out_valid <= 1'b1;
        if(read_sel_tag[1] != read_sel_tag[0]) begin
          data_out[31:0]    <= {16'h9002,16'd1};
        end
        else begin
          data_out[31:0]    <= {16'h9004,16'b0};
          rdreq_rdata       <= 1'b1;
        end
        state_out           <= SEND_HEAD_1;
        data_out[133:32]    <= {2'b01,4'hf,48'h1111_2222_3333,48'h1111_2222_4444};      
      end
      SEND_HEAD_1: begin
        rdreq_rdata         <= 1'b0;
        if(read_sel_tag[1] != read_sel_tag[0]) begin
          data_out[111:16]  <= {95'b0,conf_sel};
          read_sel_tag[1]   <= read_sel_tag[0];
        end
        else
          data_out[111:16]  <= {32'b0,q_rdata};
        data_out[133:112]   <= {2'b0,4'hf,16'b0};
        data_out[15:0]      <= 16'b0;
        state_out           <= SEND_HEAD_2;
      end
      SEND_HEAD_2: begin
        data_out            <= {2'b0,4'hf,128'd1};
        state_out           <= SEND_HEAD_3;
      end
      SEND_HEAD_3: begin
        state_out           <= IDLE_S;
        data_out            <= {2'b10,4'hf,128'd2};
      end
      default: begin
        state_out           <= IDLE_S;
      end
    endcase
  end
end


endmodule
