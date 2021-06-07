//Project : Verification of AMBA3 AHB-Lite protocol    //
//			using Universal Verification Methodology   //
//													   //
// Subject:	ECE 593									   //
// Guide  : Tom Schubert   							   //
// Date   : May 25th, 2021							   //
// Team	  :	Shivanand Reddy Gujjula,                   //
//			Sri Harsha Doppalapudi,                    //
//			Hiranmaye Sarpana Chandu	               //
// Author : Sri Harsha Doppalapudi                     //
// Portland State University                           //
//                                                     //
/////////////////////////////////////////////////////////
import AHBpkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class AHB_coverage extends uvm_subscriber #(AHB_packet);

  `uvm_component_utils(AHB_coverage)

  AHB_packet packet_data;

  logic [ADDRWIDTH-1:0] Prev_addr_1,Prev_addr_2;

//------------------------------------------------------------------------Coverage for inputs to  DUT--------------------------------------------------------------------------------------------------
   covergroup AHB_functional_coverage;

   selection_of_two_slaves:  coverpoint packet_data.HADDR[10]  {
                                                                    bins slave0_select = {1'b0};
                                                                    bins slave1_select = {1'b1};
                                                                 }

   AHB_read_write:           coverpoint packet_data.HWRITE     {
                                                                    bins AHB_read = {1'b0};
                                                                    bins AHB_write = {1'b1};
                                                                 }
   AHB_Burst_size:           coverpoint packet_data.HBURST     {
                                                                    bins SINGLE  = {SINGLE};
                                                                    bins INCR    = {INCR};
                                                                    bins WRAP4   = {WRAP4};
                                                                    bins INCR4   = {INCR4};
                                                                    bins WRAP8   = {WRAP8};
                                                                    bins INCR8   = {INCR8};
                                                                    bins WRAP16  = {WRAP16};
                                                                    bins INCR16  = {INCR16};
                                                                 }
   AHB_transfer_type:        coverpoint packet_data.HTRANS     {
                                                                    bins NONSEQ = {NONSEQ};
                                                                    bins SEQ    = {SEQ};
                                                                    bins BUSY   = {BUSY};
                                                                    bins IDLE   = {IDLE};
                                                                 }

   AHB_size:                 coverpoint packet_data.HSIZE      {
                                                                    //bins BYTE                 = {BYTE};
                                                                    //bins HALFWORD             = {HALFWORD};
                                                                    bins WORD                 = {WORD};
                                                                    ignore_bins INVALID_SIZE  = {[3:7]};
                                                                 }

   AHB_address:              coverpoint packet_data.HADDR[9:0];
   AHB_write_data:           coverpoint packet_data.HWDATA;

  //-------------------------------------------------------------Coverage for different transfer types with all possible combinations--------------------------------------------------------------------------------------------------------------

  Transfer_types_with_all_bursts: cross AHB_transfer_type, AHB_Burst_size {
                                                                              bins IDLE_transfer_with_all_bursts = binsof(AHB_transfer_type.IDLE);
                                                                              bins BUSY_transfer_with_all_bursts = binsof(AHB_transfer_type.BUSY);
                                                                              bins SEQ_transfer_with_all_bursts = binsof(AHB_transfer_type.SEQ);
                                                                              bins NONSEQ_transfer_with_all_bursts = binsof(AHB_transfer_type.NONSEQ);
                                                                              ignore_bins BUSY_in_SINGLE_Burst = binsof(AHB_transfer_type.BUSY) && binsof(AHB_Burst_size.SINGLE);
																			  ignore_bins SEQ_in_SINGLE_Burst = binsof(AHB_transfer_type.SEQ) && binsof(AHB_Burst_size.SINGLE);
                                                                          }

 Transfer_types_with_all_bursts_and_sizes: cross Transfer_types_with_all_bursts, AHB_size  {
                                                                                              //bins transfers_with_BYTE_size = binsof(AHB_size.BYTE);
                                                                                              //bins transfers_with_HALFWORD_size = binsof(AHB_size.HALFWORD);
                                                                                              bins transfers_with_WORD_size = binsof(AHB_size.WORD);
                                                                                           }
Read_Write_transfer_types_with_all_bursts_and_sizes: cross Transfer_types_with_all_bursts_and_sizes, AHB_read_write {
                                                                                                                      bins Read_transfers = binsof(AHB_read_write.AHB_read);
                                                                                                                      bins Write_transfers = binsof(AHB_read_write.AHB_write);
                                                                                                                    }
Read_Write_transfer_types_with_all_bursts_and_sizes_to_all_alaves: cross Read_Write_transfer_types_with_all_bursts_and_sizes, selection_of_two_slaves {
                                                                                                                                                            bins Slave0_transfers = binsof(selection_of_two_slaves.slave0_select);
                                                                                                                                                            bins Slave1_transfers = binsof(selection_of_two_slaves.slave1_select);
                                                                                                                                                      }

//------------------------------------------------------------------------Coverage for output signals-----------------------------------------------------------------------------------------------------------------------------------------------


   AHB_slave_response:       coverpoint packet_data.HRESP      {
                                                                    bins OKAY = {1'b0};
                                                                    bins ERROR = {1'b1};
                                                                 }

  AHB_HRDATA:                coverpoint packet_data.HRDATA;
endgroup
//------------------------------------------------------------------Sequence of operations coverage-------------------------------------------------------------------------------------------------------------------------------------------------
covergroup sequence_of_operations_coverage with function sample (logic [ADDRWIDTH-1:0] Prev_addr_1, Prev_addr_2);

  HTRANS_sop: coverpoint packet_data.HTRANS {
                                                    bins NONSEQ = {NONSEQ};	//sampled only for new transfer (all transfers start with NONSEQ)
                                                    option.weight = 0; 		//used only for cross coverage
                                                }

  selection_of_two_slaves_sop: coverpoint packet_data.HADDR[10] {
                                                                      bins slave0_select = {1'b0};
                                                                      bins slave1_select = {1'b1};
                                                                      option.weight = 0;			//used only for cross coverage
                                                                  }

  HSIZE_sop: coverpoint packet_data.HSIZE {
                                              //bins BYTE                 = {BYTE};			//Not implemented in the design
                                              //bins HALFWORD             = {HALFWORD};		//Not implemented in the design
                                              bins WORD                 = {WORD};
                                              ignore_bins INVALID_SIZE  = {[3:7]};
                                              option.weight             = 0;		//used only for cross coverage
                                            }
 HBURST_sop: coverpoint packet_data.HBURST {
                                                bins SINGLE  = {SINGLE};
                                                bins INCR    = {INCR};
                                                bins WRAP4   = {WRAP4};
                                                bins INCR4   = {INCR4};
                                                bins WRAP8   = {WRAP8};
                                                bins INCR8   = {INCR8};
                                                bins WRAP16  = {WRAP16};
                                                bins INCR16  = {INCR16};
                                                option.weight = 0;			//used only for cross coverage
                                             }

HWRITE_sop: coverpoint packet_data.HWRITE  {
                                                bins write_read_same_address =  (1=>0) iff (Prev_addr_1==packet_data.HADDR);
                                                bins read_write_same_address =  (0=>1) iff (Prev_addr_1==packet_data.HADDR);
                                                bins write_write_same_address = (1=>1) iff (Prev_addr_1==packet_data.HADDR);

                                                bins write_read_diff_address =  (1=>0) iff (Prev_addr_1!=packet_data.HADDR);
                                                bins read_write_diff_address =  (0=>1) iff (Prev_addr_1!=packet_data.HADDR);
                                                bins write_write_diff_address = (1=>1) iff (Prev_addr_1!=packet_data.HADDR);
                                                bins read_read_diff_address =   (0=>0) iff (Prev_addr_1!=packet_data.HADDR);

                                                bins write_write_read_same_address = (1=>1=>0) iff ((Prev_addr_1 == packet_data.HADDR)&&(Prev_addr_2 == packet_data.HADDR));
                                                bins write_read_write_same_address = (1=>0=>1) iff ((Prev_addr_1 == packet_data.HADDR)&&(Prev_addr_2 == packet_data.HADDR));
                                                bins read_write_read_same_address =  (0=>1=>0) iff ((Prev_addr_1 == packet_data.HADDR)&&(Prev_addr_2 == packet_data.HADDR));
                                                bins read_write_write_same_address = (0=>1=>1) iff ((Prev_addr_1 == packet_data.HADDR)&&(Prev_addr_2 == packet_data.HADDR));
                                            }

sop_with_all_Bursts: cross HWRITE_sop, HBURST_sop;
sop_with_both_slaves: cross HWRITE_sop, selection_of_two_slaves_sop;
sop_with_all_transfer_types: cross HWRITE_sop, HTRANS_sop;
sop_with_all_transfer_sizes: cross HWRITE_sop, HSIZE_sop;

endgroup

function new (string name = "AHB_coverage",uvm_component parent = null);
    super.new (name,parent);
    AHB_functional_coverage = new();
    sequence_of_operations_coverage = new();
  endfunction

 virtual function void write (AHB_packet t); // get data packet from AHB_monitor
         packet_data = t;
		 fork
            AHB_functional_coverage.sample();
            if(packet_data.HTRANS == NONSEQ)
            begin
              sequence_of_operations_coverage.sample(Prev_addr_1,Prev_addr_2);
              Prev_addr_2 = Prev_addr_1;
              Prev_addr_1 = packet_data.HADDR;
            end
         join_any
   endfunction
   
   virtual function void report_phase (uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(),$sformatf("\n\n<<FUNCTIONAL COVERAGE>>\nTOTAL FUNCTIONAL COVERAGE = %f\nCOVERAGE FOR AHB_functional_coverage COVERGROUP = %f\nCOVERAGE FOR sequence_of_operations_coverage COVERGROUP = %f\n\n",$get_coverage(),AHB_functional_coverage.get_coverage(),sequence_of_operations_coverage.get_coverage()),UVM_MEDIUM);
	endfunction
   
endclass

//----------------------------------------------End of AHB_coverage----------------------------------------------------------
