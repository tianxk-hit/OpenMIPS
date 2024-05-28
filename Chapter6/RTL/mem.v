//mem���������ݴ洢��
module mem(
rst,
wd_i,
wreg_i,
wdata_i,
wd_o,
wreg_o,
wdata_o,

whilo_i,
hi_i,
lo_i,
whilo_o,
hi_o,
lo_o
);
`include	"defines.v"

input	wire				rst;

//����ִ�н׶ε���Ϣ
input	wire[`RegAddrBus]	wd_i;
input	wire				wreg_i;
input	wire[`RegBus]		wdata_i;
input	wire[`RegBus]		hi_i;
input	wire[`RegBus]		lo_i;
input	wire				whilo_i;

//�ô�׶εĽ��
output	reg[`RegAddrBus]	wd_o;
output	reg					wreg_o;
output	reg[`RegBus]		wdata_o;
output	reg[`RegBus]		hi_o;
output	reg[`RegBus]		lo_o;
output	reg					whilo_o;

always@(*) begin
	if(rst == `RstEnable) begin
		wd_o	<=			`NOPRegAddr;
		wreg_o	<=			`WriteDisable;
		wdata_o	<=			`ZeroWord;
		hi_o	<=			`ZeroWord;
		lo_o	<=			`ZeroWord;
		whilo_o	<=			`WriteDisable;
	end
	else begin
		wd_o	<=			wd_i;
		wreg_o	<=			wreg_i;
		wdata_o	<=			wdata_i;
		hi_o	<=			hi_i;
		lo_o	<=			lo_i;
		whilo_o	<=			whilo_i;
	end
end
endmodule