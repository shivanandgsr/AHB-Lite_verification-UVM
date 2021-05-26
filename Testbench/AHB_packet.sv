class AHB_packet;
    logic HREADY;
    logic HWRITE;
    logic [1:0]  HRESP;
    logic [1:0]  HTRANS;
    logic [2:0]  HBURST;
    logic [2:0]  HSIZE;
    logic [31:0] HADDR;
    logic [31:0] HWDATA;
    logic [31:0] HRDATA;
endclass
