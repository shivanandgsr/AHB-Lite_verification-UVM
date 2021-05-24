
class AHB_driver #(AHB_sequence_item) extends uvm_driver;

	`uvm_component_utils(AHB_driver)
	
	function new(string name = "AHB_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
endclass
