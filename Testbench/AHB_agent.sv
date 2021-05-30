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
class AHB_agent extends uvm_agent;

	`uvm_component_utils(AHB_agent)

	AHB_driver    driver;
	AHB_monitor	  monitor;
	uvm_sequencer #(AHB_sequence_item) sequencer;

	function new (string name = "AHB_agent",uvm_component parent = null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		if(get_is_active() == UVM_ACTIVE)
		begin
			driver 	  = AHB_driver::type_id::create("driver",this);
			sequencer = uvm_sequencer #(AHB_sequence_item)::type_id::create("sequencer",this);
		end

		monitor	= AHB_monitor::type_id::create("monitor",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE)
			driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction

endclass
