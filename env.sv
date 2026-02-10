
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "rx_agent.sv"

class  env extends uvm_env;

  `uvm_component_utils(env)
   agent agt;
   scoreboard sb;

  rx_agent rxagt ;
 // rx_monitor rxmon ;
 
  function new(string name = "env", uvm_component parent = null);

    super.new(name, parent);

  endfunction
  
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    agt =  agent::type_id::create("agt", this);
    sb =  scoreboard::type_id::create("sb", this);
    rxagt =  rx_agent::type_id::create("rxagt", this);
 
  endfunction
  
  function void connect_phase(uvm_phase phase);

    agt.mon.item_collect_port.connect(sb.item_collect_tx_export);
    rxagt.rxmon.item_collect_rxport.connect(sb.item_collect_rx_export);

  endfunction

endclass
