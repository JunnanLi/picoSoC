/*
 *  uart_hardware -- Hardware for uart.
 *
 *  Please communicate with Junnan Li <lijunnan@nudt.edu.cn> when meeting any question.
 *  Copyright and related rights are licensed under the MIT license.
 *
 *  Data: 2021.11.20
 *  Description: receive data 1b by 1b.  
 */
module receiver(
  input                 clk_50m_i,
  input                 rst_n_i,
  input                 clken_i,
  output  reg   [7:0]   dout_8b_o,
  output  reg           dout_valid_o,
  input                 rx_i
);


parameter RX_STATE_START  = 2'b00;
parameter RX_STATE_DATA   = 2'b01;
parameter RX_STATE_STOP   = 2'b10;

reg [1:0] state;
reg [3:0] sample;
reg [3:0] bitpos;
reg [7:0] scratch;

integer i;
always @(posedge clk_50m_i or negedge rst_n_i) begin
  if (!rst_n_i) begin
    dout_valid_o      <= 1'b0;
    dout_8b_o         <= 8'b0;
    state             <= RX_STATE_START;
    bitpos            <= 3'b0;
    sample            <= 4'b0;
    scratch           <= 8'b0;
  end
  else begin
    dout_valid_o      <= 1'b0;
    if (clken_i) begin
      case (state)
        RX_STATE_START: begin
          /*
          * Start counting from the first low sample, once we've
          * sampled a full bit, start collecting data bits.
          */
          if (!rx_i || sample != 0)
            sample      <= sample + 4'b1;

          if (sample == 4'd15) begin
            state       <= RX_STATE_DATA;
            bitpos      <= 0;
            sample      <= 0;
            scratch     <= 0;
          end
        end
        RX_STATE_DATA: begin
          sample        <= sample + 4'b1;
          if (sample == 4'h8) begin
            for(i=0; i<8; i=i+1) begin
              if(i == bitpos[2:0])
                scratch[i] <= rx_i;
            end
            bitpos      <= bitpos + 4'b1;
          end
          if (bitpos == 4'd8 && sample == 4'd15)
            state       <= RX_STATE_STOP;
        end
        RX_STATE_STOP: begin
          /*
           * Our baud clock may not be running at exactly the
           * same rate as the transmitter.  If we thing that
           * we're at least half way into the stop bit, allow
           * transition into handling the next start bit.
           */
          if (sample == 4'd15 || (sample >= 4'd8 && !rx_i)) begin
            state         <= RX_STATE_START;
            dout_8b_o     <= scratch;
            dout_valid_o  <= 1'b1;
            sample        <= 0;
          end else begin
            sample        <= sample + 4'b1;
          end
        end
        default: begin
          state           <= RX_STATE_START;
        end
      endcase
    end
  end
end

endmodule
