
class AHB_virtual_sequencer extends uvm_sequencer;

	`uvm_component_utilis(AHB_virtual_sequencer)
	
	function new(string name = "AHB_virtual_sequencer", string parent = "uvm_component");
		super.new(name,parent);
	endfunction
	
endclass