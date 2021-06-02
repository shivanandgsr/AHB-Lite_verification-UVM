import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class AHB_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(AHB_scoreboard);

  uvm_analysis_imp #(AHB_packet, AHB_scoreboard) pkt_imp;

  uvm_tlm_fifo #(AHB_packet) pkt_imp_fifo;

  //AHB_packet FIFO_pkt[$];
  static byte unsigned memory [int];
  static HRESP_TYPE Pre_HRESP;
  static logic [31:0] Pre_HRDATA;
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
	`uvm_info(get_type_name(),"write task waiting to push into fifo ",UVM_MEDIUM);
    void'(pkt_imp_fifo.try_put(pkt));
	`uvm_info(get_type_name(),"write task done pushing into fifo ",UVM_MEDIUM);
	//FIFO_pkt.push_front(pkt);
  endfunction

  function void predict_output(AHB_packet pkt);
    `uvm_info(get_type_name(),"predict output enter ",UVM_MEDIUM);
	if(!pkt.HRESETn) 
    begin
	   `uvm_info(get_type_name(),"predict output if block enter ",UVM_MEDIUM);
      Pre_HRESP = OKAY;
      Pre_HRDATA = '0;
    end
    else
    begin
      if(pkt.HWRITE == WRITE)
      begin
        case(pkt.HSIZE)
            BYTE:     begin
                        if((pkt.HTRANS == NONSEQ) || (pkt.HTRANS == SEQ))
                        begin
                          memory[pkt.HADDR[10:0]] = pkt.HWDATA[7:0];
                        end
                      end
            HALFWORD: begin
                        if((pkt.HTRANS == NONSEQ) || (pkt.HTRANS == SEQ))
                        begin
                          memory[pkt.HADDR[10:0]] = pkt.HWDATA[7:0];
                          memory[pkt.HADDR[10:0]+1'b1] = pkt.HWDATA[16:8];
                        end
                      end
            WORD:     begin
                        if((pkt.HTRANS == NONSEQ) || (pkt.HTRANS == SEQ))
                        begin
                          memory[pkt.HADDR[10:0]] = pkt.HWDATA[7:0];
                          memory[pkt.HADDR[10:0]+1'd1] = pkt.HWDATA[15:8];
                          memory[pkt.HADDR[10:0]+2'd2] = pkt.HWDATA[23:16];
                          memory[pkt.HADDR[10:0]+2'd3] = pkt.HWDATA[31:24];
                        end
                      end
        endcase
      end
      else
      begin
        case(pkt.HSIZE)
            BYTE:     begin
                        if(pkt.HTRANS inside {NONSEQ,SEQ})
                        begin
                          Pre_HRESP = OKAY;
                          Pre_HRDATA[7:0] = memory[pkt.HADDR[10:0]];
                        end
                      end
            HALFWORD: begin
                        if(pkt.HTRANS inside {NONSEQ,SEQ})
                        begin
                          Pre_HRESP = OKAY;
                          Pre_HRDATA[15:0] = {memory[pkt.HADDR[10:0]+1'b1],memory[pkt.HADDR[10:0]]};
                        end
                      end
            WORD:     begin
                        if(pkt.HTRANS inside {NONSEQ,SEQ})
                        begin
                          Pre_HRESP = OKAY;
                          Pre_HRDATA[31:0] = {memory[pkt.HADDR[10:0]+2'd3],memory[pkt.HADDR[10:0]+2'd2],memory[pkt.HADDR[10:0]+2'd1],memory[pkt.HADDR[10:0]]};
                        end
                      end
        endcase
      end
    end
	 `uvm_info(get_type_name(),"predict output exit ",UVM_MEDIUM);
  endfunction

  function void check_output(AHB_packet pkt);
	`uvm_info(get_type_name(),"check_output enter",UVM_MEDIUM);
    if((pkt.HRDATA === Pre_HRDATA) && (pkt.HRESP == Pre_HRESP))
    begin
      packets_passed++;
    end
    else
    begin
      packets_failed++;
      //pkt.print();
      //`uvm_info(get_type_name(),$sformatf("Error in packet recived expected outputs HRDATA = %H, HRESP = %p",Pre_HRDATA,Pre_HRESP),UVM_MEDIUM);
    end
	`uvm_info(get_type_name(),"check_output exit",UVM_MEDIUM);
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    AHB_packet pkt;
	`uvm_info(get_type_name(),"run phase enter ",UVM_MEDIUM);
    //forever
    repeat(5)
	begin
      //pkt = FIFO_pkt.pop_back();
	  `uvm_info(get_type_name(),"run phase waiting for fifo get ",UVM_MEDIUM);
	  pkt_imp_fifo.get(pkt);
	  `uvm_info(get_type_name(),"run phase received fifo get ",UVM_MEDIUM);
      packets_received++;
      predict_output(pkt);
      check_output(pkt);
    end
	`uvm_info(get_type_name(),"run phase exit ",UVM_MEDIUM);
  endtask

  virtual function void report_phase (uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Total No.of packets received = %d/n Total No.of packets without errors = %d/n Total No.of packets with errors = %d ",packets_received,packets_passed,packets_failed),UVM_MEDIUM);
  endfunction
endclass
