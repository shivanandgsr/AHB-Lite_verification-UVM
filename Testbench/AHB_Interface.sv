
import AHBpkg::*;

interface AHB_Interface (input bit HCLK, input bit HRESETn);

        logic HREADY;
		logic HWRITE;
		logic [1:0]  HRESP;
        logic [1:0]  HTRANS;
        logic [2:0]  HBURST;
        logic [2:0]  HSIZE;
        logic [31:0] HADDR;
        logic [31:0] HWDATA;
		logic [31:0] HRDATA;


		modport DUT (input 	HCLK,
						HRESETn,
						HADDR,
						HWDATA,
						HSIZE,
						HBURST,
						HTRANS,

					output	HRESP,
						HREADY,
						HRDATA
					);

		clocking driver_cb@(posedge HCLK);
			default input #1 output #0;
			output 	HTRANS,
					HBURST,
					HWRITE,
					HWDATA,
					HSIZE,
					HADDR;

			input 	HREADY,
					HRDATA,
					HRESP;

        endclocking

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
