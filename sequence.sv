
class seq extends uvm_sequence#(seq_item);

  `uvm_object_utils(seq);
   

  function new(string name = "seq");

    super.new(name);

  endfunction
 
  task body();

  req = seq_item::type_id::create("req");

  start_item(req);
   
  if (!req.randomize()) begin
    `uvm_error("SEQ", "Randomization failed")
  end

  finish_item(req);

  `uvm_info("sequence ====>", $sformatf("Values generated in din = %0d", req.din), UVM_MEDIUM);

endtask



endclass