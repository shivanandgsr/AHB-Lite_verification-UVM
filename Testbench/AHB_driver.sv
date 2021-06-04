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

class AHB_driver extends uvm_driver #(AHB_sequence_item);

	`uvm_component_utils(AHB_driver)	// register AHB_driver with the factory

	virtual AHB_interface vif;			// virual interface handle

	function new(string name = "AHB_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual AHB_interface)::get(this,"","vif",vif))	// get the interface handle from congig_db
			`uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name()));
	endfunction

	virtual task reset_phase(uvm_phase phase);
		super.reset_phase(phase);
		phase.raise_objection(this);
		wait(!vif.HRESETn);
		vif.HADDR 	<= 0;
		vif.HWDATA 	<= 0;
		vif.HTRANS 	<= 0;
		wait(vif.HRESETn);
		phase.drop_objection(this);
	endtask

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		fork
			wait(vif.HRESETn);
			forever
			begin
				seq_item_port.get_next_item(req);// get data packet from sequencer
				wait(vif.HRESETn);
				drive();
				seq_item_port.item_done(); // send ack to sequencer
			end
		join_none
		phase.drop_objection(this);
	endtask
	

	task drive(); // drive the interface signals

		int j = 0;
	
			vif.driver_cb.HBURST 	<= req.HBURST;
			vif.driver_cb.HSIZE 	<= req.HSIZE;
			vif.driver_cb.HWRITE 	<= req.HWRITE;

			for(int i =0;i < req.HTRANS.size;i++)
			begin
				vif.driver_cb.HTRANS <= req.HTRANS[i];
				if(req.HWRITE == WRITE)
				begin
					if(req.HTRANS[i] inside {NONSEQ,SEQ})
					begin
						vif.driver_cb.HADDR <= req.HADDR[j];
						@(vif.driver_cb);
						vif.driver_cb.HWDATA <= req.HWDATA[j];
						j++;
					end
					else
					begin
						@(vif.driver_cb); // wait if BUSY or IDLE
					end
				end
				else
				begin
					@(vif.driver_cb);
				end
			end
	
	endtask

endclass

//---------------------------------------------------End of AHB_driver------------------------------------------------