import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "AHB_sequence_item.sv"

class AHB_base_sequence extends uvm_sequence #(AHB_sequence_item) ;

	`uvm_object_utils(AHB_base_sequence)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "AHB_base_sequence");
		super.new(name);
	endfunction
	
	function void dseq(ref AHB_sequence_item pkt,HBURST_TYPE HBURST,HSIZE_TYPE HSIZE,HWRITE_TYPE HWRITE,bit [ADDRWIDTH-1:0] ADDRESS,int ADDRSIZE);
		start_item(pkt);
		if(HBURST == INCR)
			assert(req.randomize() with {pkt.HBURST == HBURST && pkt.HSIZE == HSIZE && pkt.HWRITE == HWRITE && pkt.HADDR[0] == ADDRESS;})
			else
				uvm_info(get_type_name(),$sformatf("Randomization Failed HBURST = %s ,HSIZE = %s ,HWRITE = %s",HBURST.name,HSIZE.name,HWRITE.name),UVM_MEDIUM);
		else
			assert(req.randomize() with {pkt.HBURST == HBURST && pkt.HSIZE == HSIZE && pkt.HWRITE == HWRITE && pkt.HADDR[0] == ADDRESS && pkt.HADDR.size == ADDRSIZE;})
			else
				uvm_info(get_type_name(),$sformatf("Randomization Failed HBURST = %s ,HSIZE = %s ,HWRITE = %s",HBURST.name,HSIZE.name,HWRITE.name),UVM_MEDIUM);
		finish_item(pkt);
	endfunction
endclass

class sequence_SINGLE_burst  extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_SINGLE_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_SINGLE_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,SINGLE,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,SINGLE,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,SINGLE,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,SINGLE,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,SINGLE,WORD,WRITE,{21'd0,1'd1,10'd0});
		
		
	endtask
endclass

class sequence_INCR_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd0,10'd0});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd0,10'd2});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd0,10'd0});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd1,10'd0});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd1,10'd2});
		dseq(req,INCR,HALFWORD,READ	,{21'd0,1'd1,10'd0});
		dseq(req,INCR,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,INCR,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR,WORD,WRITE,{21'd0,1'd1,10'd0});
	endtask
endclass

class sequence_INCR4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR4_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR4_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR4,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR4,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,INCR4,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR4,WORD,WRITE,{21'd0,1'd1,10'd0});
		
	endtask
endclass

class sequence_INCR8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR8_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR8_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR8,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,INCR8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR8,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,INCR8,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR8,WORD,WRITE,{21'd0,1'd1,10'd0});
		
	endtask
endclass

class sequence_INCR16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR16_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_INCR16_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,INCR16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,INCR16,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,INCR16,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,INCR16,WORD,WRITE,{21'd0,1'd1,10'd0});
		
	endtask
endclass

class sequence_WRAP4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP4_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP4_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP4,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP4,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP4,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,WRAP4,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP4,WORD,WRITE,{21'd0,1'd1,10'd0});
			
	endtask
endclass

class sequence_WRAP8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP8_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP8_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP8,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP8,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP8,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,WRAP8,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP8,WORD,WRITE,{21'd0,1'd1,10'd0});
	endtask
endclass

class sequence_WRAP16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP16_burst)
	`uvm_declare_p_sequencer(uvm_sequencer #(AHB_sequence_item))
	
	function new(string name = "sequence_WRAP16_burst");
		super.new(name);
	endfunction
	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		//
		// HSIZE == BYTE
		//
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd0,10'd1});
		
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP16,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(req,WRAP16,BYTE,WRITE,{21'd0,1'd1,10'd1});
		//
		// HSIZE = HALFWORD
		//
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(req,WRAP16,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		//
		// HSIZE = WORD
		//
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd0,10'd0});
		
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(req,WRAP16,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(req,WRAP16,WORD,WRITE,{21'd0,1'd1,10'd0});
		
	endtask
endclass