class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  
  apb_config m_cfg;

  apb_driver    m_driver;
  apb_sequencer m_sequencer;
  apb_monitor   m_monitor;


  function new(string name = "apb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    begin
      bit is_ok = uvm_config_db#(apb_config)::get(this, "", "config", m_cfg);
      if (!is_ok) `uvm_fatal(get_name(), $sformatf("could not retrieve cfg from db"))
    end
    
    if (get_is_active() == UVM_ACTIVE) begin
      m_driver    = apb_driver::type_id::create("apb_driver", this);
      m_sequencer = apb_sequencer::type_id::create("apb_sequencer", this);
    end
    m_monitor = apb_monitor::type_id::create("apb_monitor", this);

    uvm_config_db#(apb_config)::set(this, "*", "cfg", m_cfg);

    `uvm_info(get_name(), $sformatf("build_phase done"), UVM_LOW)
  endfunction


  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
  endfunction: connect_phase



endclass: apb_agent