interface inf(input logic clk );

  logic rst, tx_start;
  logic [7:0] din;
  logic tx, tx_done , d_done ;

  logic [7:0] exp_val ;//, act_val  ;

  logic rx;
  logic [7:0] rx_data;
  logic rx_done , rxd_done ;

endinterface