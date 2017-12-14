`ifdef id.v
`else
 `define id.v
// --------------------------------------------------------------------------------
 `include "defines.v"

module id(
	  input wire 		    rst,
	  input wire [`InstAddrBus] pc_i,
	  input wire [`InstBus]     inst_i,
	  
	  //处于执行阶段的指令要写入的目的寄存器信息
	  input wire 		    ex_wreg_i,
	  input wire [`RegBus] 	    ex_wdata_i,
	  input wire [`RegAddrBus]  ex_wd_i,

	  //处于访存阶段的指令要写入的目的寄存器信息
	  input wire 		    mem_wreg_i,
	  input wire [`RegBus] 	    mem_wdata_i,
	  input wire [`RegAddrBus]  mem_wd_i,

	  input wire [`RegBus] 	    reg1_data_i,
	  input wire [`RegBus] 	    reg2_data_i,

	  //送到regfile的信息
	  output reg 		    reg1_read_o,
	  output reg 		    reg2_read_o, 
	  output reg [`RegAddrBus]  reg1_addr_o,
	  output reg [`RegAddrBus]  reg2_addr_o, 

	  //送到执行阶段的信息
	  output reg [`AluOpBus]    aluop_o,
	  output reg [`AluSelBus]   alusel_o,
	  output reg [`RegBus] 	    reg1_o,
	  output reg [`RegBus] 	    reg2_o,
	  output reg [`RegAddrBus]  wd_o,
	  output reg 		    wreg_o
	  );

   wire [9:0] 			    op = {inst_i[14:12],inst_i[6:0]};
   reg [`RegBus] 		    imm;

   always @ (*) begin
      if (rst == `RstEnable)
	begin
	   aluop_o <= `EXE_NOP_OP;
	   alusel_o <= `EXE_RES_NOP;
	   wd_o <= `NOPRegAddr;
	   wreg_o <= `WriteDisable;
	   reg1_read_o <= 1'b0;
	   reg2_read_o <= 1'b0;
	   reg1_addr_o <= `NOPRegAddr;
	   reg2_addr_o <= `NOPRegAddr;
	   imm <= `ZeroWord;
	end // if (rst == `RstEnable)
      else
	begin
	   aluop_o <= `EXE_NOP_OP;
	   alusel_o <= `EXE_RES_NOP;
	   wd_o <= inst_i[20:16];
	   wreg_o <= `WriteDisable;
	   reg1_read_o <= 1'b0;
	   reg2_read_o <= 1'b0;
	   reg1_addr_o <= inst_i[19:15];
	   reg2_addr_o <= inst_i[24:20];		
	   imm <= `ZeroWord;
	   case (op)
	     `EXE_ORI:
	       begin
		  wreg_o <= `WriteEnable;
		  aluop_o <= `EXE_OR_OP;
		  alusel_o <= `EXE_RES_LOGIC; 
		  reg1_read_o <= 1'b1;	
		  reg2_read_o <= 1'b0;	  	
		  imm <= {16'h0,inst_i[31:20]};		
		  wd_o <= inst_i[11:7];
	       end // case: `EXE_ORI
	     default: begin end
	   endcase // case (op)
	end // else: !if(rst == `RstEnable)
   end // always @ (*)

 `define GET_OPRAND(reg_o,reg_read_o,reg_data_i,reg_addr_o) \ 
   always @ (*) \ 
     begin \ 
 	if(rst == `RstEnable) reg_o <= `ZeroWord; \ 
	  else if ((reg_read_o == 1'b1)&&(ex_wreg_i == 1'b1)&&(ex_wd_i == reg_addr_o)) \ 
				reg_o <= ex_wdata_i; \ 
				  else if ((reg_read_o == 1'b1)&&(mem_wreg_i == 1'b1)&&(mem_wd_i == reg_addr_o)) \ 
							reg_o <= mem_wdata_i; \ 
 							  else if(reg_read_o == 1'b1) reg_o <= reg_data_i; \ 
 							    else if(reg_read_o == 1'b0) reg_o <= imm; \ 
 							      else reg_o <= `ZeroWord; \ 
									    end

   
   
   `GET_OPRAND(reg1_o,reg1_read_o,reg1_data_i,reg1_addr_o)
   `GET_OPRAND(reg2_o,reg2_read_o,reg2_data_i,reg2_addr_o)
   
endmodule // id

// --------------------------------------------------------------------------------
`endif
