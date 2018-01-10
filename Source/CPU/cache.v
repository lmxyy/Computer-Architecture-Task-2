`ifdef cache.v
`else
 `define cache.v
// ----------------------------------------------------------------------------------------------------
 `include "defines.v"

module cache
  #(
    parameter WORD_SELECT_BIT = 3,
    parameter INDEX_BIT = 2,
    parameter NASSOC = 2
    )
   (
    input 	      clk,
    input 	      rst,

    // About CPU
    input [31:0]      addr,

    input 	      read_flag,
    output reg [31:0] read_data,

    input [31:0]      write_data,
    input [3:0]       write_mask,
    input 	      write_flag,

    // About memory
    output reg 	      cache_req_o,
    output reg [31:0] cache_addr_o,

    output reg 	      cache_write_o,
    output reg [63:0] cache_write_data_o,
    output reg [8:0]  cache_write_mask_o,
    
    input 	      cache_rep_i,
    input [63:0]      cache_rep_data_i,

    // About control
    output reg 	      stallreq
    );

   parameter NBLOCK = 1<<INDEX_BIT;
   parameter TAG_BIT = 32-2-INDEX_BIT-WORD_SELECT_BIT;
   
   wire [TAG_BIT-1:0] addr_tag = addr[31:31-5+1]; // TAG
   wire [INDEX_BIT-1:0] addr_index = addr[WORD_SELECT_BIT+INDEX_BIT-1:WORD_SELECT_BIT]; // index

   reg [TAG_BIT-1:0] 	      ctag[NASSOC-1:0][NBLOCK-1:0];
   reg 			      cvalid[NASSOC-1:0][NBLOCK-1:0];
   reg [7:0] 		      cdata[NASSOC-1:0][NBLOCK-1:0][1<<WORD_SELECT_BIT:0];
      
   reg 			      hit;

   reg 			      crep[NBLOCK-1:0];
   
   integer 		      i,j,k;
   always @ (*)
     begin
   	if (rst == `RstEnable)
   	  begin
	     for (i = 0;i < NASSOC;i = i+1)
	       for (j = 0;j < NBLOCK;j = j+1)
		 begin
		    ctag[i][j] <= 0;
		    cvalid[i][j] <= 0;
		    for (k = 0;k < (1<<WORD_SELECT_BIT);k = k+1)
		      cdata[i][j][k] <= 0;
		 end
	     for (i = 0;i < NBLOCK;i = i+1) crep[i] = 0;
	     hit <= 0;
	     read_data <= 0;
	     cache_req_o <= 0;
	     cache_addr_o <= 0;
	     cache_write_o <= 0;
	     cache_write_data_o <= 0;
	     cache_write_mask_o <= 0;
	     stallreq <= 0;
   	  end
     end
   
   // --------------------------------------------------Read--------------------------------------------------
   always @ (read_flag == 1'b1)
     begin
	hit <= 0;
	read_data <= 0;
	cache_req_o <= 0;
	cache_addr_o <= 0;
	cache_write_o <= 0;
	cache_write_data_o <= 0;
	cache_write_mask_o <= 0;
	stallreq <= 0;
   	if (ctag[0][addr_index] == addr_tag&&cvalid[0][addr_index] == 1'b1)
   	  begin
   	     hit <= 1'b1;
   	     crep[addr_index] <= 1;
   	     if (addr[2] == 0)
   	       read_data <= {cdata[0][addr_index][0],cdata[0][addr_index][1],
   			     cdata[0][addr_index][2],cdata[0][addr_index][3]};
   	     if (addr[2] == 1)
   	       read_data <= {cdata[0][addr_index][4],cdata[0][addr_index][5],
   			     cdata[0][addr_index][6],cdata[0][addr_index][7]};
   	  end // if (ctag[0][addr_index] == addr_tag&&cvalid[0][addr_index] == 1'b1)
	
   	if (ctag[1][addr_index] == addr_tag&&cvalid[1][addr_index] == 1'b1)
   	  begin
   	     hit <= 1'b1;
   	     crep[addr_index] <= 0;
   	     if (addr[2] == 0)
   	       read_data <= {cdata[1][addr_index][0],cdata[1][addr_index][1],
   			     cdata[1][addr_index][2],cdata[1][addr_index][3]};
   	     if (addr[2] == 1)
   	       read_data <= {cdata[1][addr_index][4],cdata[1][addr_index][5],
   			     cdata[1][addr_index][6],cdata[1][addr_index][7]};
   	  end // if (ctag[1][addr_index] == addr_tag&&cvalid[1][addr_index] == 1'b1)
	
   	if (hit == 1'b0)
   	  begin
   	     stallreq <= 1'b1;
   	     cache_addr_o <= addr;
   	     cache_req_o <= 1'b1;
   	  end	
     end // always @ (read_flag == 1'b1)
   
   always @ (cache_rep_i == 1'b1)   
     begin

	if (crep[addr_index] == 1'b0)
	  begin
	     cvalid[0][addr_index] <= 1'b1;
	     ctag[0][addr_index] <= addr_tag;
	     cdata[0][addr_index][0] <= cache_rep_data_i[7:0];
	     cdata[0][addr_index][1] <= cache_rep_data_i[15:8];
	     cdata[0][addr_index][2] <= cache_rep_data_i[23:16];
	     cdata[0][addr_index][3] <= cache_rep_data_i[31:24];
	     cdata[0][addr_index][4] <= cache_rep_data_i[39:32];
	     cdata[0][addr_index][5] <= cache_rep_data_i[47:40];
	     cdata[0][addr_index][6] <= cache_rep_data_i[55:48];
	     cdata[0][addr_index][7] <= cache_rep_data_i[63:56];
	  end

	if (crep[addr_index] == 1'b1)
	  begin
	     cvalid[1][addr_index] <= 1'b1;
	     ctag[1][addr_index] <= addr_tag;
	     cdata[1][addr_index][0] <= cache_rep_data_i[7:0];
	     cdata[1][addr_index][1] <= cache_rep_data_i[15:8];
	     cdata[1][addr_index][2] <= cache_rep_data_i[23:16];
	     cdata[1][addr_index][3] <= cache_rep_data_i[31:24];
	     cdata[1][addr_index][4] <= cache_rep_data_i[39:32];
	     cdata[1][addr_index][5] <= cache_rep_data_i[47:40];
	     cdata[1][addr_index][6] <= cache_rep_data_i[55:48];
	     cdata[1][addr_index][7] <= cache_rep_data_i[63:56];
	  end
	
     end // always @ (cache_rep_i == 1'b1)
   
   // --------------------------------------------------Write--------------------------------------------------
   always @ (write_flag == 1'b1)
     begin
	hit <= 0;
	read_data <= 0;
	cache_req_o <= 0;
	cache_addr_o <= addr;
	cache_write_o <= 1;
	cache_write_data_o <= 0;
	cache_write_mask_o <= 0;
	stallreq <= 0;
   	if (ctag[0][addr_index] == addr_tag&&cvalid[0][addr_index] == 1'b1)
   	  begin
   	     hit <= 1'b1;
   	     crep[addr_index] <= 1;
   	     if (addr[2] == 0)
	       begin
		  if (write_mask[0] == 1'b1)
		    cdata[0][addr_index][3] <= write_data[7:0];
		  if (write_mask[1] == 1'b1)
		    cdata[0][addr_index][2] <= write_data[15:8];
		  if (write_mask[2] == 1'b1)
		    cdata[0][addr_index][1] <= write_data[23:16];
		  if (write_mask[3] == 1'b1)
		    cdata[0][addr_index][0] <= write_data[31:24];
		  cache_write_data_o <= {cdata[0][addr_index][7],cdata[0][addr_index][6],
					 cdata[0][addr_index][5],cdata[0][addr_index][4],
					 write_data[7:0],write_data[15:8],
					 write_data[23:16],write_data[31:24]};
		  cache_write_mask_o <= {4'h0,write_mask};
	       end
   	     if (addr[2] == 1)
	       begin
		  if (write_mask[0] == 1'b1)
		    cdata[0][addr_index][7] <= write_data[7:0];
		  if (write_mask[1] == 1'b1)
		    cdata[0][addr_index][6] <= write_data[15:8];
		  if (write_mask[2] == 1'b1)
		    cdata[0][addr_index][5] <= write_data[23:16];
		  if (write_mask[3] == 1'b1)
		    cdata[0][addr_index][4] <= write_data[31:24];
		  cache_write_data_o <= {write_data[7:0],write_data[15:8],write_data[23:16],write_data[31:24],
					 cdata[0][addr_index][3],cdata[0][addr_index][2],
					 cdata[0][addr_index][1],cdata[0][addr_index][0]};
		  cache_write_mask_o <= {write_mask,4'h0};
	       end
   	  end

   	if (ctag[1][addr_index] == addr_tag&&cvalid[1][addr_index] == 1'b1)
   	  begin
   	     hit <= 1'b1;
   	     crep[addr_index] <= 0;
   	     if (addr[2] == 0)
	       begin
		  if (write_mask[0] == 1'b1)
		    cdata[1][addr_index][3] <= write_data[7:0];
		  if (write_mask[1] == 1'b1)
		    cdata[1][addr_index][2] <= write_data[15:8];
		  if (write_mask[2] == 1'b1)
		    cdata[1][addr_index][1] <= write_data[23:16];
		  if (write_mask[3] == 1'b1)
		    cdata[1][addr_index][0] <= write_data[31:24];
		  cache_write_data_o <= {cdata[1][addr_index][7],cdata[1][addr_index][6],
					 cdata[1][addr_index][5],cdata[1][addr_index][4],
					 write_data[7:0],write_data[15:8],write_data[23:16],write_data[31:24]};
		  cache_write_mask_o <= {4'h0,write_mask};
	       end
   	     if (addr[2] == 1)
	       begin
		  if (write_mask[0] == 1'b1)
		    cdata[1][addr_index][7] <= write_data[7:0];
		  if (write_mask[1] == 1'b1)
		    cdata[1][addr_index][6] <= write_data[15:8];
		  if (write_mask[2] == 1'b1)
		    cdata[1][addr_index][5] <= write_data[23:16];
		  if (write_mask[3] == 1'b1)
		    cdata[1][addr_index][4] <= write_data[31:24];
		  cache_write_data_o <= {write_data[7:0],write_data[15:8],write_data[23:16],write_data[31:24],
					 cdata[1][addr_index][3],cdata[1][addr_index][2],
					 cdata[1][addr_index][1],cdata[1][addr_index][0]};
		  cache_write_mask_o <= {write_mask,4'h0};
	       end
   	  end

   	if (hit == 1'b0)
   	  begin
	     cache_write_data_o <= {write_data,write_data};
	     if (addr[2] == 0)
	       cache_write_mask_o <= {4'h0,write_mask};
	     if (addr[2] == 1)
	       cache_write_mask_o <= {write_mask,4'h0};
   	  end
	
     end // always @ (write_flag == 1'b1)
   
endmodule // cache

// ----------------------------------------------------------------------------------------------------
`endif
