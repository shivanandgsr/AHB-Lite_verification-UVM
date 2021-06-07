//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Sri Harsha Doppalapudi                     //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////

import AHBpkg::*;
import uvm_pkg::*;

module AHB_TBtop;

	bit clock;
	bit reset;

	always
		#5 clock = ~clock;

	initial begin
		reset <= 0;
		#20 reset =1;
	end
	
	AHB_interface intf(clock,reset);// Interface 
	AHBSlaveTop DUT(intf.DUT);		// DUT instantiation


	initial
	begin
		uvm_config_db#(virtual AHB_interface)::set(uvm_root::get(),"*","vif",intf);// set virtual interface visibility to testbench components
		run_test("AHB_test");	// run the test
		#10 $finish;
	end

endmodule

//------------------------------------------------End of AHB_TBtop---------------------------------------------------------