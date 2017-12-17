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

   reg[`InstBus]  inst_mem[0:1];
   
   initial $readmemb ("instr.data",inst_mem);
   // initial
   //   begin
   // 	inst_mem[0] = 32'b00010000000000000110000010010011;
   // 	inst_mem[1] = 32'h34020020;
   // 	inst_mem[2] = 32'h3403ff00;
   // 	inst_mem[3] = 32'h3404ffff;
     // end

   always @ (*)
     begin
	if (ce == `ChipDisable) inst <= `ZeroWord;
	else
	  inst <= inst_mem[addr[`InstMemNumLog2+1:2]];
     end

endmodule // inst_rom

// --------------------------------------------------------------------------------
`endif
