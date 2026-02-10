module uart_tx(
  input logic clk , rst ,tx_start ,
  input logic [7:0] din ,
  output logic tx ,tx_done , d_done ,
  //output logic [7:0] tx_buffer

);
 
  initial begin 
    d_done = 0 ;
  end

  typedef enum logic [1:0]{

    idle = 2'b00 , start = 2'b01 , data = 2'b10 , stop = 2'b11

  }state_t ;
  
  state_t state ;

  parameter int clk_freq = 50_000_000 ;  
  parameter int baud_rate = 9600  ;

  localparam int baud_tick = clk_freq / baud_rate ;

  // Internal registers
  logic [9:0] shift_reg;        
  logic [3:0] bit_cnt;          
  logic [12:0] baud_cnt;          

  always @(posedge clk) begin

  if (rst) begin

    state <= idle;

    tx <= 1'b1;
    tx_done <= 1'b0; 
    bit_cnt <= 4'b0;
    baud_cnt <= 13'b0;
    shift_reg <= 10'b0;

  end else begin

    case(state)

      idle: begin

        tx <= 1'b1;
        tx_done <= 1'b0;
        bit_cnt <= 4'b0;
        baud_cnt <= 13'b0;
        shift_reg <= 10'b0;

        if (tx_start) begin
          shift_reg <= {1'b1, din, 1'b0};
          state <= start;
        end
//$display("Time: %0t, tx_start = %b, tx_done = %b", $time, vif.tx_start, vif.tx_done);

      end

      start: begin

        tx = shift_reg[0];

        if (baud_cnt == baud_tick - 1) begin

          d_done = 1 ;

          shift_reg <= shift_reg >> 1;
          baud_cnt <= 13'b0;
          bit_cnt = 0 ;
          state <= data;

          @(posedge clk);
         d_done = 0 ;

        end else begin

          baud_cnt <= baud_cnt + 1;
          bit_cnt = 0 ;
        end

      end

      data: begin

        tx = shift_reg[0];

        if (baud_cnt == baud_tick - 1) begin
          
         d_done = 1 ; 

          shift_reg = shift_reg >> 1;    
          baud_cnt = 13'b0;
          bit_cnt = bit_cnt + 1;
          @(posedge clk);
         d_done = 0 ;
          if (bit_cnt == 8) begin
            state <= stop;
          end

        end else begin

          baud_cnt = baud_cnt + 1;

        end

      end

      stop: begin

        tx = shift_reg[0];
         
        if (baud_cnt == baud_tick - 1) begin

          d_done = 1 ;

          baud_cnt <= 13'b0;
          state <= idle;

          @(posedge clk);
         d_done = 0 ;

          tx_done <= 1'b1; 
        
        end else begin

          baud_cnt <= baud_cnt + 1;

        end

      end

      default: state <= idle;

    endcase

  end

end


endmodule

 