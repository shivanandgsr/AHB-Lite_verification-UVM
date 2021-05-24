class AHB_monitor_in extends uvm_moniotr;

  `uvm_component_utils(AHB_monitor_in)

  uvm_analysis_port #(AHB_sequence_item) monitor_in_data;

  virtual AHB_interface.monitor_in_cb vintf;
  env_config env_config_h;


  function new (string name = "AHB_monitor_in",uvm_component parent = null);
    super.new (name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor_in_data = new("monitor_in_data", this);
    if(! uvm_config_db #(virtual AHB_interface) :: get (this, "","configuration",env_config_h))
      `uvm_fatal("ERROR IN MONITOR IN INTERFACE")
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vintf = env_config_h.vintf;
  endfunction

  virtual task run_phase (uvm_phase phase)
    AHB_sequence_item seq_item_data = AHB_sequence_item :: type_id :: create ("seq_item_data",this);

    forever
      begin
        @(vintf.monitor_in_cb);
        seq_item_data.HTRANS = vintf.HTRANS;
        seq_item_data.HSIZE  = vintf.HSIZE;
        seq_item_data.HBURST = vintf.HBURST;
        seq_item_data.HWRITE = vintf.HWRITE;
        seq_item_data.HWDATA = vintf.HWDATA;
        seq_item_data.HADDR  = vintf.HADDR;
        seq_item_data.HRESETn = vintf.HRESETn;

        monitor_in_data.write (seq_item_data);
      end
    endtask

endclass
