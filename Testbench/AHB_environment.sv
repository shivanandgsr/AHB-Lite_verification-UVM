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
class AHB_env extends uvm_env;

	`uvm_component_utils(AHB_env)

	AHB_agent      			agent;
	AHB_scoreboard 			scoreboard;
	AHB_virtual_sequencer 	vsequencer;
	AHB_coverage			coverage;

	function new(string name = "AHB_env",uvm_component parent=null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent 		= AHB_agent::type_id::create("agent",this);
		coverage 	= AHB_coverage::type_id::create("coverage",this);
		scoreboard  = AHB_scoreboard::type_id::create("scoreboard",this);
		vsequencer	= AHB_virtual_sequencer::type_id::create("vsequencer",this);
	endfunction

	function void connect_phase(uvm_phase phase);
		agent.monitor.monitor_data.connect(coverage.analysis_export);
		agent.monitor.monitor_data.connect(scoreboard.pkt_imp);
		vsequencer.sequencer = agent.sequencer;
	endfunction

endclass
