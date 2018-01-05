`ifdef pdt.v
`else
 `define pdt.v
// --------------------------------------------------------------------------------
 `include "defines.v"

module pdt(
	   input wire 		     rst,

	   input wire [`InstAddrBus] if_pc,
	   input wire [`InstBus]     if_inst,

	   input wire 		     id_is_branch,
	   input wire 		     true_or_not,
	   input wire 		     pdt_true,
	   
	   output reg 		     branch_or_not, 
	   output reg [`InstAddrBus] pdt_pc,
	   output reg 		     pdt_res,
	   output reg 		     pdt_choice,
	   output reg 		     stallreq
	   );

   reg [11:0] 			     history;
   reg [1:0] 			     alloyed_branch_predictor[0:1023];
   reg [1:0] 			     global_branch_predictor[0:4095];
   reg [1:0] 			     local_branch_predictor[0:1023][0:15];
   integer 			     i,j;
	

   always @ (*)
     begin
	
	if (rst == `RstEnable)
	  begin
	     history <= 12'b0;
	     for (i = 0;i < 1024;i = i+1)
	       alloyed_branch_predictor[i] <= 2'b0;
	     for (i = 0;i < 4096;i = i+1)
	       global_branch_predictor[i] <= 2'b0;
	     for (i = 0;i < 1024;i = i+1)
	       for (j = 0;j < 16;j = j+1)
		 local_branch_predictor[i][j] <= 2'b0;
	     branch_or_not <= 1'b0;
	     pdt_pc <= `Zeroword;
	     pdt_res <= 1'b0;
	     pdt_choice <= 1'b0;
	     stallreq <= 1'b0;
	  end // if (rst == `RstEnable)

	else if (if_inst[6:0] == 7'b1100011)
	  begin
	     
	  end

	else branch_or_not <= 1'b0;
     end // always @ (*)

   always @ (id_is_branch == 1'b1)
     begin
	history <= (history<<1|true_or_not);
	if (pdt_true == 1)
	  begin
	  end
	else
	  begin
	  end
     end
   
endmodule // regfile

// --------------------------------------------------------------------------------
`endif
