class AHB_monitor extends uvm_monitor;

  `uvm_component_utils(AHB_monitor)

  uvm_analysis_port #(AHB_packet) monitor_data;

  virtual AHB_interface.monitor_cb vintf;
  env_config env_config_h;


  function new (string name = "AHB_monitor",uvm_component parent = null);
    super.new (name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor_data = new("monitor_data", this);
    if(! uvm_config_db #(virtual AHB_interface) :: get (this, "","configuration",env_config_h))
      `uvm_fatal("ERROR IN MONITOR IN INTERFACE")
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vintf = env_config_h.vintf;
  endfunction

  virtual task run_phase (uvm_phase phase)
    AHB_packet packet_data = AHB_packet :: type_id :: create ("packet_data",this);

    forever
        fork
          store_in_data();
          collect_data();
        join_any

    endtask

    virtual task store_in_data();
      @(vintf.monitor_cb);
      prev_HTRANS = vintf.HTRANS;
      prev_HSIZE  = vintf.HSIZE;
      prev_HBURST = vintf.HBURST;
      prev_HWRITE = vintf.HWRITE;
      prev_HWDATA = vintf.HWDATA;
      prev_HADDR  = vintf.HADDR;
      prev_HRESETn= vintf.HRESETn;

    endtask

    virtual task collect_data();
      @(vintf.monitor_cb);
      @(vintf.monitor_cb);
      packet_data.HTRANS = prev_HTRANS
      packet_data.HSIZE  = prev_HSIZE;
      packet_data.HBURST = prev_HBURST;
      packet_data.HWRITE = prev_HWRITE;
      packet_data.HWDATA = prev_HWDATA;
      packet_data.HADDR  = prev_HADDR;
      packet_data.HRESETn = prev_HRESETn;
      packet_data.HRDATA = vintf.HRDATA;
      packet_data.HRESP  = vintf.HRESP;

      monitor_data.write (packet_data);
    endtask

endclass
