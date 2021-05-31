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
class AHB_sequencer extends uvm_sequencer #(AHB_sequence_item);
	
	`uvm_component_utils(AHB_sequencer)
	
	function new(string name = "AHB_sequencer", uvm_component parent=null);
		super.new(name,parent);
	endfunction

endclass