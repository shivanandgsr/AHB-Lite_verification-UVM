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
class AHB_sequence_item extends uvm_sequence_item;

	`uvm_object_utils(AHB_sequence_item)

	rand HTRANS_TYPE HTRANS[];			// Transfer type array
    rand HSIZE_TYPE HSIZE;				// Burst size
    rand HBURST_TYPE HBURST;			// Burst type
    rand HWRITE_TYPE HWRITE;			// Read or write signal
	rand bit [DATAWIDTH-1:0] HWDATA[];	// Write data array
	rand bit [ADDRWIDTH-1:0] HADDR[];	// HADDR array

	bit HREADY;
	HRESP_TYPE HRESP;					// Response type (output signal)
	//bit [DATAWIDTH-1:0] HRDATA;			// Read data

    rand bit BUSY_P[];					// Array to store BUSY positions
    rand int NUM_BUSY;					// No. of BUSY states

	function new (string name = "AHB_sequence_item");
		super.new(name);
	endfunction

	function void post_randomize();
		int COUNT;
		if(HBURST != SINGLE)
			foreach(BUSY_P[i])
			begin
				if(BUSY_P[i] && i != 0)
				begin
					if(HBURST != INCR && i != HTRANS.size - 1)
						HTRANS[i] = BUSY;
					else
						HTRANS[i] = BUSY;
					COUNT++;
				end
				if(COUNT == NUM_BUSY)
					break;
			end
	endfunction
	
	//constraint Not_INCR {
						//	HWRITE != READ;
						//}

    constraint BUSY_COUNT{
                            NUM_BUSY inside{[0:HADDR.size]};
                        }

    constraint BUSY_SIZE{
                           BUSY_P.size == HTRANS.size;
                        }
	constraint BUSY_POSITION{
								BUSY_P.sum(item) with (int'(item)) == NUM_BUSY;
							}
	constraint NOBUSY_FIRST{
								BUSY_P[0] == 1'b0;
							}
	constraint hwdata{
						HWDATA.size == HADDR.size;
                     }

    constraint hsize{
						HSIZE == WORD;
                    }

	constraint AddrHighbits {foreach(HADDR[i])
								soft HADDR[i][31:11] == '0;
							}

    constraint AddrMin{
                        HADDR.size > 0;
                      }

	// No. of HADDRes to be generated based on HBURST type
    constraint Addr {	solve HSIZE before  HBURST;
						solve HBURST before HADDR;
						if(HBURST == SINGLE)
                                HADDR.size == 1;
                        else if(HBURST == INCR)
                                HADDR.size == 5;
                        else if(HBURST inside{INCR4,WRAP4})
                                HADDR.size == 4;
                        else if(HBURST inside{INCR8,WRAP8})
                                HADDR.size == 8;
                        else if(HBURST inside{INCR16,WRAP16})
                                HADDR.size == 16;
                        }

	// Limitation to HADDR in incrmenting BURSTS - 1KB HADDR space as slaves are 1 KB HADDRable
    constraint ADDR_SPACE_1KB {
								if(HBURST == INCR)
									HADDR[0][9:0] <= (1024 - ((HADDR.size)*(2**HSIZE)));
								else if(HBURST inside{INCR4,WRAP4})
									HADDR[0][9:0] <= (1024 - 4*(2**HSIZE));
								else if(HBURST inside{INCR8,WRAP8})
									HADDR[0][9:0] <= (1024 - 8*(2**HSIZE));
								else if(HBURST inside{INCR16,WRAP16})
									HADDR[0][9:0] <= (1024 - 16*(2**HSIZE));
								}

	// HADDR alignment
    constraint ADDR_ALIGNMENT{
									if(HSIZE == HALFWORD)
										foreach(HADDR[i])
											HADDR[i][0] == '0;
									else if(HSIZE == WORD)
										foreach(HADDR[i])
											HADDR[i][1:0] == '0;
								}

	// HADDR generation in increment BURSTS
    constraint ADDR_INCR{
							if(HBURST inside{INCR,INCR4,INCR8,INCR16})
								foreach(HADDR[i])
									if(i != 0)
										HADDR[i] == HADDR[i-1] + 2**HSIZE;
						}

	// HADDR generation in wrapping BURSTS

	constraint ADDR_WRAP{
							if(HBURST == WRAP4)
							{
								if(HSIZE == BYTE)
									foreach(HADDR[i])
										if(i != 0){
                                                    HADDR[i][1:0] == HADDR[i-1][1:0] + 1;
                                                    HADDR[i][31:2] == HADDR[i-1][31:2];
												  }
								else if(HSIZE == HALFWORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][2:1]  == HADDR[i-1][2:1] + 1;
													HADDR[i][31:3] == HADDR[i-1][31:3];
												  }
								else if(HSIZE == WORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][3:2]  == HADDR[i-1][3:2] + 1;
													HADDR[i][31:4] == HADDR[i-1][31:4];
												  }
							}
							else if(HBURST == WRAP8)
							{
								if(HSIZE == BYTE)
									foreach(HADDR[i])
										if(i != 0){
                                                    HADDR[i][2:0] == HADDR[i-1][2:0] + 1;
                                                    HADDR[i][31:3] == HADDR[i-1][31:3];
												  }
								else if(HSIZE == HALFWORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][3:1]  == HADDR[i-1][3:2] + 1;
													HADDR[i][31:4] == HADDR[i-1][31:4];
												  }
								else if(HSIZE == WORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][4:2]  == HADDR[i-1][4:2] + 1;
													HADDR[i][31:5] == HADDR[i-1][31:5];
												   }
							}
							else if(HBURST == WRAP16)
							{
								if(HSIZE == BYTE)
									foreach(HADDR[i])
										if(i != 0){
                                                    HADDR[i][3:0] == HADDR[i-1][3:0] + 1;
                                                    HADDR[i][31:4] == HADDR[i-1][31:4];
												  }
								else if(HSIZE == HALFWORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][4:1]  == HADDR[i-1][3:2] + 1;
													HADDR[i][31:5] == HADDR[i-1][31:5];
												  }
								else if(HSIZE == WORD)
									foreach(HADDR[i])
										if(i != 0){
													HADDR[i][5:2] == HADDR[i-1][5:2] + 1;
													HADDR[i][31:6] == HADDR[i-1][31:6];
												   }
							}
						}

	// transfer type for SINGLE BURST
    constraint HTRANS_SINGLE {
								if(HBURST == SINGLE)
								{
                                    HTRANS.size == 1;
                                    HTRANS[0] == NONSEQ;
								}
							}

	// transfer type for other BURSTS
    constraint HTRANS_OTHER {
								if(HBURST != SINGLE)
								{
									HTRANS.size == HADDR.size + NUM_BUSY;
									foreach(HTRANS[i])
										if(i == 0)
                                            HTRANS[i] == NONSEQ;
										else
                                            HTRANS[i] == SEQ;
								}
							}
	/*virtual function string convert2string();
		string contents = "";
		
		$sformat(contents,"%s HTRANS   = %p",contents,HTRANS);
		$sformat(contents,"%s HBURST   = %p",contents,HTRANS);
		$sformat(contents,"%s HSIZE    = %p",contents,HTRANS);
		$sformat(contents,"%s HWRITE   = %p",contents,HTRANS);
		$sformat(contents,"%s HADDR    = %p",contents,HTRANS);
		$sformat(contents,"%s HWDATA   = %p",contents,HTRANS);
		$sformat(contents,"%s BUSY_P   = %p",contents,HTRANS);
		$sformat(contents,"%s NUM_BUSY = %p",contents,HTRANS);
		
		return contents;
	endfunction*/
	
	virtual function void do_print(uvm_printer printer);
		super.do_print(printer);
		foreach(HTRANS[i])
			printer.print_string ("HTRANS[i]",this.HTRANS[i].name());
		foreach(HADDR[i])
			printer.print_field  ("ADDR[i]",this.HADDR[i],32,UVM_HEX);
		foreach(BUSY_P[i])
			printer.print_field ("BUSY_P[i]",this.BUSY_P[i],1,UVM_HEX);
		printer.print_string ("HWRITE",this.HWRITE.name());
		printer.print_string ("HRESP",this.HRESP.name());
		printer.print_string ("HBURST",this.HBURST.name());
		printer.print_string ("HSIZE",this.HSIZE.name());
		//printer.print_field  ("HADDR",this.HADDR,32,UVM_HEX);
		//printer.print_field  ("HWDATA",this.HWDATA,32,UVM_HEX);
		//printer.print_field  ("HRDATA",this.HRDATA,32,UVM_HEX);
	endfunction

endclass
