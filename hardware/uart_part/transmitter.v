/*
 *  uart_hardware -- Hardware for uart.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.20
 *  Description: output data 1b by 1b. 
 */
module transmitter(
  input             clk_50m_i,
  input             rst_n_i,
  input       [7:0] din_8b_i,
  input             wren_i,
  input             clken_i,
  output reg        tx_o,
  output wire       tx_busy_o
);

parameter STATE_IDLE  = 2'b00;
parameter STATE_START = 2'b01;
parameter STATE_DATA  = 2'b10;
parameter STATE_STOP  = 2'b11;

reg [7:0] data;
reg [2:0] bitpos;
reg [1:0] state;

always @(posedge clk_50m_i or negedge rst_n_i) begin
  if(!rst_n_i) begin
    tx_o          <= 1'b1;
    data          <= 8'b0;
    bitpos        <= 3'b0;
    state         <= STATE_IDLE;
  end
  else begin
    case (state)
      STATE_IDLE: begin
        if(wren_i == 1'b1) begin
          state   <= STATE_START;
          data    <= din_8b_i;
          bitpos  <= 3'h0;
        end
      end
      STATE_START: begin
        if (clken_i) begin
          tx_o    <= 1'b0;
          state   <= STATE_DATA;
        end
      end
      STATE_DATA: begin
        if (clken_i) begin
          if (bitpos == 3'h7)
            state <= STATE_STOP;
          else
            bitpos <= bitpos + 3'h1;
          (*parallel_case, full_case*)
          case(bitpos)
            3'd0: tx_o  <= data[0];
            3'd1: tx_o  <= data[1];
            3'd2: tx_o  <= data[2];
            3'd3: tx_o  <= data[3];
            3'd4: tx_o  <= data[4];
            3'd5: tx_o  <= data[5];
            3'd6: tx_o  <= data[6];
            3'd7: tx_o  <= data[7];
          endcase
        end
      end
      STATE_STOP: begin
        if (clken_i) begin
          tx_o    <= 1'b1;
          state   <= STATE_IDLE;
        end
      end
      default: begin
        tx_o      <= 1'b1;
        state     <= STATE_IDLE;
      end
    endcase
  end
end

assign tx_busy_o = (state != STATE_IDLE);

endmodule
