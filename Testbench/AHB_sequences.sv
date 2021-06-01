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
class AHB_base_sequence extends uvm_sequence #(AHB_sequence_item) ;

	`uvm_object_utils(AHB_base_sequence)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "AHB_base_sequence");
		super.new(name);
	endfunction

	task dseq(AHB_sequence_item pkt,HBURST_TYPE HBURST,HSIZE_TYPE HSIZE,HWRITE_TYPE HWRITE,bit [ADDRWIDTH-1:0] ADDRESS);
		start_item(pkt);
		if(HBURST == INCR)
			assert(pkt.randomize() with {pkt.HBURST == HBURST;pkt.HSIZE == HSIZE;pkt.HWRITE == HWRITE ;pkt.HADDR[0] == ADDRESS;})
			begin
				`uvm_info(get_type_name(),$sformatf("After randomization %p",pkt),UVM_MEDIUM);
			end
			else
			begin
				`uvm_info(get_type_name(),$sformatf("Randomization Failed HBURST = %s ,HSIZE = %s ,HWRITE = %s",HBURST.name,HSIZE.name,HWRITE.name),UVM_MEDIUM);
			end
		else
			assert(pkt.randomize() with {pkt.HBURST == HBURST; pkt.HSIZE == HSIZE; pkt.HWRITE == HWRITE;pkt.HADDR[0] == ADDRESS;pkt.HADDR.size == 5;})
			begin
				`uvm_info(get_type_name(),$sformatf("After randomization %p",pkt),UVM_MEDIUM);
			end
			else
			begin
				`uvm_info(get_type_name(),$sformatf("Randomization Failed HBURST = %s ,HSIZE = %s ,HWRITE = %s",HBURST.name,HSIZE.name,HWRITE.name),UVM_MEDIUM);
			end
			finish_item(pkt);
	endtask

	task genRWseq(AHB_sequence_item pkt,HBURST_TYPE HBURST);
		/*//
		// HSIZE == BYTE
		//
		// slave 0
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'hfff});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd0,10'hfff});


		// slave1
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd1});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd1,10'hfff});
		dseq(pkt,HBURST,BYTE,READ ,{21'd0,1'd1,10'hfff});
		//
		// HSIZE = HALFWORD
		//
		// slave 0
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd0,10'hfff});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd0,10'hfff});

		// slave 1
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'd2});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,HALFWORD,WRITE,{21'd0,1'd1,10'hfff});
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'hfff});*/
		//
		// HSIZE = WORD
		//
		// slave 0
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd4});
		/*dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'hfff});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'hfff});

		// slave 1
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd1,10'hfff});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'hfff});*/
	endtask
endclass

class sequence_SINGLE_burst  extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_SINGLE_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_SINGLE_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,SINGLE);
	endtask
endclass

class sequence_INCR_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,INCR);
	endtask
endclass

class sequence_INCR4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR4_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR4_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,INCR4);
	endtask
endclass

class sequence_INCR8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR8_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR8_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,INCR8);
	endtask
endclass

class sequence_INCR16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR16_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR16_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,INCR16);

	endtask
endclass

class sequence_WRAP4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP4_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_WRAP4_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,WRAP4);

	endtask
endclass

class sequence_WRAP8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP8_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_WRAP8_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,WRAP8);
	endtask
endclass

class sequence_WRAP16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP16_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_WRAP16_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		genRWseq(req,WRAP16);
	endtask
endclass
