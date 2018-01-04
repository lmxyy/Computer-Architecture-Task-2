`ifdef uart_com.v
`else
 `define uart_com.v
// ----------------------------------------------------------------------------------------------------
 `include "buf_que.v"
 `include "defines.v"

module uart_com
  #(
    parameter BAUDRATE = 9600,
    parameter CLOCKRATE = 100000000
    )
  (
   input       clk,
   input       rst,
   
   input       send_flag,
   input [7:0] send_data,
   input       recv_flag, 
   input [7:0] recv_data,

   output      sendable,
   output      receivable,

   input       Rx,
   output      Tx
   );

   localparam SAMPLE_INTERVAL = CLOCKRATE / BAUDRATE;
   
   localparam STATUS_IDLE = 0;
   localparam STATUS_BEGIN = 1;
   localparam STATUS_DATA = 2;
   localparam STATUS_VALID = 4;
   localparam STATUS_END = 8;

   
   // --------------------------------------------------Receive--------------------------------------------------
   // Computer to FPGA
   reg 		   recv_write_flag;
   reg [7:0] 	   recv_write_data;
   wire 	   recv_empty,recv_full;

   assign receivable = !recv_empty;

   reg [3:0] 	   recv_status;
   reg [2:0] 	   recv_bit;
   reg 		   recv_parity;
   
   integer 	   recv_counter;
   reg 		   recv_clock;

   
   // --------------------------------------------------Send--------------------------------------------------
   // FPGA to Computer
   
endmodule // uart_com

// ----------------------------------------------------------------------------------------------------
`endif
