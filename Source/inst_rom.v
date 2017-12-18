`ifdef inst_rom.v
`else
 `define inst_rom.v
// --------------------------------------------------------------------------------
 `include "defines.v"

module inst_rom(
		input wire 		  ce,
		input wire [`InstAddrBus] addr,
		output reg [`InstBus] 	  inst
	      );

   reg[`InstBus]  inst_mem[0:`InstMemNum];
   
   initial $readmemh ("instr.data",inst_mem);

   always @ (*)
     begin
	if (ce == `ChipDisable) inst <= `ZeroWord;
	else 
	  inst <= {inst_mem[addr>>2][7:0],inst_mem[addr>>2][15:8],
		   inst_mem[addr>>2][23:16],inst_mem[addr>>2][31:24]};
     end

endmodule // inst_rom

// --------------------------------------------------------------------------------
`endif
