//PC模块：给出指令地址
module pc_reg(
clk,
rst,
pc,
ce
);
`include	"defines.v"

input	wire				clk;		//时钟信号
input	wire				rst;		//复位信号
output	reg[`InstAddrBus]	pc;			//要读取的指令地址
output	reg					ce;			//指令存储器使能信号


always@(posedge clk) begin
	if(rst == `RstEnable) begin
		ce <=		`ChipDisable;		//复位的时候指令存储器禁用
	end
	else begin
		ce <=		`ChipEnable;		//复位结束后，指令存储器使能
	end
end

always@(posedge clk) begin
	if(ce == `ChipDisable) begin
		pc <=		32'h00000000;		//指令存储器禁用的时候，pc为0
	end
	else begin
		pc <=		pc + 4'h4;			//指令存储器使能的时候，pc的值每时钟周期加4
	end
end

endmodule