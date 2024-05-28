// hilo_reg模块，实现HI、LO寄存器
module hilo_reg(
clk,
rst,
we,
hi_i,
lo_i,
hi_o,
lo_o
);
`include	"defines.v"

input	wire					clk;
input	wire					rst;

//写端口
input	wire					we;
input	wire[`RegBus]			hi_i;
input	wire[`RegBus]			lo_i;

//读端口
output	reg[`RegBus]			hi_o;
output	reg[`RegBus]			lo_o;

always@(posedge clk) begin
	if(rst == `RstEnable) begin
		hi_o	<=				`ZeroWord;
		lo_o	<=				`ZeroWord;
	end
	else begin
		hi_o	<=				hi_i;
		lo_o	<=				lo_i;
	end
end
endmodule