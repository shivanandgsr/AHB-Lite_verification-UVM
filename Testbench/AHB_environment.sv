
class AHB_env extends uvm_env;
   
	`uvm_component_utils(AHB_env)
	
	AHB_agent      agent;
	AHB_scoreboard scoreboard;
	AHB_virtual_sequencer vsequencer;
   
	function new(string name = "AHB_env",uvm_component parent=null);
		super.new(name, parent);
	endfunction 
 
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent 		= AHB_agent::type_id::create("agent",this);
		scoreboard  = AHB_scoreboard::type_id::create("scoreboard",this);
		vsequencer	= AHB_virtual_sequencer::type_id::create("vsequencer",this);
	endfunction
  
   // remember to add decl macros in scoreboard
  
	function void connect_phase(uvm_phase phase);
		agent.monitor_in.analysis_port.connect(scoreboard.analysis_imp_in);
		agent.monitor_out.analysis_port.connect(scoreboard.analysis_imp_out);
	endfunction
 
endclass 