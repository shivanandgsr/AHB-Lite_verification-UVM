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
class AHB_packet extends uvm_object;
  `uvm_object_utils(AHB_packet)

    logic HRESETn;
    HWRITE_TYPE HWRITE;
    HRESP_TYPE  HRESP;
    HTRANS_TYPE  HTRANS;
    HBURST_TYPE  HBURST;
    HSIZE_TYPE  HSIZE;
    logic [ADDRWIDTH-1:0] HADDR;
    logic [DATAWIDTH-1:0] HWDATA;
    logic [DATAWIDTH-1:0] HRDATA;

    function new (string name = "AHB_packet");
      super.new(name);
    endfunction

    virtual function void do_print(uvm_printer printer);
      super.do_print(printer);
      printer.print_field("HRESETn",this.HRESETn,1,UVM_DEC);
      printer.print_string ("HWRITE",this.HWRITE.name());
      printer.print_string ("HRESP",this.HRESP.name());
      printer.print_string ("HTRANS",this.HTRANS.name());
      printer.print_string ("HBURST",this.HBURST.name());
      printer.print_string ("HSIZE",this.HSIZE.name());
      printer.print_field  ("ADDR",this.HADDR,32,UVM_HEX);
      printer.print_field  ("HWDATA",this.HWDATA,32,UVM_HEX);
      printer.print_field  ("HRDATA",this.HRDATA,32,UVM_HEX);
    endfunction

endclass
