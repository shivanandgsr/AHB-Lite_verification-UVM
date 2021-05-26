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

class AHB_packet;
    logic HREADY;
    logic HWRITE;
    logic [1:0]  HRESP;
    logic [1:0]  HTRANS;
    logic [2:0]  HBURST;
    logic [2:0]  HSIZE;
    logic [31:0] HADDR;
    logic [31:0] HWDATA;
    logic [31:0] HRDATA;
endclass
