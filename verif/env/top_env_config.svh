class top_env_config extends uvm_object;
  `uvm_object_utils(top_env_config)

  apb_config m_apb_cfg;

  function new(string name = "top_env_config");
    super.new(name);
  endfunction: new



endclass: top_env_config