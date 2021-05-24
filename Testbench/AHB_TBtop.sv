
module AHB_TBtop;
   
	bit clock;
	bit reset;
  
	always
		#5 clk = ~clk;
   
	initial begin
		reset <= 1;
		#5 reset =0;
	end
   
	AHB_Interface intf(clk,reset);
  
	// DUT instantiation
   
	initial 
	begin
		uvm_config_db#(virtual AHB_Interface)::set(uvm_root::get(),"*","vif",intf);
	end
   
	initial begin
		run_test();
		#10 $finish;
	end
  
endmodule