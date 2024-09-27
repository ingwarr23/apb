class base_seq extends uvm_sequence#(uvm_sequence_item);
  `uvm_object_utils(base_seq)

  function new(string name = "base_seq");
    super.new(name);
  endfunction: new

  virtual task body();
    apb_read_seq m_apb_read_seq;
    m_apb_read_seq = apb_read_seq::type_id::create("apb_read_seq");
    repeat (4) begin
      if (!m_apb_read_seq.randomize()) begin
        `uvm_fatal(get_name(), $sformatf("could not randomize m_apb_read_seq"))
      end

      m_apb_read_seq.start(super.get_sequencer());
    end
    #100ns;

  endtask

endclass: base_seq