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