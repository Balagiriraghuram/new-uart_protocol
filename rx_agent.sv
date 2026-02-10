

class rx_agent extends uvm_agent ;

  `uvm_component_utils(rx_agent);
 
  rx_monitor rxmon;

  function new(string name = "rx_agent" , uvm_component parent = null);

    super.new(name , parent );

  endfunction


  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    rxmon = rx_monitor :: type_id :: create("rxmon" , this) ;

  endfunction
 

endclass
