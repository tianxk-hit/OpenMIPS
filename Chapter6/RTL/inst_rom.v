// ROMģ��
module inst_rom(
ce,
addr,
inst
);
`include	"defines.v"

input	wire					ce;		//ʹ���ź�
input	wire[`InstAddrBus]		addr;	//Ҫ��ȡ��ָ���ַ
output	reg[`InstBus]			inst;	//������ָ��

//����һ�����飬��С��InstMemNum��Ԫ�ؿ����InstBus
reg[`InstBus]	inst_mem[0:`InstMemNum-1];

//ʹ���ļ�inst_rom.data��ʼ��ָ��洢��
initial $readmemh("F:/FPGAprojects_OPEN/OpenMIPS/code/inst_rom.data",inst_mem);

/*
OpenMIPS�ǰ����ֽ�Ѱַ�ģ����˴������ָ��洢����ÿ����ַ��һ��32bit���֣�
����Ҫ��OpenMIPS�����ĵ�ַ����4��ʹ�ã�����4Ҳ���ǽ�ָ���ַ����2λ
*/
//����λ�ź���Чʱ����������ĵ�ַ������ָ��洢��ROM�ж�Ӧ��Ԫ��
always@(*) begin
	if(ce == `ChipDisable) begin
		inst <=			`ZeroWord;
	end
	else begin
		inst <=			inst_mem[addr[`InstMemNumLog2+1:2]];
	end
end
endmodule