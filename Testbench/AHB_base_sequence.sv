
class AHB_base_sequence extends uvm_sequence #(AHB_sequence_item);

	`uvm_object_utilis(AHB_base_sequence)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "AHB_base_sequence");
		super.new(name);
	endfunction
	
endclass

class sequence_SINGLE_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_SINGLE_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_SINGLE_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == SINGLE;});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_INCR_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_INCR_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == INCR && ADDRESS.size == 5;});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_INCR4_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_INCR4_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR4_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == INCR4});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_INCR8_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_INCR8_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR8_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == INCR8});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_INCR16_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_INCR16_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR16_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == INCR16});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_WRAP4_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_WRAP4_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP4_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == WRAP4});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_WRAP8_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_WRAP8_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP8_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == WRAP8});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass

class sequence_WRAP16_burst extends AHB_base_sequence #(AHB_sequence_item);

	`uvm_object_utilis(sequence_WRAP16_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP16_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		repeat(5)
		begin
			start_item(req);
			assert(req.randomize() with {HBURST == WRAP4});
			else
				uvm_info(get_type_name(),"Randomization Failed",UVM_MEDIUM);
			finish_item(req);
		end		
	endtask
endclass
