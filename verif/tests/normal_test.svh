class normal_test extends uvm_test;
  `uvm_component_utils(normal_test)
  
  apb_config m_apb_cfg; 
  top_env_config m_env_cfg;
  top_env m_env;
  // adder_4_bit_environment     env;
  // adder_4_bit_basic_seq       seq;

  virtual apb_interface apb_vif;

  function new (string name = "normal_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    m_apb_cfg = apb_config::type_id::create("m_apb_cfg");

    m_env_cfg = top_env_config::type_id::create("m_env_cfg");

    m_env = top_env::type_id::create("m_env", this);

    begin
      bit apb_vif_ok = uvm_config_db#(virtual apb_interface)::get(this, "", "apb_if", m_apb_cfg.vif);
      if (!apb_vif_ok) `uvm_fatal(get_name(), $sformatf("could not retrieve APB interface"))
    end

    customize_apb_cfg(m_apb_cfg);

    m_env_cfg.m_apb_cfg = m_apb_cfg;

    uvm_config_db#(top_env_config)::set(this, m_env.get_name(), "top_env_config", m_env_cfg);
  endfunction: build_phase


  task run_phase(uvm_phase phase);
    base_seq top_seq;

    super.run_phase(phase);
    phase.raise_objection(this);
    
    `uvm_info(get_name(), $sformatf("START TEST"), UVM_LOW)
    
    top_seq = base_seq::type_id::create("top_seq");
    if (!top_seq.randomize()) begin
      `uvm_fatal(get_name(), $sformatf("could not randomize top_seq"))
    end
    top_seq.start(m_env.m_apb_agent.m_sequencer);

    `uvm_info(get_name(), $sformatf("END TEST"), UVM_LOW)

    phase.drop_objection(this);
  endtask: run_phase


  virtual function void customize_apb_cfg(apb_config cfg);
    cfg.is_active = UVM_ACTIVE;
  endfunction: customize_apb_cfg
 
endclass: normal_test