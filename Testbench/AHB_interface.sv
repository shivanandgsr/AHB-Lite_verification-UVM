//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Hiranmaye Sarpana Chandu                   //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////

import definesPkg::* ;

interface AHB_interface (input bit HCLK, input bit HRESETn);

    logic [ADDRESS_WIDTH-1:0] 	HADDR;
	logic 				  		HWRITE;
	logic [HSIZE_WIDTH-1:0]		HSIZE;
	logic [BURST_SIZE-1:0]		HBURST;
	logic [TRANSFER_TYPE-1:0]	HTRANS;
	logic [DATA_WIDTH-1:0]		HWDATA;
	logic [DATA_WIDTH-1:0]		HRDATA;
	logic						HREADY;
	logic						HRESP;					

	// modport for DUT
	modport DUT (input 	HCLK,
					HRESETn,
					HADDR,
					HWDATA,
					HSIZE,
					HBURST,
					HTRANS,
					HWRITE,

				output	HRESP,
					HREADY,
					HRDATA
				);
				
	// driver clocking block
	clocking driver_cb@(posedge HCLK);
		default input #1 output #0;
		output 	HTRANS,
				HBURST,
				HWRITE,
				HWDATA,
				HSIZE,
				HADDR;

	endclocking

	// monitor clocking block
	clocking monitor_cb@(posedge HCLK);
		default input #1 output #0;

		input 	HRESETn,
				HTRANS,
				HBURST,
				HWRITE,
				HWDATA,
				HREADY,
				HRDATA,
				HSIZE,
				HADDR,
				HRESP;

	endclocking

endinterface

//--------------------------------------------------ENd of AHB_interface----------------------------------------------------