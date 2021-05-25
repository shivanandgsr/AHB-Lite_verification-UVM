class AHB_coverage extends uvm_subscriber #(AHB_sequence_item);

  `uvm_component_utils(AHB_coverage)

  AHB_sequence_item seq_item_data;

  covergroup AHB_inputs_coverage;
//------------------------------------------------------------------------Coverage for inputs to  DUT--------------------------------------------------------------------------------------------------

   selection_of_two_slaves:  coverpoint seq_item_data.HADDR[10]  {
                                                                    bins slave0_select = {1'b0};
                                                                    bins slave1_select = {1'b1};
                                                                 }

   AHB_read_write:           coverpoint seq_item_data.HWRITE     {
                                                                    bins AHB_read = {1'b0};
                                                                    bins AHB_write = {1'b1};
                                                                 }
   AHB_Burst_size:           coverpoint seq_item_data.HBURST     {
                                                                    bins SINGLE  = {SINGLE};
                                                                    bins INCR    = {INCR};
                                                                    bins WRAP4   = {WRAP4};
                                                                    bins INCR4   = {INCR4};
                                                                    bins WRAP8   = {WRAP8};
                                                                    bins INCR8   = {INCR8};
                                                                    bins WRAP16  = {WRAP16};
                                                                    bins INCR16  = {INCR16};

                                                                 }
   AHB_transfer_type:        coverpoint seq_item_data.HTRANS     {
                                                                    bins NONSEQ = {NONSEQ};
                                                                    bins SEQ    = {SEQ};
                                                                    bins BUSY   = {BUSY};
                                                                    bins IDLE   = {IDLE};
                                                                 }

   AHB_size:                 coverpoint seq_item_data.HSIZE      {
                                                                    bins BYTE                 = {BYTE};
                                                                    bins HALFWORD             = {HALFWORD};
                                                                    bins WORD                 = {WORD};
                                                                    ignore_bins INVALID_SIZE  = {[3:7]};
                                                                 }

   AHB_address:              coverpoint seq_item_data.HADDR[9:0] {
                                                                    bins all_zeros = {'0};
                                                                    bins all_ones  = {'1};
                                                                    bins other_than_boundaries = default;
                                                                 }
   AHB_write_data:           coverpoint seq_item_data.HWDATA     {
                                                                    bins all_zeros = {'0};
                                                                    bins all_ones  = {'1};
                                                                    bins other_than_boundaries = default;
                                                                 }

  //-------------------------------------------------------------Coverage for different transfer types with all possible combinations--------------------------------------------------------------------------------------------------------------

  Transfer_types_with_all_bursts: cross AHB_transfer_type, AHB_Burst_size {
                                                                              bins IDLE_transfer_with_all_bursts = binsof(AHB_transfer_type.IDLE);
                                                                              bins BUSY_transfer_with_all_bursts = binsof(AHB_transfer_type.BUSY);
                                                                              bins SEQ_transfer_with_all_bursts = binsof(AHB_transfer_type.SEQ);
                                                                              bins NONSEQ_transfer_with_all_bursts = binsof(AHB_transfer_type.NONSEQ);
                                                                              ignore_bins BUSY_in_SINGLE_Burst = (binsof(AHB_transfer_type.BUSY) || binsof(AHB_transfer_type.SEQ)) && (binsof(AHB_Burst_size.SINGLE);
                                                                          }

 Transfer_types_with_all_bursts_and_sizes: cross Transfer_types_with_all_bursts, AHB_size  {
                                                                                              bins transfers_with_BYTE_size = binsof(AHB_size.BYTE);
                                                                                              bins transfers_with_HALFWORD_size = binsof(AHB_size.HALFWORD);
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

//---------------------------------------------------------Coverage for Boundary conditions---------------------------------------------------------------------------------------------------------------------------------------------------------


  Boundary_check_for_slaves:           cross selection_of_two_slaves,AHB_address;

  Read_write_transfers_at_boundaries:  cross Boundary_check_for_slaves, AHB_read_write {
                                                                                          bins Read_transfer_at_boundaries = binsof(AHB_read_write.AHB_read);
                                                                                          bins Write_transfer_at_boundaries = binsof(AHB_read_write.AHB_write);
                                                                                       }

  Boundaries_with_all_zeros_and_ones:  cross Boundary_check_for_slaves,AHB_write_data;

//------------------------------------------------------------------------Coverage for output signals-----------------------------------------------------------------------------------------------------------------------------------------------


   AHB_slave_response:       coverpoint seq_item_data.HRESP      {
                                                                    bins OKAY = {1'b0};
                                                                    bins ERROR = {1'b1};
                                                                 }

  AHB_HRDATA:                coverpoint seq_item_data.HRDATA     {
                                                                    bins all_ones = {'1};
                                                                    bins all_zeros = {'0};
                                                                    bins other_than_boundaries = default;
                                                                 }
  }