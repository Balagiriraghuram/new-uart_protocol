

class rx_monitor extends uvm_monitor ;

  `uvm_component_utils(rx_monitor);

  virtual inf vif ; 

  uvm_analysis_port#(seq_item) item_collect_rxport ;

  function new(string name = "rx_monitor" , uvm_component parent = null);

    super.new(name,parent); 
    item_collect_rxport = new("item_collect_rxport",this);

  endfunction

  function void  build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this,"","vif",vif))
      `uvm_fatal("monitor class ", "interface not found in db");

  endfunction

  bit [9:0] rx_frame ;

  task run_phase(uvm_phase phase);

    seq_item tx ;

    forever begin

      tx = seq_item::type_id::create("rx_tx") ;

      for(int i = 0 ; i < 10 ; i++)begin
        //$display("------------YES  x = %0d ",vif.rxd_done);
        @(posedge vif.rxd_done )
        rx_frame[i] = vif.rx  ; 
       // $display("------------Okay"); 
        
      end

    //  wait (vif.tx_done == 1);

      tx.tx_start = vif.tx_start ; 
      tx.rx_data = rx_frame[8:1] ;
      tx.tx_done = vif.rx_done ;

      `uvm_info(get_type_name,$sformatf("Succesfully received : and they are din = %0d , din = %b , din_with_start and stop bits = %b ",tx.rx_data , tx.rx_data , rx_frame), UVM_MEDIUM);
     // end
    item_collect_rxport.write(tx);
 
 $display("----------------------------------------------------------------------------------------------------------");
    end

  endtask

endclass