// Code your testbench here
// or browse Examples

`timescale 1ns / 1ns

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "test.sv"

module tb ;

  bit clk ;

  inf vif(clk);

//   uart_tx dut (
//     .clk(clk),
//     .rst(vif.rst),
//     .tx_start(vif.tx_start),
//     .din(vif.din),
//     .tx(vif.tx),
//     .tx_done(vif.tx_done),
//     //.tx_buffer(vif.act_val),
//     .d_done(vif.d_done)
//   );

//    uart_rx dut1(
//     .clk(clk),
//     .rst(vif.rst),
//     .rx_data(vif.rx_data),
//     .rx(vif.rx),
//      .rx_done(vif.rx_done),
//      .rxd_done(vif.rxd_done)
//   );

  top uart(

    .clk(clk),
    .rst(vif.rst),
    .tx_start(vif.tx_start),
    .din(vif.din),
    .tx(vif.tx),
    .tx_done(vif.tx_done),
    //.tx_buffer(vif.act_val),
    .d_done(vif.d_done),

    .rx_data(vif.rx_data),
    .rx(vif.rx),
     .rx_done(vif.rx_done),
     .rxd_done(vif.rxd_done)
    

  );
   
  

  initial clk = 0;
  always #10 clk = ~clk;  

  initial begin
    $dumpfile("uart_tx.vcd");
    $dumpvars(0);
  end
 
  initial begin 

    uvm_config_db#(virtual inf)::set(null, "*", "vif", vif);
 
    run_test("test");

  end

endmodule
