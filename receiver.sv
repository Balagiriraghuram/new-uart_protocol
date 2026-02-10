// Code your design here

module uart_rx(

  input logic clk , rst ,
  output logic [7:0] rx_data ,
  input logic rx ,
  output logic rx_done , rxd_done  

);
 
  parameter int freq   = 50_000_000;   // 50 MHz clock
  parameter int baud_rate  = 9600;

  localparam int baud_tick = freq / baud_rate;
  localparam int half_baud = baud_tick / 2;

  // FSM states
  typedef enum logic [1:0]{

    idle = 2'b00 , start = 2'b01 , data = 2'b10 , stop = 2'b11

  }state_rx ;

  state_rx state;

  // Internal signals
  logic [12:0] baud_cnt;      
  logic [2:0]  bit_cnt;      
  logic [7:0]  data_buf;     

   
  always @( posedge clk ) begin

    if (rst) begin

      state <= idle;
      

    end else begin

      rx_done <= 0;  

      case (state)

        idle: begin

          baud_cnt <= 0;
          bit_cnt  <= 0;
          rx_done <= 0 ;

          //$display("Time: %0t: ---------------OKAY----------------- , rx := %0d",$time , rx);
          if (rx == 0) begin  // Start bit detected (falling edge)

            state = start;
            baud_cnt <= 0;

          end
        end

        start: begin

          if (baud_cnt == baud_tick - 1) begin
            
            if (rx == 0) begin
              
              rxd_done = 1;

              state <= data;
              baud_cnt <= 0;
              bit_cnt <= 0;

               @(posedge clk);
              rxd_done = 0 ;

            end else begin
              state <= idle; 
            end
          end else begin
            baud_cnt <= baud_cnt + 1;
          end
        end

        data: begin

          if (baud_cnt == baud_tick - 1) begin

            rxd_done = 1 ;

            baud_cnt <= 0;
            data_buf[bit_cnt] <= rx;  // Sample the bit
            //$display("Time: %0t: ---------------OKAY----------------- , rx := %p",$time , rx);
             @(posedge clk);
             rxd_done = 0 ;

            if (bit_cnt == 7) begin
              state <= stop;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end else begin
            baud_cnt <= baud_cnt + 1;
          end
        end

        stop: begin

          if (baud_cnt == baud_tick - 1) begin

            rxd_done = 1 ;

            if (rx == 1) begin
              rx_data <= data_buf;
              rx_done <= 1;
            end

             @(posedge clk);
            rxd_done = 0 ;

            //display("Time: %0t: ---------------OKAY----------------- , rx := %p",$time , data_buf);

            baud_cnt <= 0;
            state <= idle;

          end else begin
            baud_cnt <= baud_cnt + 1;
          end

        end

        default: state <= idle;

      endcase
    end
  end

endmodule