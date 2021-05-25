
class AHB_driver #(AHB_sequence_item) extends uvm_driver;

	`uvm_component_utils(AHB_driver)
	
	virtual AHB_Interface vif;
	
	function new(string name = "AHB_driver",uvm_component parent=null);
		super.new(name,parent);
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual AHB_Interface)::get(this,"","vif",vif))
			`uvm_fatal(get_type_name(),$sformatf("virtual interface must be set for:%s",get_full_name());
	endfunction
 
	virtual task run_phase(uvm_phase phase);
		forever 
		begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_done();
		end
	endtask

	task drive();
		
		wait(!vif.RESETn)
		if(vif.HRESP)
			`uvm_info(get_type_name(),$sformatf("ERROR Slave Failed to Receive:\n%p",prevpkt),UVM_HIGH);
		
		vif.HSIZE <= req.HSIZE;
		vif.HWRITE <= req.HWRITE;
		
		for(int i =0;i<req.HADDR.size;i++)
		begin
			@(posedge vif.HCLK);
			if(!vif.HREADY)
				i = i-1;
			else
			begin
				case(req.HTRANS[j]) inside
				BUSY		:if(!req.HTRANS[j-1] inside {IDLE,BUSY})
								vif.HADDR <= req.HADDR[i+1];
				
				NONSEQ,SEQ	:if(!req.HTRANS[j-1] inside{IDLE,BUSY})
							 begin
								vif.HADDR <= req.HADDR[i+1];
								if(req.HWRITE == WRITE)
									vif.HWDATA <= req.HWDATA[i];
								else
									vif.HWDATA <= '0;
							 end
			end
		
	endtask
	
endclass
