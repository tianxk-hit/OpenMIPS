// ROM模块
module inst_rom(
ce,
addr,
inst
);
`include	"defines.v"

input	wire					ce;		//使能信号
input	wire[`InstAddrBus]		addr;	//要读取的指令地址
output	reg[`InstBus]			inst;	//读出的指令

//定义一个数组，大小是InstMemNum，元素宽度是InstBus
reg[`InstBus]	inst_mem[0:`InstMemNum-1];

//使用文件inst_rom.data初始化指令存储器
initial $readmemh("F:/FPGAprojects_OPEN/OpenMIPS/code/inst_rom.data",inst_mem);

/*
OpenMIPS是按照字节寻址的，而此处定义的指令存储器的每个地址是一个32bit的字，
所以要将OpenMIPS给出的地址除以4再使用，除以4也就是将指令地址右移2位
*/
//当复位信号无效时，依据输入的地址，给出指令存储器ROM中对应的元素
always@(*) begin
	if(ce == `ChipDisable) begin
		inst <=			`ZeroWord;
	end
	else begin
		inst <=			inst_mem[addr[`InstMemNumLog2+1:2]];
	end
end
endmodule