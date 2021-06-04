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

class AHB_scoreboard extends uvm_scoreboard;
	
	`uvm_component_utils(AHB_scoreboard); // register with uvm_factory

	uvm_analysis_imp #(AHB_packet, AHB_scoreboard) pkt_imp;// analysis imp port to collect data broadcasted by monitor

	uvm_tlm_fifo #(AHB_packet) pkt_imp_fifo;// TLM FIFO to store data packets received via analysis imp port


	HRESP_TYPE exp_HRESP;
	HWRITE_TYPE pres_HWRITE,next_HWRITE;
	HTRANS_TYPE pres_HTRANS,next_HTRANS;
	HBURST_TYPE pres_HBURST,next_HBURST;
	HSIZE_TYPE  pres_HSIZE,next_HSIZE;
	logic [31:0] pres_HADDR;
	logic [31:0] next_HADDR;
	bit   [31:0] exp_HRDATA; // expected data during a read
	int packets_received;
	int	packets_passed;
	int	packets_failed;
	byte unsigned memory [int]; // Associative array to keep track of address and data driven to DUT

	function new (string name = "AHB_scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	// create analysis imp port and TLM FIFO 
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pkt_imp = new("pkt_imp",this);
		pkt_imp_fifo = new("pkt_imp_fifo",this);
	endfunction

	virtual function void write(AHB_packet pkt); // get data packet from monitor
		void'(pkt_imp_fifo.try_put(pkt)); // put data packet received from monitor into TLM FIFO
	endfunction

	function void predict_output(AHB_packet pkt);
		if(!pkt.HRESETn)
		begin
			exp_HRDATA = '0;
			exp_HRESP = OKAY;
		end
		else
		begin
			pres_HWRITE = next_HWRITE;
			pres_HTRANS = next_HTRANS;
			pres_HBURST = next_HBURST;
			pres_HADDR  = next_HADDR;
			pres_HSIZE   = next_HSIZE;
			if(pres_HWRITE == WRITE)
			begin
				if(pres_HTRANS inside {NONSEQ,SEQ})
				begin
					{memory[pres_HADDR[10:0]+2'd3],memory[pres_HADDR[10:0]+2'd2],memory[pres_HADDR[10:0]+2'd1],memory[pres_HADDR[10:0]]} = pkt.HWDATA;
					exp_HRDATA = exp_HRDATA;
					exp_HRESP  = OKAY;
				end
				else
				begin
					exp_HRDATA = exp_HRDATA;
					exp_HRESP = OKAY;
				end
			end
			else
			begin
				if(pres_HTRANS inside {NONSEQ,SEQ})
				begin
					exp_HRDATA = {memory[pres_HADDR[10:0]+2'd3],memory[pres_HADDR[10:0]+2'd2],memory[pres_HADDR[10:0]+2'd1],memory[pres_HADDR[10:0]]};
					exp_HRESP = OKAY;
				end
				else
				begin
					exp_HRDATA = exp_HRDATA;
					exp_HRESP  = OKAY;
				end
			end
			next_HWRITE = pkt.HWRITE;
			next_HTRANS = pkt.HTRANS;
			next_HBURST = pkt.HBURST;
			next_HADDR  = pkt.HADDR;
			next_HSIZE  = pkt.HSIZE;
		
		end
	endfunction

	function void check_output(AHB_packet pkt);
		if(pres_HWRITE == READ)
		begin
			if((pkt.HRDATA === exp_HRDATA) && (pkt.HRESP === exp_HRESP))
			begin
				packets_passed++;
			end
			else
			begin
				packets_failed++;
				pkt.print();
				`uvm_info(get_type_name(),$sformatf("Error in packet recived expected outputs HRDATA = %H, HRESP = %p",exp_HRDATA,exp_HRESP),UVM_MEDIUM);
			end
		end
		else
		begin
			if(pkt.HRESP === exp_HRESP)
			begin
				packets_passed++;
			end
			else
			begin
				packets_failed++;
				pkt.print();
				`uvm_info(get_type_name(),$sformatf("Error in packet recived expected output HRESP = %p",exp_HRESP),UVM_MEDIUM);
			end
		end
	endfunction
  
	virtual task run_phase(uvm_phase phase);
		AHB_packet pkt;
		phase.raise_objection(this);
		fork
			forever
			begin
				pkt_imp_fifo.get(pkt);
				packets_received++;
				predict_output(pkt);
				check_output(pkt);
			end
		join_none
		phase.drop_objection(this);
	endtask

	virtual function void report_phase (uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(),$sformatf("\nTOTAL TRANSFER COUNT = %0d\nTRANSFER SUCCESS COUNT = %0d\nTRANSFER FAILURE COUNT = %0d\nTRANSFER PASS PERCENTAGE = %f\nTRANSFER FAIL PERCENTAGE = %f",packets_received,packets_passed,packets_failed,real'(packets_passed)*100.0/real'(packets_received),real'(packets_failed)*100.0/real'(packets_received)),UVM_MEDIUM);
	endfunction
	
endclass

//--------------------------------------------------------End of AHB_scoreboard---------------------------------------------------------