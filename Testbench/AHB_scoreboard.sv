class AHB_scoreboard extends uvm_scoreboard;
  uvm_component_utils(AHB_scoreboard);

  uvm_analysis_imp #(AHB_packet, AHB_scoreboard) pkt_imp;

  uvm_tlm_fifo #(AHB_packet) pkt_imp_fifo;

  static usigned byte memory [int];
  static HRESP_TYPE Pre_HRESP;
  static logic [31:0] Pre_HRDATA;
  static int packets_received,packets_passed,packets_failed;

  function new (string name = "AHB_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase)
    super.build_phase(phase);
    pkt_imp = new("pkt_imp",this);
    pkt_imp_fifo = new("pkt_imp_fifo",this)
  endfunction

  function void write(AHB_packet pkt);
    pkt_imp_fifo.put(pkt);
  endfunction

  function void run_phase(uvm_phase phase)
    AHB_packet pkt;
    forever
    begin
      pkt_imp_fifo.get(pkt);
      packets_received++;
      predict_output(pkt);
      check_output(pkt);
    end
  endfunction

  function void predict_output(AHB_packet pkt);
    if(!pkt.HRESETn)
    begin
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
                          Pre_HRDATA[31:0] = {memory[pkt.HADDR[10:0]+2'b3],memory[pkt.HADDR[10:0]+2'b2],memory[pkt.HADDR[10:0]+2'b1],memory[pkt.HADDR[10:0]]};
                        end
                      end
  endfunction

  function void check_output(AHB_packet pkt);
    if((pkt.HRDATA == pre_HRDATA) && (pkt.HRESP == pre_HRESP))
    begin
      packets_passed++;
    end
    else
    begin
      packets_failed++;
      pkt.print();
      uvm_info(get_type_name(),$sformatf("Error is packet recived expected outputs HRDATA = %H, HRESP = %f",pre_HRDATA,pre_HRESP),UVM_MEDIUM);
    end
  endfunction

  function void report_phase (AHB_packet pkt);
    uvm_info(get_type_name(),$sformatf("Total No.of packets received = %d/n Total No.of packets without errors = %d/n Total No.of packets with errors = %d ",packets_received,packets_passed,packets_failed),UVM_MEDIUM);
  endfunction
endclass
