
import AHBpkg::*;

interface AHB_Interface (input bit HCLK, input bit HRESETn);

	logic  	HRESP;
	logic	HWRITE;
	logic	HREADY;
	logic  	[ADDRWIDTH-1:0] HADDR;
	logic  	[DATAWIDTH-1:0] HWDATA;
	logic	[DATAWIDTH-1:0] HRDATA;

	HSIZE_TYPE	HSIZE;
	HBURST_TYPE HBURST;
	HTRANS_TYPE HTRANS;
	
	modport DUT (input 	HCLK,
						HRESETn,
						HADDR,
						HWDATA,
						HSIZE,
						HBURST,
						HTRANS
				
				output	HRESP,
						HREADY,
						HRDATA
				);
  
endinterface