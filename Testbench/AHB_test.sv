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

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "AHB_environment.sv"
`include "AHB_virtual_sequence.sv"

class AHB_test extends uvm_test;
 
  `uvm_component_utils(AHB_test)
 
	AHB_env env;
	AHB_virtual_sequence  vseq;
 
	function new(string name = "AHB_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction : new
 
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
 
		env  = AHB_env::type_id::create("env",this);
		vseq = AHB_virtual_sequence::type_id::create("vseq");
	
	endfunction
 
	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		
		vseq.start(env.vsequencer);
		
		phase.drop_objection(this);
	endtask
 
endclass