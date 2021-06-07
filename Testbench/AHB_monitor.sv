//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Sri Harsha Doppalapudi                     //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////

import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class AHB_monitor extends uvm_monitor;

	`uvm_component_utils(AHB_monitor) // register with uvm_factory

	uvm_analysis_port #(AHB_packet) monitor_data; // analysis port to broadcast data collected from DUT

	virtual AHB_interface.monitor_cb vintf; // virtual interface handle
	AHB_packet packet_data; 

	HTRANS_TYPE prev_HTRANS;
	HBURST_TYPE prev_HBURST;
	HSIZE_TYPE	prev_HSIZE;
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
		if(!uvm_config_db #(virtual AHB_interface)::get(this," ","vif",vintf)) // get the interface from config_db
			`uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name()));
	endfunction

	virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			packet_data = new();
			forever
			begin
				fork
					collect_data();
				join_any
			end
		join_none
		phase.drop_objection(this);
	endtask

    virtual task collect_data();
      
		@(vintf.monitor_cb);
	 
		packet_data.HTRANS = HTRANS_TYPE'(vintf.HTRANS);
		packet_data.HSIZE  = HSIZE_TYPE'(vintf.HSIZE);
		packet_data.HBURST = HBURST_TYPE'(vintf.HBURST);
		packet_data.HWRITE = HWRITE_TYPE'(vintf.HWRITE);
		packet_data.HADDR  = vintf.HADDR;
		packet_data.HRESETn = vintf.HRESETn;
		packet_data.HWDATA = vintf.HWDATA;
		packet_data.HRDATA = vintf.HRDATA;
		packet_data.HRESP  = HRESP_TYPE'(vintf.HRESP);
	 
		monitor_data.write(packet_data);
    endtask

endclass

//----------------------------------------------End of AHB_monitor----------------------------------------------------