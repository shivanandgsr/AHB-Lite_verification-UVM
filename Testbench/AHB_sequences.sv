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

	HWRITE_TYPE hwrite[];
	bit [9:0] ADDRESS[];
	
	function new(string name = "AHB_base_sequence");
		super.new(name);
		this.hwrite = new[24];
		this.ADDRESS= new[24];
		this.hwrite = '{WRITE,READ,WRITE,WRITE,READ,READ,WRITE,WRITE,READ,WRITE,READ,WRITE,WRITE,WRITE,READ,WRITE,READ,READ,READ,WRITE,READ,WRITE,WRITE,READ,WRITE,READ};
		this.ADDRESS= '{10'd0,10'd0,10'd4,10'd0,10'd4,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd4,10'd0,10'd4,10'd4,10'd0,10'd4,10'd0,10'd4,10'd0,10'd4,10'd0,10'hffc,10'hffc};
	endfunction

	/*task dseq(AHB_sequence_item pkt,HBURST_TYPE HBURST,HSIZE_TYPE HSIZE,HWRITE_TYPE HWRITE,bit [ADDRWIDTH-1:0] ADDRESS);
		$display("HBURST = %s",HBURST.name());
		start_item(pkt);
		
			assert(pkt.randomize() with {HBURST == HBURST  && HWRITE == HWRITE && HADDR[0] == ADDRESS;})
			//begin
				//pkt.print();
				//`uvm_info(get_type_name(),$sformatf("%s",pkt.convert2string()),UVM_MEDIUM);
			//end
			else
			begin
				`uvm_info(get_type_name(),$sformatf("Randomization Failed HBURST = %s ,HSIZE = %s ,HWRITE = %s",HBURST.name,HSIZE.name,HWRITE.name),UVM_MEDIUM);
			end
			finish_item(pkt);
	endtask

	task genRWseq(AHB_sequence_item pkt,HBURST_TYPE HBURST);
		//
		// HSIZE == BYTE
		//
		// slave 0
		/*dseq(pkt,HBURST,BYTE,WRITE,{21'd0,1'd0,10'd1});
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
		dseq(pkt,HBURST,HALFWORD,READ ,{21'd0,1'd1,10'hfff});
		//
		// HSIZE = WORD
		//
		// slave 0
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd0,10'd0});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd4});
		dseq(pkt,HBURST,WORD,WRITE,{21'd0,1'd0,10'd0});
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
		dseq(pkt,HBURST,WORD,READ ,{21'd0,1'd1,10'hfff});
	endtask*/
endclass


/*class sequence_IDLE  extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_IDLE)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_IDLE");
		super.new(name);
	endfunction

	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HTRANS[0] == IDLE && HBURST == SINGLE;});
				finish_item(req);
			end
	endtask
endclass*/

class sequence_SINGLE_burst  extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_SINGLE_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	HBURST_TYPE hburst;
	function new(string name = "sequence_SINGLE_burst");
		super.new(name);
	endfunction

	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == SINGLE  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass

class sequence_INCR_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR_burst");
		super.new(name);
	endfunction
	
	HBURST_TYPE hburst;
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == INCR && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass

class sequence_INCR4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR4_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR4_burst");
		super.new(name);
	endfunction
	
	HBURST_TYPE hburst;
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == INCR4 && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass

class sequence_INCR8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR8_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	function new(string name = "sequence_INCR8_burst");
		super.new(name);
	endfunction
	
	HBURST_TYPE hburst;
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == INCR8  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass

class sequence_INCR16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_INCR16_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	HBURST_TYPE hburst;
	function new(string name = "sequence_INCR16_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == INCR16  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end

	endtask
endclass

class sequence_WRAP4_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP4_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)
	
	HBURST_TYPE hburst;
	function new(string name = "sequence_WRAP4_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == WRAP4  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end

	endtask
endclass

class sequence_WRAP8_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP8_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)
	
	HBURST_TYPE hburst;
	function new(string name = "sequence_WRAP8_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == WRAP8  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass

class sequence_WRAP16_burst   extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_WRAP16_burst)
	`uvm_declare_p_sequencer(AHB_sequencer)

	HBURST_TYPE hburst;
	function new(string name = "sequence_WRAP16_burst");
		super.new(name);
	endfunction

	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++)
			for(int i = 0; i < ADDRESS.size; i++)
			begin
				start_item(req);
				assert(req.randomize() with {HBURST == WRAP16  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req);
			end
	endtask
endclass
