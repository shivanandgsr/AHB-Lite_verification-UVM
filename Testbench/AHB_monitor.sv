//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////

import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
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
    if(!uvm_config_db #(virtual AHB_interface)::get(this," ","vif",vintf))
		`uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name()));
  endfunction

  virtual task run_phase (uvm_phase phase);
      super.run_phase(phase);
	  phase.raise_objection(this);
	  packet_data = new();

    //forever
	repeat(70)
	begin
		`uvm_info(get_type_name(),"repeat loop enter in monitor",UVM_MEDIUM);
        fork
          store_in_data();
          collect_data();
        join_any
	end
	phase.drop_objection(this);
    endtask

    virtual task store_in_data();
	  `uvm_info(get_type_name(),"store_in_data in monitor",UVM_MEDIUM);
      @(vintf.monitor_cb);
	  `uvm_info(get_type_name(),"store_in_data in monitor after delay",UVM_MEDIUM);
      prev_HTRANS = HTRANS_TYPE'(vintf.HTRANS);
      prev_HSIZE  = HSIZE_TYPE'(vintf.HSIZE);
      prev_HBURST = HBURST_TYPE'(vintf.HBURST);
      prev_HWRITE = HWRITE_TYPE'(vintf.HWRITE);
      //prev_HWDATA = vintf.HWDATA;
      prev_HADDR  = vintf.HADDR;
      prev_HRESETn= vintf.HRESETn;
	  `uvm_info(get_type_name(),"store_in_data in monitor task end",UVM_MEDIUM);
    endtask

    virtual task collect_data();
	  `uvm_info(get_type_name(),"collect_data in monitor",UVM_MEDIUM);
      @(vintf.monitor_cb);
      @(vintf.monitor_cb);
	  `uvm_info(get_type_name(),"collect_data in monitor after delay",UVM_MEDIUM);
      packet_data.HTRANS = prev_HTRANS;
      packet_data.HSIZE  = prev_HSIZE;
      packet_data.HBURST = prev_HBURST;
      packet_data.HWRITE = prev_HWRITE;
      packet_data.HWDATA = prev_HWDATA;
      packet_data.HADDR  = prev_HADDR;
      packet_data.HRESETn = prev_HRESETn;
      packet_data.HWDATA = vintf.HWDATA;
      packet_data.HRDATA = vintf.HRDATA;
      packet_data.HRESP  = HRESP_TYPE'(vintf.HRESP);
	  `uvm_info(get_type_name(),"store_in_data in monitor before write function call",UVM_MEDIUM);
	  packet_data.print();
      monitor_data.write(packet_data);
	  `uvm_info(get_type_name(),"store_in_data in monitor task end",UVM_MEDIUM);
    endtask

endclass
