interface apb_interface(
  // PCLK is a clock signal. All APB signals are timed against the rising edge of PCLK.
  input logic pclk,
  input logic prst
);
  // PADDR is the APB address bus. PADDR can be up to 32 bits wide.
  logic [4:0] paddr;
  /*
    The Requester generates a PSELx signal for each Completer. 
    PSELx indicates that the Completer is selected and that a data transfer is required
  */
  logic pselx;
  // PENABLE indicates the second and subsequent cycles of an APB transfer.
  logic penable;
  // PWRITE indicates an APB write access when HIGH and an APB read access when LOW.
  logic pwrite;
  /*
    The PWDATA write data bus is driven by the APB bridge Requester during write cycles when PWRITE is HIGH.
    PWDATA can be 8, 16, or 32 bits wide.
  */
  logic [31:0] pwdata;
  // PREADY is used to extend an APB transfer by the Completer.
  logic pready;
  /*
    The PRDATA read data bus is driven by the selected Completer during read cycles when PWRITE is LOW.
    PRDATA can be 8, 16, or 32 bits wide.
  */
  logic [31:0] prdata;

  import globals_pkg::*;

  clocking drv_blk @(posedge pclk);
    default input #(T_APB_CLK_NS/10 *1ns) output #(T_APB_CLK_NS/2 *1ns); 
    output paddr;
    output pselx;
    output penable;
    output pwrite;
    output pwdata;

    input pready;
    input prdata;
  endclocking: drv_blk


  clocking mon_blk @(posedge pclk);
    input paddr;
    input pselx;
    input penable;
    input pwrite;
    input pwdata;

    input pready;
    input prdata;
  endclocking: mon_blk


endinterface