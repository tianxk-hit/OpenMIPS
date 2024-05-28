 //顶层模块openmips
 module openmips(
 clk,
 rst,
 rom_data_i,
 rom_addr_o,
 rom_ce_o
 );
 `include	"defines.v"

 input	wire				clk;
 input	wire				rst;
 
 input	wire[`RegBus]		rom_data_i;			//从指令存储器取得的指令
 output	wire[`RegBus]		rom_addr_o;			//输出到指令存储器的地址
 output	wire				rom_ce_o;			//指令存储器使能信号
 
 //连接IF/ID模块与译码阶段的ID模块的变量
 wire[`InstAddrBus]			pc;
 wire[`InstAddrBus]			id_pc_i;
 wire[`InstBus]				id_inst_i;
 
 //连接译码阶段ID模块输出与ID/EX模块的输入的变量
 wire[`AluOpBus]			id_aluop_o;
 wire[`AluSelBus]			id_alusel_o;
 wire[`RegBus]				id_reg1_o;
 wire[`RegBus]				id_reg2_o;
 wire						id_wreg_o;
 wire[`RegAddrBus]			id_wd_o;
 
 //连接ID/EX模块输出与执行阶段EX模块的输入的变量
 wire[`AluOpBus]			ex_aluop_i;
 wire[`AluSelBus]			ex_alusel_i;
 wire[`RegBus]				ex_reg1_i;
 wire[`RegBus]				ex_reg2_i;
 wire						ex_wreg_i;
 wire[`RegAddrBus]			ex_wd_i;
 

 //连接执行阶段EX模块的输出与EX/MEM模块的输入的变量
 wire						ex_wreg_o;
 wire[`RegAddrBus]			ex_wd_o;
 wire[`RegBus]				ex_wdata_o;
 wire[`RegBus]				ex_hi_o;
 wire[`RegBus]				ex_lo_o;
 wire						ex_whilo_o;

 
 
 //连接EX/MEM模块的输出与访问阶段MEM模块的输入的变量
 wire						mem_wreg_i;
 wire[`RegAddrBus]			mem_wd_i;
 wire[`RegBus]				mem_wdata_i;
 wire						mem_whilo_i;
 wire[`RegBus]				mem_hi_i;
 wire[`RegBus]				mem_lo_i;
 
 //连接访问阶段MEM模块的输出与MEM/WB模块的输入的变量
 wire						mem_wreg_o;
 wire[`RegAddrBus]			mem_wd_o;
 wire[`RegBus]				mem_wdata_o;
 wire						mem_whilo_o;
 wire[`RegBus]				mem_hi_o;
 wire[`RegBus]				mem_lo_o;
 
 
 
 //连接MEM/WB模块的输出与回写阶段的输入的变量
 wire						wb_wreg_i;
 wire[`RegAddrBus]			wb_wd_i;
 wire[`RegBus]				wb_wdata_i;
 wire						wb_whilo_i;
 wire[`RegBus]				wb_hi_i;
 wire[`RegBus]				wb_lo_i;
 
 //连接回写阶段HILO模块的输出与EX模块的输入的变量
 wire[`RegBus]				wb_hi_o;
 wire[`RegBus]				wb_lo_o;
 
 //连接译码阶段ID模块与通用寄存器Regfile模块的变量
 wire						reg1_read;
 wire						reg2_read;
 wire[`RegBus]				reg1_data;
 wire[`RegBus]				reg2_data;
 wire[`RegAddrBus]			reg1_addr;
 wire[`RegAddrBus]			reg2_addr;
 
 // pc_reg例化
 pc_reg	pc_reg0(
 .clk(clk),
 .rst(rst),
 .pc(pc),
 .ce(rom_ce_o)
 );
 
 assign rom_addr_o = pc;		//指令存储器的输入地址就是pc值
 
 // IF/ID模块例化
 if_id if_id0(
 .clk(clk),
 .rst(rst),
 .if_pc(if_pc),
 .if_inst(rom_data_i),
 .id_pc(id_pc_i),
 .id_inst(id_inst_i)
 );
 
 // 译码阶段ID模块例化
 id id0(
.rst(rst),
.pc_i(id_pc_i),
.inst_i(id_inst_i),
.reg1_data_i(reg1_data),
.reg2_data_i(reg2_data),
.reg1_read_o(reg1_read),
.reg2_read_o(reg2_read),
.reg1_addr_o(reg1_addr),
.reg2_addr_o(reg2_addr),
.aluop_o(id_aluop_o),
.alusel_o(id_alusel_o),
.reg1_o(id_reg1_o),
.reg2_o(id_reg2_o),
.wd_o(id_wd_o),
.wreg_o(id_wreg_o),
.mem_wdata_i(mem_wdata_o),
.mem_wd_i(mem_wd_o),
.mem_wreg_i(mem_wreg_o),
.ex_wdata_i(ex_wdata_o),
.ex_wd_i(ex_wd_o),
.ex_wreg_i(ex_wreg_o)
 );
 
 // 通用寄存器Regfile模块例化
regfile regfile1(
.clk(clk),
.rst(rst),
.waddr(wb_wd_i),
.wdata(wb_wdata_i),
.we(wb_wreg_i),
.raddr1(reg1_addr),
.re1(reg1_read),
.rdata1(reg1_data),
.raddr2(reg2_addr),
.re2(reg2_read),
.rdata2(reg2_data)
 );
 
 // ID/EX模块例化
id_ex id_ex0(
.clk(clk),
.rst(rst),
.id_alusel(id_alusel_o),
.id_aluop(id_aluop_o),
.id_reg1(id_reg1_o),
.id_reg2(id_reg2_o),
.id_wd(id_wd_o),
.id_wreg(id_wreg_o),
.ex_alusel(ex_alusel_i),
.ex_aluop(ex_aluop_i),
.ex_reg1(ex_reg1_i),
.ex_reg2(ex_reg2_i),
.ex_wd(ex_wd_i),
.ex_wreg(ex_wreg_i)
 );
 
 // EX模块例化
ex ex0(
.rst(rst),
.alusel_i(ex_alusel_i),
.aluop_i(ex_aluop_i),
.reg1_i(ex_reg1_i),
.reg2_i(ex_reg2_i),
.wd_i(ex_wd_i),
.wreg_i(ex_wreg_i),
.wd_o(ex_wd_o),
.wreg_o(ex_wreg_o),
.wdata_o(ex_wdata_o),

//HILO模块接口
.hi_i(wb_hi_o),
.lo_i(wb_lo_o),
.mem_whilo_i(mem_whilo_o),
.mem_hi_i(mem_hi_o),
.mem_lo_i(mem_lo_o),
.wb_whilo_i(wb_whilo_i),
.wb_hi_i(wb_hi_i),
.wb_lo_i(wb_lo_i),
.whilo_o(ex_whilo_o),
.hi_o(ex_hi_o),
.lo_o(ex_lo_o)
 );
 
 // EX/MEM模块例化
ex_mem ex_mem0(
.clk(clk),
.rst(rat),
.ex_wd(ex_wd_o),
.ex_wreg(ex_wreg_o),
.ex_wdata(ex_wdata_o),
.mem_wd(mem_wd_i),
.mem_wreg(mem_wreg_i),
.mem_wdata(mem_wdata_i),

.ex_whilo(ex_whilo_o),
.ex_hi(ex_hi_o),
.ex_lo(ex_lo_o),
.mem_whilo(mem_whilo_i),
.mem_hi(mem_hi_i),
.mem_lo(mem_lo_i)
 );
 
 // MEM模块例化
mem mem0(
.rst(rst),
.wd_i(mem_wd_i),
.wreg_i(mem_wreg_i),
.wdata_i(mem_wdata_i),
.wd_o(mem_wd_o),
.wreg_o(mem_wreg_o),
.wdata_o(mem_wdata_o),

.whilo_i(mem_whilo_i),
.hi_i(mem_hi_i),
.lo_i(mem_lo_i),
.whilo_o(mem_whilo_o),
.hi_o(mem_hi_o),
.lo_o(mem_lo_o)
 );
 
 //MEM/WB模块例化
mem_wb mem_wb0(
.clk(clk),
.rst(rst),
.mem_wd(mem_wd_o),
.mem_wreg(mem_wreg_o),
.mem_wdata(mem_wdata_o),
.wb_wd(wb_wd_i),
.wb_wreg(wb_wreg_i),
.wb_wdata(wb_wdata_i),

.mem_whilo(mem_whilo_o),
.mem_hi(mem_hi_o),
.mem_lo(mem_lo_o),
.wb_whilo(wb_whilo_i),
.wb_hi(wb_hi_i),
.wb_lo(wb_lo_i)
 );
 
 //HILO模块例化
hilo_reg hilo_reg0(
.clk(clk),
.rst(rst),
.we(wb_whilo_i),
.hi_i(wb_hi_i),
.lo_i(wb_lo_i),
.hi_o(wb_hi_o),
.lo_o(wb_lo_o)
);
 endmodule