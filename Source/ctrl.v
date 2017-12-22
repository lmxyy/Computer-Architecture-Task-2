`ifdef ctrl.v
`else
 `define ctrl.v
// ----------------------------------------------------------------------------------------------------
`include "defines.v"

module ctrl(
	    input wire 	     rst,
	    input wire 	     stallreq_from_id,

	    output reg [5:0] stall       
	    );

   always @ (*) 
     begin
	if(rst == `RstEnable) stall <= 6'b000000;
	else if(stallreq_from_id == 1'b1) stall <= 6'b000010;
	else stall <= 6'b000000;
     end // always @ (*)
   
endmodule // ctrl

// ----------------------------------------------------------------------------------------------------
`endif
