import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "AHB_packet.sv"
class AHB_monitor extends uvm_monitor;

  `uvm_component_utils(AHB_monitor)

  uvm_analysis_port #(AHB_packet) monitor_data;

  virtual AHB_interface.monitor_cb vintf;
  AHB_packet packet_data;
  
  HTRANS_TYPE prev_HTRANS;
  HBURST_TYPE prev_HBURST;
  HSIZE_TYPE prev_HSIZE;
  HWRITE_TYPE prev_HWRITE;
  logic [ADDRWIDTH-1:0] prev_HADDR;
  logic [DATAWIDTH-1:0] prev_HWDATA;
  logic prev_HRESETn;

  function new (string name = "AHB_monitor",uvm_component parent = null);
    super.new (name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor_data = new("monitor_data", this);
    if(!uvm_config_db #(virtual AHB_Interface)::get(this,"","vintf",vintf))
                        `uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name()));
  endfunction

  virtual task run_phase (uvm_phase phase);
      packet_data = new();

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
      packet_data.HTRANS = prev_HTRANS;
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
