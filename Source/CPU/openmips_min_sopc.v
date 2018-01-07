`ifdef openmips_min_sopc.v
`else
`define openmips_min_sopc.v
// --------------------------------------------------------------------------------
`include "defines.h"
`include "openmips.v"
`include "inst_rom.v"
`include "data_ram.v"
`include "cache.v"

module openmips_min_sopc
  (
   input wire clk,
   input wire rst
   );

   //连接指令存储器
   wire [`InstAddrBus] inst_addr;
   wire [`InstBus]     inst;
   wire 	       rom_ce;

   wire 	       mem_we_i;
   wire [`RegBus]      mem_addr_i;
   wire [`RegBus]      mem_data_i;
   wire [`RegBus]      mem_data_o;
   wire [3:0] 	       mem_sel_i;  
   wire 	       mem_ce_i;     

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

   wire 	       if_cache_busy;
   wire 	       if_cache_done;

   wire [1:0]	       if_cache_mem_rw_flag;
   wire [31:0] 	       if_cache_mem_addr;
   wire [31:0] 	       if_cache_mem_write_data;
   wire [3:0]	       if_cache_mem_write_mask;
   
   wire [31:0]	       if_cache_mem_read_data;

   wire 	       mem_cache_busy;
   wire 	       mem_cache_done;

   wire [1:0]	       mem_cache_mem_rw_flag;
   wire [31:0] 	       mem_cache_mem_addr;
   wire [31:0] 	       mem_cache_mem_write_data;
   wire [3:0]	       mem_cache_mem_write_mask;
   
   wire [31:0]	       mem_cache_mem_read_data;
   
   cache if_cache
     (
      .clk(clk),
      .rst(rst),

      .rw_flag_(2'b01),
      .addr_(inst_addr),
      .read_data(inst),
      .write_data_(`ZeroWord),
      .write_mask_(4'h0),
      .busy(if_cache_busy),
      .done(if_cache_done),

      .flush_flag(1'b1),
      .flush_addr(`ZeroWord),
      
      .mem_rw_flag(if_cache_mem_rw_flag),
      .mem_addr(if_cache_mem_addr),
      .mem_read_data(if_cache_mem_read_data),
      .mem_write_data(if_cache_mem_write_data),
      .mem_write_mask(if_cache_mem_write_mask),
      .mem_busy(1'b0),
      .mem_done(1'b1)
      );
   
   
   inst_rom inst_rom0
     (
      // .addr(inst_addr),
      // .inst(inst),
      // .ce(rom_ce)
      .addr(if_cache_mem_addr),
      .inst(if_cache_mem_read_data),
      
      .ce(rom_ce)
      );


   cache mem_cache
     (
      .clk(clk),
      .rst(rst),

      .rw_flag_({mem_we_i,~mem_we_i}),
      .addr_(mem_addr_i),
      .read_data(mem_data_o),
      .write_data_(mem_data_i),
      .write_mask_(mem_sel_i),
      .busy(mem_cache_busy),
      .done(mem_cache_done),

      .flush_flag(1'b1),
      .flush_addr(`ZeroWord),
      
      .mem_rw_flag(mem_cache_mem_rw_flag),
      .mem_addr(mem_cache_mem_addr),
      .mem_read_data(mem_cache_mem_read_data),
      .mem_write_data(mem_cache_mem_write_data),
      .mem_write_mask(mem_cache_mem_write_mask),
      .mem_busy(1'b0),
      .mem_done(1'b1)
      );
   
   data_ram data_ram0
     (
      .clk(clk),
      .we(mem_cache_mem_rw_flag[1]),

      .addr(mem_cache_mem_addr),
      .sel(mem_cache_mem_write_mask),
      .data_i(mem_cache_mem_write_data),
      .data_o(mem_cache_mem_read_data),
      .ce(mem_ce_i)		
      );
   
endmodule // openmips_min_sopc

// --------------------------------------------------------------------------------
`endif
