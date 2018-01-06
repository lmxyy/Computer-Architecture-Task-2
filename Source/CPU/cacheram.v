`ifdef cacheram.v
`else
 `define cacheram.v
// ----------------------------------------------------------------------------------------------------

 `include "defines.h"

module cacheram
  #(
    parameter ADDR_WIDTH = 16,
    parameter DATA_BYTE_WIDTH = 4
    )
  (
   input 			      clk,
   input 			      rst,

   output reg [8*DATA_BYTE_WIDTH-1:0] read_data,
   input [ADDR_WIDTH-1:0] 	      read_addr,
   input 			      read_flag,

   input [8*DATA_BYTE_WIDTH-1:0]      write_data,
   input [ADDR_WIDTH-1:0] 	      write_addr,
   input [DATA_BYTE_WIDTH-1:0] 	      write_mask,
   input 			      write_flag    
   );
   
   reg [8*DATA_BYTE_WIDTH-1:0] 	      data[(1<<ADDR_WIDTH-)-1:0];

   always @ (posedge clk)
     begin
	if (rst) read_data <= 0;
	else
	  begin
	     if (read_flag) read_data <= data[read_addr];
	     
	  end
     end	      

endmodule // cacheram


// ----------------------------------------------------------------------------------------------------
`endif
