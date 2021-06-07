//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Shivanand Reddy Gujjula                    //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////
import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

//----------------------------------------------------AHB_base_sequence---------------------------------------------------
class AHB_base_sequence extends uvm_sequence #(AHB_sequence_item) ;

	`uvm_object_utils(AHB_base_sequence)   // register with uvm_factory
	`uvm_declare_p_sequencer(AHB_sequencer)// declare sequencer on which it is to be run

	HWRITE_TYPE hwrite[]; 	// To develop deterministic tests for READ-WRITE operations
	bit [9:0] ADDRESS[];	// To develop deterministic tests for READ-WRITE operations to same and different addresses
	
	function new(string name = "AHB_base_sequence");
		super.new(name);
		this.hwrite = new[24];
		this.ADDRESS= new[24];
		this.hwrite = '{WRITE,READ,WRITE,WRITE,READ,READ,WRITE,WRITE,READ,WRITE,READ,WRITE,WRITE,WRITE,READ,WRITE,READ,READ,READ,WRITE,READ,WRITE,WRITE,READ,WRITE,READ};
		this.ADDRESS= '{10'd0,10'd0,10'd4,10'd0,10'd4,10'd0,10'd0,10'd0,10'd0,10'd0,10'd0,10'd4,10'd0,10'd4,10'd4,10'd0,10'd4,10'd0,10'd4,10'd0,10'd4,10'd0,10'hffc,10'hffc};
	endfunction

endclass
//----------------------------------------------------sequence_SINGLE_burst---------------------------------------------------
class sequence_SINGLE_burst  extends AHB_base_sequence  ;

	`uvm_object_utils(sequence_SINGLE_burst)
	`uvm_declare_p_sequencer(AHB_sequencer) 

	HBURST_TYPE hburst;
	function new(string name = "sequence_SINGLE_burst");
		super.new(name);
	endfunction

	
	virtual task body();
		req = AHB_sequence_item::type_id::create("req");
		for(bit[1:0]slave = 0; slave < 2; slave++) // Loop to generate HSEL = 0(slave0) and 1(slave1)
			for(int i = 0; i < ADDRESS.size; i++)  // Loop to generate stimulus for read-write operations to same and different addresses
			begin
				start_item(req);	
				assert(req.randomize() with {HBURST == SINGLE  && HWRITE == hwrite[i] && HADDR[0] == {21'd0,slave[0],ADDRESS[i]};});
				finish_item(req); // wait for response from driver
			end
	endtask
endclass
//----------------------------------------------------sequence_INCR_burst---------------------------------------------------
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
//----------------------------------------------------sequence_INCR4_burst---------------------------------------------------
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
//----------------------------------------------------sequence_INCR8_burst---------------------------------------------------
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
//----------------------------------------------------sequence_INCR16_burst-----------------------------------------------------
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
//----------------------------------------------------sequence_WRAP4_burst---------------------------------------------------
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
//----------------------------------------------------sequence_WRAP8_burst---------------------------------------------------
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
//----------------------------------------------------sequence_WRAP16_burst---------------------------------------------------
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

//-------------------------------------------------------End of AHB_sequences-----------------------------------------------------------