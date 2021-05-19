
package AHBpkg;
	
	parameter DATAWIDTH   = 32;
	parameter ADDRWIDTH   = 32;
	
	parameter SLAVE_DATAWIDTH = 10;
	parameter SLAVE_ADDRWIDTH = 10;

	typedef enum bit [1:0] {IDLE,BUSY,NONSEQ,SEQ} HTRANS_TYPE;

	typedef enum bit [2:0] {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16} HBURST_TYPE;
	
	typedef enum bit [2:0] {BYTE,HALFWORD,WORD,WORD2,WORD4,WORD8,WORD16,WORD16,WORD32} HSIZE_TYPE;

	typedef enum bit {OKAY,ERROR} HRESP_TYPE;
	
	typedef enum bit {READ,WRITE} HWRITE_TYPE;

endpackage
 