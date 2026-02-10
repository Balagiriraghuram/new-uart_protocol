
class monitor extends uvm_monitor ;

  `uvm_component_utils(monitor);

  virtual inf vif ;

  uvm_analysis_port#(seq_item) item_collect_port ;

  function new(string name = "monitor" , uvm_component parent = null);

    super.new(name,parent);
    item_collect_port = new("item_collect_port",this);

  endfunction

  function void  build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this,"","vif",vif))
      `uvm_fatal("monitor class ", "interface not found in db");

  endfunction

  bit [9:0] frame ;

  task run_phase(uvm_phase phase);

    seq_item tx ;

    forever begin

      tx = seq_item::type_id::create("tx") ;

      for(int i = 0 ; i < 10 ; i++)begin
       
        //`uvm_info(get_type_name,$sformatf("------------------- OKAY ---------------" ), UVM_MEDIUM);

        @ (posedge vif.d_done );
        frame[i] = vif.tx ;
        //vif.rx = vif.tx ;
        //`uvm_info(get_type_name,$sformatf("------------------- YES ---------------" ), UVM_MEDIUM);
      end

      wait (vif.tx_done == 1);

      tx.tx_start = vif.tx_start ; 
      tx.din = frame[8:1] ;
      tx.tx_done = vif.tx_done ;

      `uvm_info(get_type_name,$sformatf(" Values generate in  din = %0d , din = %b , din_with_start and stop bits = %b ",tx.din , tx.din , frame), UVM_MEDIUM);
     // end
    item_collect_port.write(tx);

    end

  endtask

endclass