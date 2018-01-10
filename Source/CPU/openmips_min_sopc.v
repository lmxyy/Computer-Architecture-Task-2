`ifdef openmips_min_sopc.v
`else
 `define openmips_min_sopc.v
// --------------------------------------------------------------------------------
 `include "defines.v"
 `include "openmips.v"
 // `include "inst_rom.v"
 // `include "data_ram.v"
 `include "mem_sim.v"

module openmips_min_sopc
  (
   input wire clk,
   input wire rst
   );

   wire [`InstAddrBus] inst_addr;
   wire [`InstBus]     inst;
   wire 	       ce;

   wire 	       mem_we_i;
   wire [`RegBus]      mem_addr_i;
   wire [`RegBus]      mem_data_i;
   wire [`RegBus]      mem_data_o;
   wire [3:0] 	       mem_sel_i;  

   openmips openmips0
     (
      .clk(clk),
      .rst(rst),
      
      .rom_addr_o(inst_addr),
      .rom_data_i(inst),
      .rom_ce_o(rom_ce),      

      .ram_data_i(mem_data_o),
      .ram_addr_o(mem_addr_i),
      .ram_data_o(mem_data_i),
      .ram_we_o(mem_we_i),
      .ram_sel_o(mem_sel_i),
      .ram_ce_o(mem_ce_i)		
      );

   mem_sim mem_sim0
     (
      .clk(clk),
      .rom_ce(rom_ce_i),
      .mem_ce(mem_ce_i),
      
      .pc_addr(inst_addr),
      .inst(inst),

      .we(mem_we_i),
      .addr(mem_addr_i),
      .sel(mem_sel_i),
      .data_i(mem_data_i),
      .data_o(mem_data_o)
      );
   
endmodule // openmips_min_sopc

// --------------------------------------------------------------------------------
`endif
