
class scoreboard extends uvm_scoreboard ;

  `uvm_component_utils(scoreboard);

  virtual inf vif ;

  //bit [7:0] golden[$];
   

  uvm_analysis_imp#(seq_item, scoreboard) item_collect_tx_export;
  uvm_analysis_imp#(seq_item, scoreboard) item_collect_rx_export;

  function new(string name = "scoreboard" , uvm_component parent = null);

    super.new( name, parent);
    item_collect_tx_export = new("item_collect_tx_export",this  );
    item_collect_rx_export = new("item_collect_rx_export",this );

  endfunction
 
  function void  build_phase(uvm_phase phase);

    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this,"","vif",vif))
      `uvm_fatal("monitor class ", "interface not found in db");

  endfunction

 function void write(seq_item tx);
   
   $display("----------------------------------------------------------------------------------------------------------");

   if(tx.din != 0 ) begin

     if (tx.din == vif.exp_val) begin

       `uvm_info("scoreboard", $sformatf("TX Transaction successful: din = %0d, exp_value = %0d", tx.din, vif.exp_val), UVM_LOW);

     end else begin

       `uvm_error("SCOREBOARD", $sformatf("TX UNMATCHED: din = %0d, exp_value = %0d", tx.din, vif.exp_val));

     end

   end

   if(tx.rx_data != 0 ) begin

     if (tx.rx_data == vif.exp_val) begin

       `uvm_info("scoreboard", $sformatf("RX Transaction successful: rx_data = %0d, exp_value = %0d", tx.rx_data, vif.exp_val), UVM_LOW);

     end else begin

       `uvm_error("SCOREBOARD", $sformatf("RX UNMATCHED: rx_data = %0d, exp_value = %0d", tx.rx_data, vif.exp_val));

     end

   end

   $display("----------------------------------------------------------------------------------------------------------");

endfunction
  

endclass