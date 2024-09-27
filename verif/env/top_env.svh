class top_env extends uvm_env;
  `uvm_component_utils(top_env)

  top_env_config cfg;

  apb_agent m_apb_agent;

  apb_config m_apb_cfg;


  function new(string name = "top_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    begin
      bit env_cfg_ok = uvm_config_db#(top_env_config)::get(this, "", "top_env_config", cfg);
      if (!env_cfg_ok) `uvm_fatal(get_name(), $sformatf("could not retrieve config"))
    end

    m_apb_agent = apb_agent::type_id::create("apb_agent", this);
    m_apb_agent.is_active = cfg.m_apb_cfg.is_active;

    uvm_config_db#(apb_config)::set(this, m_apb_agent.get_name(), "config", cfg.m_apb_cfg);

    `uvm_info(get_name(), $sformatf("build phase ready"), UVM_LOW)
  endfunction: build_phase


endclass: top_env