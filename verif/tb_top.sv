`include "uvm_macros.svh"
import uvm_pkg::*;

module tb_top;
 
  reg top_clk;
  reg top_rst;
  
  apb_interface apb_if(
    .pclk(top_clk),
    .prst(top_rst)
  );


  AMBA_APB dut(
    .pclk(top_clk),
    .prst_n(!top_rst),
    
    .paddr(apb_if.paddr),
    .pselx(apb_if.pselx),
    .penable(apb_if.penable),
    .pwrite(apb_if.pwrite),
    .pwdata(apb_if.pwdata),
    .pready(apb_if.pready),
    .prdata(apb_if.prdata)
  );

  initial begin
    top_clk <= 0;

    forever begin
      #10ns;
      top_clk <= ~top_clk;
    end
  end

  initial begin
    top_rst <= 1;
    #33ns;
    top_rst <= 0;
  end
  

  import test_list_pkg::*;
  initial begin
    run_test();
  end
  
  initial begin
    uvm_config_db#(virtual apb_interface)::set(null, "uvm_test_top", "apb_if", apb_if);
  end


  class test_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;

    constraint c_addr {
      addr inside {[0 : 300]};
    }
  endclass: test_item

endmodule: tb_top