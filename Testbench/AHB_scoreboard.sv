import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class AHB_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(AHB_scoreboard);

  uvm_analysis_imp #(AHB_packet, AHB_scoreboard) pkt_imp;

  uvm_tlm_fifo #(AHB_packet) pkt_imp_fifo;

  //AHB_packet FIFO_pkt[$];
  static byte unsigned memory [int];
  static HRESP_TYPE exp_HRESP;
  static bit [31:0] exp_HRDATA;
  static HWRITE_TYPE pres_HWRITE,next_HWRITE;
  static HTRANS_TYPE pres_HTRANS,next_HTRANS;
  static HBURST_TYPE pres_HBURST,next_HBURST;
  static HSIZE_TYPE  pres_HSIZE,next_HSIZE;
  static logic [31:0] pres_HADDR,next_HADDR;
  static int packets_received,packets_passed,packets_failed;

  function new (string name = "AHB_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_imp = new("pkt_imp",this);
    pkt_imp_fifo = new("pkt_imp_fifo",this);
  endfunction

  virtual function void write(AHB_packet pkt);
	//`uvm_info(get_type_name(),"write task waiting to push into fifo ",UVM_MEDIUM);
    void'(pkt_imp_fifo.try_put(pkt));
	//`uvm_info(get_type_name(),"write task done pushing into fifo ",UVM_MEDIUM);
	//FIFO_pkt.push_front(pkt);
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
	//`uvm_info(get_type_name(),"check_output enter",UVM_MEDIUM);
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
			//$display("memory=%p",memory);
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
		//`uvm_info(get_type_name(),"check_output exit",UVM_MEDIUM);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    AHB_packet pkt;
	//`uvm_info(get_type_name(),"run phase enter ",UVM_MEDIUM);
	phase.raise_objection(this);
	fork
		forever
		repeat(80)
		begin
			//pkt = FIFO_pkt.pop_back();
			//`uvm_info(get_type_name(),"run phase waiting for fifo get ",UVM_MEDIUM);
			pkt_imp_fifo.get(pkt);
			//`uvm_info(get_type_name(),"run phase received fifo get ",UVM_MEDIUM);
			packets_received++;
			predict_output(pkt);
			check_output(pkt);
		end
	join_none
	phase.drop_objection(this);
	//`uvm_info(get_type_name(),"run phase exit ",UVM_MEDIUM);
  endtask

  virtual function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Total No.of packets received = %d/n Total No.of packets without errors = %d/n Total No.of packets with errors = %d ",packets_received,packets_passed,packets_failed),UVM_MEDIUM);
  endfunction
endclass
