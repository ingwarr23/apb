class apb_monitor extends uvm_monitor;
  `uvm_component_utils(apb_monitor)

  apb_config m_cfg;
  virtual apb_interface vif;

  function new(string name = "apb_monuitor", uvm_component parent = null);
    super.new(name, parent);

  endfunction: new


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    begin
      bit is_ok = uvm_config_db#(apb_config)::get(this, "", "cfg", m_cfg);
      if (!is_ok) `uvm_fatal(get_name(), $sformatf("could not retrieve cfg object"))
    end

    `uvm_info(get_name(), $sformatf("build_phase done"), UVM_LOW)
  endfunction: build_phase

endclass: apb_monitor