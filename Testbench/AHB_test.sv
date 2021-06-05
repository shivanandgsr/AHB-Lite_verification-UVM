//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Hiranmaye Sarpana Chandu                   //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////

import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class AHB_test extends uvm_test;

  `uvm_component_utils(AHB_test) // register with uvm_factory

	AHB_env env;
	AHB_virtual_sequence  vseq; // virtual sequence
 
	function new(string name = "AHB_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env  = AHB_env::type_id::create("env",this);		 // create or get environment object from uvm_factory
		vseq = AHB_virtual_sequence::type_id::create("vseq");// create or get virtual sequence object from uvm_factory
	endfunction
	
	
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		
		vseq.start(env.vsequencer); // initiate or start the virtual sequence
		
		phase.drop_objection(this);
	endtask

endclass

//----------------------------------------------End of AHB_test--------------------------------------------------------------