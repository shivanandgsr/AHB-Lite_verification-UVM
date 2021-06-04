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

class AHB_virtual_sequencer extends uvm_sequencer;
	
	`uvm_component_utils(AHB_virtual_sequencer)
	
	AHB_sequencer sequencer;
	
	function new(string name = "AHB_virtual_sequencer", uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass
//-----------------------------------------------End of AHB_virtual_sequencer------------------------------------------------------