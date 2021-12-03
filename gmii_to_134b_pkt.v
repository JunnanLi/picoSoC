/*
 *  iCore_hardware -- Hardware for iCore.
 *
 *  Copyright (C) 2021-2021 Junnan Li <lijunnan@nudt.edu.cn>.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.07.22
 *  Description: accumulate sixteen 8b gmii data into 134b pkt.
 *  Noted:
 *    1) 134b pkt data definition: 
 *      [133:132] head tag, 2'b01 is head, 2'b10 is tail;
 *      [131:128] valid tag, 4'b1111 means sixteen 8b data is valid;
 *      [127:0]   pkt data, invalid part is padded with 0;
 */

`timescale 1ns / 1ps

module gmii_to_134b_pkt(
  input               rst_n,
  input               clk,
  input       [7:0]   gmii_data,
  input               gmii_data_valid,
  output  reg [133:0] pkt_data,
  output  reg         pkt_data_valid,
  output  reg [31:0]  cnt_pkt
);

reg   [1:0]   head_tag;
reg   [7:0]   pkt_tag[15:0];
reg   [3:0]   cnt_valid;
reg   [7:0]   cnt_16B;
reg   [3:0]   state_accu;
reg           gmii_pkt_finish;
//* fifo;
reg           wren_pkt,rden_pkt;
reg   [133:0] din_pkt;
wire  [133:0] dout_pkt;
wire          empty_pkt;

localparam    IDLE_S      = 4'd0,
              WAIT_TAIL_S = 4'd1,
              OVERFLOW_S  = 4'd2;

integer i;
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    gmii_pkt_finish <= 1'b0;
    wren_pkt        <= 1'b0;
    din_pkt         <= 134'b0;
    cnt_valid       <= 4'b0;
    head_tag        <= 2'b0;
    cnt_16B         <= 8'b0;
    state_accu      <= IDLE_S;

    for(i=0; i<16; i=i+1) begin
      pkt_tag[i]    <= 8'b0;
    end
  end
  else begin
    case(state_accu)
      IDLE_S: begin
        gmii_pkt_finish <= 1'b0;
        wren_pkt        <= 1'b0;
        din_pkt         <= 134'b0;
        head_tag        <= 2'b01;
        cnt_16B         <= 8'b0;
        if(gmii_data_valid == 1'b1) begin
          for(i=0; i<16; i=i+1) begin
            if(i==cnt_valid)  pkt_tag[i]  <= gmii_data;
            else              pkt_tag[i]  <= pkt_tag[i];
          end
          cnt_valid     <= cnt_valid + 4'd1;
        end
        else begin  //* packet < 16B, discard;
          cnt_valid     <= 4'd0;
        end
        if(cnt_valid == 4'd15) begin
          state_accu    <= WAIT_TAIL_S;
        end
      end
      WAIT_TAIL_S: begin
        wren_pkt        <= 1'b0;
        if(gmii_data_valid == 1'b1) begin
          for(i=0; i<16; i=i+1) begin
            if(i==cnt_valid)  pkt_tag[i]  <= gmii_data;
            else              pkt_tag[i]  <= pkt_tag[i];
          end
          cnt_valid     <= cnt_valid + 4'd1;
        
          //* refresh state;
          head_tag      <= 2'b0;
          if(cnt_valid == 4'd0) begin
            //* packet > 2KB, Truncate pkt;
            cnt_16B     <= cnt_16B + 8'd1;
            if(cnt_16B == 8'd130) begin
              state_accu      <= OVERFLOW_S;
              gmii_pkt_finish <= 1'b1;
              wren_pkt        <= 1'b1;
              din_pkt         <= {2'b10,4'hf,pkt_tag[0],pkt_tag[1],pkt_tag[2],
                    pkt_tag[3],pkt_tag[4],pkt_tag[5],pkt_tag[6],pkt_tag[7],
                    pkt_tag[8],pkt_tag[9],pkt_tag[10],pkt_tag[11],
                    pkt_tag[12],pkt_tag[13],pkt_tag[14],pkt_tag[15]};
            end
            else begin
              wren_pkt        <= 1'b1;
              din_pkt         <= {head_tag,4'hf,pkt_tag[0],pkt_tag[1],pkt_tag[2],
                    pkt_tag[3],pkt_tag[4],pkt_tag[5],pkt_tag[6],pkt_tag[7],
                    pkt_tag[8],pkt_tag[9],pkt_tag[10],pkt_tag[11],
                    pkt_tag[12],pkt_tag[13],pkt_tag[14],pkt_tag[15]};
            end
          end
        end
        else begin
          gmii_pkt_finish     <= 1'b1;
          wren_pkt            <= 1'b1;
          din_pkt             <= {2'b10,cnt_valid-4'd1,pkt_tag[0],pkt_tag[1],pkt_tag[2],
                    pkt_tag[3],pkt_tag[4],pkt_tag[5],pkt_tag[6],pkt_tag[7],
                    pkt_tag[8],pkt_tag[9],pkt_tag[10],pkt_tag[11],
                    pkt_tag[12],pkt_tag[13],pkt_tag[14],pkt_tag[15]};
          state_accu          <= IDLE_S;
          cnt_valid           <= 4'd0;
          //* packet = 16B, discard;
          if(head_tag == 2'b01)
            wren_pkt          <= 1'b0;
        end
        
      end
      OVERFLOW_S: begin
        wren_pkt              <= 1'b0;
        gmii_pkt_finish       <= 1'b0;
        if(gmii_data_valid == 1'b0)
          state_accu          <= IDLE_S;
      end
      default: begin
        state_accu            <= IDLE_S;
      end
    endcase
  end
end



//* count packets buffer in the fifo;
reg   [7:0] cnt_pkt_fifo;
reg         rden_pkt_temp;

//* calculate how many packets buffered in the fifo;
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    for(i=0; i<4; i=i+1) begin
      cnt_pkt_fifo          <= 8'b0;
      rden_pkt_temp         <= 1'b0;
    end
  end
  else begin
      rden_pkt_temp         <= rden_pkt;
    
      (* full_case, parallel_case *)
      case({gmii_pkt_finish,(rden_pkt&~rden_pkt_temp)})
        2'd0: cnt_pkt_fifo  <= cnt_pkt_fifo;
        2'd1: cnt_pkt_fifo  <= cnt_pkt_fifo - 8'd1;
        2'd2: cnt_pkt_fifo  <= cnt_pkt_fifo + 8'd1;
        2'd3: cnt_pkt_fifo  <= cnt_pkt_fifo;
      endcase
  end
end

//* read pkt_data from 8 fifo according to the priority;
reg   [3:0] state_read;
localparam  WAIT_1_CLK_S  = 4'd2;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    rden_pkt        <= 1'b0;
    pkt_data_valid  <= 1'b0;
    pkt_data        <= 134'b0;
    state_read      <= IDLE_S;
    cnt_pkt         <= 32'b0;
  end
  else begin
    case(state_read)
      IDLE_S: begin
        pkt_data_valid    <= 1'b0;
        rden_pkt          <= 4'b0;
        if(cnt_pkt_fifo != 8'b0) begin
          rden_pkt        <= 1'b1;
          state_read      <= WAIT_TAIL_S;
          cnt_pkt         <= 32'b1 + cnt_pkt;
        end
        else begin
          state_read      <= IDLE_S;
        end
      end
      WAIT_TAIL_S: begin
        pkt_data_valid    <= 1'b1;
        pkt_data          <= dout_pkt;
        if(dout_pkt[133:132] == 2'b10) begin
          rden_pkt        <= 1'b0;
          state_read      <= WAIT_1_CLK_S;
        end
      end
      WAIT_1_CLK_S: begin
        pkt_data_valid    <= 1'b0;
        state_read        <= IDLE_S;
      end
      default: begin
        state_read        <= IDLE_S;
      end
    endcase
  end
end


fifo_134b_512 fifo_pkt (
  .clk(clk),            // input wire clk
  .srst(!rst_n),          // input wire srst
  .din(din_pkt),      // input wire [133 : 0] din
  .wr_en(wren_pkt),   // input wire wr_en
  .rd_en(rden_pkt),   // input wire rd_en
  .dout(dout_pkt),    // output wire [133 : 0] dout
  .full(),            // output wire full
  .empty(empty_pkt)   // output wire empty
);




endmodule
