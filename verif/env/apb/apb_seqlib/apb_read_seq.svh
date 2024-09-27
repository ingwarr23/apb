class apb_read_seq extends uvm_sequence#(apb_seq_item);
  `uvm_object_utils(apb_read_seq)

  rand bit [4:0] addr;
  
  rand int unsigned transfer_count;

  function new(string name = "apb_read_seq");
    super.new(name);
  endfunction: new


  virtual task body();
    apb_seq_item seq_item = apb_seq_item::type_id::create("apb_seq_item");
    start_item(seq_item);

    if (!seq_item.randomize() with { 
      write == 1;
      addr  == local::addr;
      go_to_idle == 0; 
    }) begin
      `uvm_fatal(get_name(), $sformatf("could not randomize apb_seq_item"))
    end
    finish_item(seq_item);
  endtask

endclass: apb_read_seq