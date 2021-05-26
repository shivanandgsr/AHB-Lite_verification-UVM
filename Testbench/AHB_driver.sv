import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "AHB_sequence_item.sv"

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
		vif.HWRITE 	<= 0;
		vif.HWDATA 	<= 0;
		vif.HTRANS 	<= 0;
		vif.HBURST 	<= 0;
		vif.HSIZE 	<= 0;
		wait(vif.HRESETn);
		phase.drop_objection(this);
	endtask
                                               
	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		phase.raise_objection(this);
		forever 
		begin
			seq_item_port.get_next_item(req);
			wait(vif.HRESETn)
			drive();
			seq_item_port.item_done();
		end
		phase.drop_objection(this);
	endtask

	task drive();
		
		int j;
		
		forever
		begin
			vif.driver_cb.HBURST 	<= req.HBURST;
			vif.driver_cb.HSIZE 	<= req.HSIZE;
			vif.driver_cb.HWRITE 	<= req.HWRITE;
			
			for(int i =0;i < req.HADDR.size;i++)
			begin
				vif.driver_cb.HADDR  <= req.HADDR[i];
				vif.driver_cb.HTRANS <= req.HTRANS[j];
                while(req.HTRANS[j] == BUSY);
				begin
					j++;
					@(vif.driver_cb);
					vif.driver_cb.HTRANS <= req.HTRANS[j];
				end
				@(vif.driver_cb);
				j++;
				while(!vif.mdrv_cb.HREADY) 
					@(vif.driver_cb);
				if(req.read_write)
					vif.driver_cb.HWDATA <= req.HWDATA[i];
			end	
		end
	endtask
	
endclass
