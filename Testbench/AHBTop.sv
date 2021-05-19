import AHBpkg::*;
import uvm_pkg::*;

module top();
  
  bit HCLK;
  logic HRESETn;
  
  AHBInterface intf(HCLK,HRESETn);      //Interface handle
  
  AHBSlaveTop DUT (intf.slave);        //DUT instantiation
  
  always #10 HCLK = ~HCLK;
  
  initial
    begin
      uvm_config_db #(virtual AHBInterface) :: set (null,"*","interface",intf);
      
      run_test();
      
      $finish();
  end
endmodule
  
