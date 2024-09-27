class apb_seq_item extends uvm_sequence_item;
  `uvm_object_utils(apb_seq_item)

  rand bit _dev_flag;
  
  rand bit [4:0] addr;
  rand bit [31:0] wdata;
  rand bit [31:0] rdata;
  rand bit write; // 1 - means WRITE operation, 0 - means READ operation
  
  rand bit go_to_idle;


  function new (string name = "apb_seq_item");
    super.new(name);


  endfunction: new

endclass: apb_seq_item