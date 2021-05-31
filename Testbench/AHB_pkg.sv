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

package AHBpkg;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	parameter DATAWIDTH   = 32;
	parameter ADDRWIDTH   = 32;

	parameter SLAVE_DATAWIDTH = 32;
	parameter SLAVE_ADDRWIDTH = 10;

	typedef enum bit [1:0] {IDLE,BUSY,NONSEQ,SEQ} HTRANS_TYPE;

	typedef enum bit [2:0] {SINGLE,INCR,WRAP4,INCR4,WRAP8,INCR8,WRAP16,INCR16} HBURST_TYPE;

	typedef enum bit [2:0] {BYTE,HALFWORD,WORD,WORD2,WORD4,WORD8,WORD16,WORD32} HSIZE_TYPE;

	typedef enum bit {OKAY,ERROR} HRESP_TYPE;

	typedef enum bit {READ,WRITE} HWRITE_TYPE;

	`include "AHB_sequence_item.sv"
	`include "AHB_sequences.sv"
	`include "AHB_virtual_sequencer.sv"
	`include "AHB_virtual_sequence.sv"
	`include "AHB_driver.sv"
	`include "AHB_packet.sv"
	`include "AHB_monitor.sv"
	`include "AHB_agent.sv"
	`include "AHB_coverage.sv"
	`include "AHB_scoreboard.sv"
	`include "AHB_environment.sv"
	`include "AHB_test.sv"

endpackage
