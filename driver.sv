class driver extends uvm_driver#(seq_item);

  `uvm_component_utils(driver)

  virtual inf vif;
 

  function new(string name = "driver", uvm_component parent = null);

    super.new(name, parent);
     
  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Interface not found in config DB");

  endfunction

  task run_phase(uvm_phase phase);

    forever begin
      seq_item req;

      seq_item_port.get_next_item(req);

      @(posedge vif.clk);
      vif.tx_start = req.tx_start;
      vif.din      = req.din;

      vif.exp_val = req.din ;

       
      @(posedge vif.clk);
      vif.tx_start = 0;
      //vif.rx = 1'b0 ;

      seq_item_port.item_done();
      #1 ;
      `uvm_info(get_type_name(), $sformatf("Driver sent din = %0d", req.din), UVM_LOW);

     
      @(posedge vif.rx_done);

      @(posedge vif.clk);

      //`uvm_info("DRV", "Transmission done", UVM_LOW);
 
    end
  endtask

endclass
