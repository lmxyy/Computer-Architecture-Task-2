`ifdef pc_reg.v
`else
 `define pc_reg.v
// --------------------------------------------------------------------------------
 `include "defines.v"

module pc_reg(
	      input wire 		clk,
	      input wire 		rst,

	      // From ctrl
	      input wire [5:0] 		stall,
	      
	      // From id
	      input wire 		branch_flag_i,
	      input wire [`RegBus] 	branch_target_address_i,

	      output reg [`InstAddrBus] pc,
	      output reg 		ce
	      );

   always @ (posedge clk)
     begin
	if (ce == `ChipDisable) pc <= 32'h0000000;
	else if (stall[0] == 1'b0)
	  begin 
	     if (branch_flag_i == 1'b1)
	       begin
		  pc <= {branch_target_address_i[31:1],1'b0};
		  $display("Pc register jump to %d.",{2'b0,branch_target_address_i[31:2]});
	       end
	     else pc <= pc+4'h4;
	  end
	// $display("pc: %d",pc);
	
     end

   always @ (posedge clk)
     begin
	if (rst == `RstEnable) ce <= `ChipDisable;
	else ce <= `ChipEnable;
     end

endmodule // pc_reg

// --------------------------------------------------------------------------------
`endif
