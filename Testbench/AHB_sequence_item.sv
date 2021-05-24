import AHBpkg::*;

class AHB_sequence_item extends uvm_sequence_item;

	`uvm_object_utils(AHB_sequence_item)
	
	rand HTRANS HTRANS[];				// Transfer type array
    rand HSIZE_TYPE HSIZE;				// Burst size 
    rand HBURST_TYPE HBURST;			// Burst type
    rand HWRITE_TYPE HWRITE;			// Read or write signal
	rand bit [DATAWIDTH-1:0] HWDATA[];	// Write data array
	rand bit [ADDRWIDTH-1:0] HADDR[];	// Address array
	
	bit HREADY;							
	HRESP_TYPE HRESP;					// Response type (output signal)
	bit [DATAWIDTH-1:0] HRDATA;			// Read data 

    rand bit BUSY[];					// Array to store BUSY positions
    rand int NUM_BUSY;					// No. of BUSY states
	
	extern function new(string name = "AHB_sequence_item");
	extern function void post_randomize();
    

    constraint BUSY_COUNT{
                            NUM_BUSY inside{[0:HADDR.size]};
                        }

    constraint BUSY_SIZE{
                           BUSY.size == HTRANS.size;
                        }
	constraint BUSY_POSITION{
								BUSY.sum() == NUM_BUSY;
							}
	constraint NOBUSY_FIRST{
								BUSY[0] != '1;
							}
	constraint HWDATA{
						HWDATA.size == HADDR.size;
                     }

    constraint HSIZE{
						HSIZE <= WORD;
                    }
						
	constraint AddrHighbits {foreach(HADDR[i])
								HADDR[i][31:11] == '0;
							}

    constraint AddrMin{
                        HADDR.size > 0;
                      }
					  
	// No. of HADDRes to be generated based on HBURST type
    constraint Addr {
						if(HBURST == SINGLE)
                                HADDR.size == 1;
                        else if(HBURST == INCR)
                                HADDR.size < (1024/(2^HSIZE));
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
									if(HSIZE != BYTE)
										foreach(HADDR[i])
											HADDR[i][HSIZE-1:0] == '0;
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
                                foreach(HADDR[i])
                                    if(i != 0){
												HADDR[i][$clog2(4*HSIZE)-1:HSIZE] == HADDR[i-1][$clog2(4*HSIZE)-1:HSIZE] + 1;
												HADDR[i][31:$clog2(4*HSIZE) ] == HADDR[i-1][31:$clog2(4*HSIZE)];
											  }
							}
							else if(HBURST == WRAP8)
							{
                                foreach(HADDR[i])
									if(i != 0){
                                                HADDR[i][$clog2(8*HSIZE)-1:HSIZE] == HADDR[i-1][$clog2(8*HSIZE)-1:HSIZE] + 1;
                                                HADDR[i][31:$clog2(8*HSIZE) ] == HADDR[i-1][31:$clog2(8*HSIZE)];
                                               }
							}
							else if(HBURST == WRAP16){
                                foreach(HADDR[i])
									if(i != 0){
												HADDR[i][$clog2(16*HSIZE)-1:HSIZE] == HADDR[i-1][$clog2(16*HSIZE)-1:HSIZE] + 1;
												HADDR[i][31:$clog2(16*HSIZE) ] == HADDR[i-1][31:$clog2(16*HSIZE)];
                                               }
							}
						}
						
	// transfer type for SINGLE BURST
    constraint HTRANS_SINGLE {
								if(HBURST == SINGLE)
								{
                                    HTRANS.size == 1;
                                    HTRANS[0] inside {IDLE, NONSEQ};
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

endclass

function AHB_sequence_item::new (string name = "AHB_sequence_item");
	super.new(name);
endfunction
        
function void AHB_sequence_item::post_randomize();
	
	int COUNT;
	if(HBURST != SINGLE)
		foreach(BUSY[i])
		begin
			if(BUSY[i] && i != 0)
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