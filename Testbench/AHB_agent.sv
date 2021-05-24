
class AHB_agent extends uvm_agent;
  
	`uvm_component_utils(mem_agent)
  
	AHB_driver    	driver;
	AHB_sequencer 	sequencer;
	AHB_monitor_in  monitor_in;
	AHB_monitor_out	monitor_out;
 
	function new (string name = "AHB_agent",uvm_component parent=null");
		super.new(name,parent);
	endfunction
 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
 
		if(get_is_active() == UVM_ACTIVE) 
		begin
			driver = AHB_driver::type_id::create("driver",this);
			sequencer = AHB_sequencer::type_id::create("sequencer",this);
		end
 
		monitor_in 	= AHB_monitor_in::type_id::create("monitor_in",this);
		monitor_out = AHB_monitor_in::type_id::create("monitor_out",this);
	endfunction
 
	function void connect_phase(uvm_phase phase);
		if(get_is_active() == UVM_ACTIVE) 
			driver.seq_item_port.connect(sequencer.seq_item_export);
	endfunction
 
endclass