//	IF/ID����ʱ����ȡָ�׶�ȡ�õ�ָ��Լ���Ӧ��ָ���ַ��������һ��ʱ�Ӵ��ݵ�����׶�
module if_id(
clk,
rst,
if_pc,
if_inst,
id_pc,
id_inst
);
`include	"defines.v"

input	wire				clk;		//ʱ���ź�
input	wire				rst;		//��λ�ź�

//����ȡָ�׶ε��źţ����к궨��InstBus��ʾָ���ȣ�Ϊ32
input	wire[`InstAddrBus]	if_pc;			//ȡָ�׶�ȡ�õ�ָ���Ӧ�ĵ�ַ
input	wire[`InstAddrBus]	if_inst;		//ȡָ�׶�ȡ�õ�ָ��

//��Ӧ����׶ε��ź�
output	reg[`InstAddrBus]	id_pc;			//����׶ε�ָ���Ӧ�ĵ�ַ
output	reg[`InstAddrBus]	id_inst;		//����׶ε�ָ��

always@(posedge clk) begin
	if(rst == `RstEnable) begin
		id_pc 	<=		`ZeroWord;		//��λ��ʱ��pcΪ0
		id_inst	<=		`ZeroWord;		//��λ��ʱ��ָ��ҲΪ0��ʵ�ʾ��ǿ�ָ��
	end
	else begin
		id_pc 	<=		if_pc;			//����ʱ�����´���ȡָ�׶ε�ֵ
		id_inst	<=		if_inst;
	end
end
endmodule