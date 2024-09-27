class apb_driver extends uvm_driver#(apb_seq_item);
  `uvm_component_utils(apb_driver)

  apb_config m_cfg;
  virtual apb_interface vif;

  function new(string name = "apb_driver", uvm_component parent);
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


  virtual function void connect_phase(uvm_phase phase);
    vif = m_cfg.vif;
  endfunction: connect_phase


  virtual task run_phase(uvm_phase phase);
    init();
    
    forever begin
      seq_item_port.get_next_item(req);

      drive_item(req);

      seq_item_port.item_done();
    end
  endtask: run_phase


  virtual task init();
    wait (!vif.prst);
    @(vif.drv_blk);
  endtask: init


  virtual task drive_item(apb_seq_item item);
    // the SETUP phase:
    @(vif.drv_blk);
    vif.drv_blk.pselx   <= 1;
    vif.drv_blk.penable <= 0;
    vif.drv_blk.pwrite  <= item.write;
    vif.drv_blk.paddr   <= item.addr;
    vif.drv_blk.pwdata  <= item.wdata;

    // the ACCESS phase:
    @(vif.drv_blk);
    vif.drv_blk.penable <= 1;
    
    while (!vif.drv_blk.pready) @(vif.drv_blk);
    
    // the END of transfer:
    vif.drv_blk.penable   <= 0;
    vif.drv_blk.pselx     <= 0;
    vif.drv_blk.pwrite    <= 0;
  endtask: drive_item


endclass: apb_driver