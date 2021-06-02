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

	`uvm_component_utils(AHB_driver)

	virtual AHB_interface vif;

	function new(string name = "AHB_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual AHB_interface)::get(this,"","vif",vif))
			`uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name()));
	endfunction

	virtual task reset_phase(uvm_phase phase);
		super.reset_phase(phase);
		phase.raise_objection(this);
		wait(!vif.HRESETn);
		vif.HADDR 	<= 0;
		vif.HWDATA 	<= 0;
		vif.HTRANS 	<= 0;
		`uvm_info(get_type_name(),"Waiting for RESET = 1",UVM_MEDIUM);
		wait(vif.HRESETn);
		`uvm_info(get_type_name(),"RESET = 1",UVM_MEDIUM);
		phase.drop_objection(this);
	endtask

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		wait(vif.HRESETn);
		//forever
		repeat(5)
		begin
			`uvm_info(get_type_name(),"get_next_item waiting",UVM_MEDIUM);
			seq_item_port.get_next_item(req);
			`uvm_info(get_type_name(),"get_next_item received",UVM_MEDIUM);
			req.print();
			`uvm_info(get_type_name(),"run phase Waiting for RESET = 1",UVM_MEDIUM);
			wait(vif.HRESETn);
			`uvm_info(get_type_name(),"run phase RESET = 1",UVM_MEDIUM);
			drive();
			seq_item_port.item_done();
		end
		phase.drop_objection(this);
		`uvm_info(get_type_name(),"Done in run phase",UVM_MEDIUM);
	endtask

	task drive();

		int j;
			`uvm_info(get_type_name(),"drive enter",UVM_MEDIUM);
	
			vif.driver_cb.HBURST 	<= req.HBURST;
			vif.driver_cb.HSIZE 	<= req.HSIZE;
			vif.driver_cb.HWRITE 	<= req.HWRITE;

			for(int i =0;i < req.HADDR.size;i++)
			begin
				`uvm_info(get_type_name(),"drive for loop enter",UVM_MEDIUM);
				vif.driver_cb.HADDR  <= req.HADDR[i];
				vif.driver_cb.HTRANS <= req.HTRANS[j];
                while(req.HTRANS[j] == BUSY);
				begin
					`uvm_info(get_type_name(),"drive while loop enter",UVM_MEDIUM);
					j++;
					@(vif.driver_cb);
					vif.driver_cb.HTRANS <= req.HTRANS[j];
				end
				`uvm_info(get_type_name(),"drive while loop exit",UVM_MEDIUM);
				@(vif.driver_cb);
				j++;
				`uvm_info(get_type_name(),"drive waiting for HREADY",UVM_MEDIUM);
				wait(vif.driver_cb.HREADY)
				`uvm_info(get_type_name(),"drive  HREADY = 1",UVM_MEDIUM);
				@(vif.driver_cb);
				if(req.HWRITE == WRITE)
					vif.driver_cb.HWDATA <= req.HWDATA[i];
			end
			`uvm_info(get_type_name(),"drive for loop exit",UVM_MEDIUM);
	
	endtask

endclass
