
import AHBpkg::*;

interface AHB_Interface (input bit HCLK, input bit HRESETn);

	logic	HSEL;
	logic  	HRESP;
	logic	HWRITE;
	logic	HREADY;
	logic	HREADYOUT;
	logic  	[ADDRWIDTH-1:0] HADDR;
	logic  	[DATAWIDTH-1:0] HWDATA;
	logic	[DATAWIDTH-1:0] HRDATA;

	HSIZE_TYPE	HSIZE;
	HBURST_TYPE HBURST;
	HTRANS_TYPE HTRANS;
  
endinterface