class apb_config extends uvm_object;
  `uvm_object_utils(apb_config)

  virtual apb_interface vif;
  uvm_active_passive_enum is_active = UVM_ACTIVE;


  function new(string name = "apb_config");
    super.new(name);
  endfunction: new

endclass: apb_config