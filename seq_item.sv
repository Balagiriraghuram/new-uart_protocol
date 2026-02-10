

class seq_item extends uvm_sequence_item ;

  `uvm_object_utils(seq_item);
  
  rand bit tx_start ;
  rand bit [7:0] din ;

  bit [7:0] rx_data ;
  bit tx , tx_done ;
 

  function new(string name = "seq item");

    super.new(name);

  endfunction
 
  constraint variables { tx_start == 1 ;}

endclass