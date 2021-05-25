import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class AHB_virtual_sequencer extends uvm_sequencer;

	`uvm_component_utils(AHB_virtual_sequencer)
	
	function new(string name = "AHB_virtual_sequencer", string parent = "uvm_component");
		super.new(name,parent);
	endfunction
	
endclass