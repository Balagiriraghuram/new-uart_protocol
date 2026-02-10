// Code your design here

`timescale 1ns / 1ns

`include "transmitter.sv"
`include "receiver.sv"

module top(

input logic clk , rst ,tx_start ,
  input logic [7:0] din ,
  output logic tx ,tx_done , d_done ,
  output logic rx ,
  output logic [7:0] rx_data , 
  output logic rx_done , rxd_done 

);
 
   uart_tx dut (
    .clk(clk),
    .rst(rst),
     .tx_start(tx_start),
     .din(din),
     .tx(tx),
     .tx_done(tx_done), 
     .d_done(d_done)
  );

 // assign rx = tx;

   logic temp ;

  always @(posedge d_done) begin

    temp = tx ;

    //$display("rx = %0d",rx);

  end

  assign rx = temp ;
  
  uart_rx dut1(
    .clk(clk),
    .rst(rst),
    .rx_data(rx_data),
    .rx(rx),
    .rx_done(rx_done),
    .rxd_done(rxd_done)
  );

endmodule 
 