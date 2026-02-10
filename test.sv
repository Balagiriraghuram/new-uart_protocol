`include "seq_item.sv"
`include "sequence.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "rx_monitor.sv"       
//`include "rx_agent.sv"
`include "scoreboard.sv"
`include "agent.sv"
`include "env.sv"   


class test extends uvm_test;

  env env_o;
  seq bseq;

  `uvm_component_utils(test)
  
  function new(string name = "test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);

  endfunction
  
  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    bseq = seq::type_id::create("bseq");
        
    repeat(30) begin 
       bseq.start(env_o.agt.seqr);
    end

    //finish_item(bseq);
    
    phase.drop_objection(this);

    `uvm_info(get_type_name, "End of testcase", UVM_LOW);

  endtask

endclass
