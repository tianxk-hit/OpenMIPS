//SOPC��������OpenMIPS��ָ��洢��ROM
module openmips_min_sopc(
clk,
rst
);
`include	"defines.v"

input	wire		clk;
input	wire		rst;

//����ָ��洢��
wire[`InstAddrBus]				inst_addr;
wire[`InstBus]					inst;
wire							rom_ce;


//����������OpenMIPS
openmips openmips0(
.clk(clk),
.rst(rst),
.rom_addr_o(inst_addr),
.rom_data_i(inst),
.rom_ce_o(rom_ce)
);

//����ָ��洢��ROM
inst_rom inst_rom0(
.ce(rom_ce),
.addr(inst_addr),
.inst(inst)
);
endmodule