
module AMBA_APB(
  // PCLK is a clock signal. All APB signals are timed against the rising edge of PCLK.
  input logic pclk,
  // PRESETn is the reset signal and is active-LOW.
  input logic prst_n,
  // PADDR is the APB address bus. PADDR can be up to 32 bits wide.
  input logic [4:0] paddr,
  /*
    The Requester generates a PSELx signal for each Completer. 
    PSELx indicates that the Completer is selected and that a data transfer is required
  */
  input logic pselx,
  // PENABLE indicates the second and subsequent cycles of an APB transfer.
  input logic penable,
  // PWRITE indicates an APB write access when HIGH and an APB read access when LOW.
  input logic pwrite,
  /*
    The PWDATA write data bus is driven by the APB bridge Requester during write cycles when PWRITE is HIGH.
    PWDATA can be 8, 16, or 32 bits wide.
  */
  input logic [31:0] pwdata,
  // PREADY is used to extend an APB transfer by the Completer.
  output logic pready,
  /*
    The PRDATA read data bus is driven by the selected Completer during read cycles when PWRITE is LOW.
    PRDATA can be 8, 16, or 32 bits wide.
  */
  output logic [31:0] prdata
);
  
  reg [31:0] mem[31:0];
  

  typedef enum {
    IDLE    = 0,
    SETUP   = 1,
    ACCESS  = 2,
    XXX     = 3
  } state_e;

  state_e state, next;
  


  always_ff @(posedge pclk or negedge prst_n) begin
    if (!prst_n) begin
      state <= IDLE;
      pready <= 0;
      prdata <= 0;
    end
    else begin
      state <= XXX;
      pready <= 0;
      case (state)
        IDLE: begin
          if (pselx & !penable) begin
            state <= SETUP;
          end
          else begin
            state <= IDLE;
          end
        end
        SETUP: begin
          /*
          Question:
            Should the rtl go into ACCESS state no matter the value of penable and pselx signals?
          Spec:
            The interface only remains in the SETUP state for one clock cycle and
            always moves to the ACCESS state on the next rising edge of the clock.
          */
          if (penable & pselx)  begin
            state <= ACCESS;
          end
          else begin
            state <= XXX;
          end
        end
        ACCESS: begin
          if (pwrite) begin
            mem[paddr] <= pwrite ? pwdata : mem[paddr];
          end
          else begin
            prdata     <= mem[paddr];
          end
          pready <= 1;
          state <= IDLE;
        end
        default: begin
          next = IDLE;
        end
      endcase
    end
  end
endmodule