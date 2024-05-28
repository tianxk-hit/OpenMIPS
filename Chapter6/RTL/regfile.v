//Regfileģ��ʵ����32��32λͨ�������Ĵ���������ͬʱ���������Ĵ����Ķ�������һ���Ĵ�����д����
module regfile(
clk,
rst,
waddr,
wdata,
we,
raddr1,
re1,
rdata1,
raddr2,
re2,
rdata2
);
`include	"defines.v"

input	wire				clk;		//ʱ���ź�
input	wire				rst;		//��λ�ź�

//д�˿�
input	wire				we;			//дʹ���ź�
input	wire[`RegAddrBus]	waddr;		//Ҫд��ļĴ�����ַ
input	wire[`RegBus]		wdata;		//Ҫд�������

//���˿�1
input	wire				re1;		//��һ�����Ĵ����˿ڶ�ʹ���ź�
input	wire[`RegAddrBus]	raddr1;		//��һ�����Ĵ����˿�Ҫ��ȡ�ļĴ�����ַ
output	reg[`RegBus]		rdata1;		//��һ�����Ĵ����˿�����ļĴ���ֵ

//���˿�2
input	wire				re2;		//�ڶ������Ĵ����˿ڶ�ʹ���ź�
input	wire[`RegAddrBus]	raddr2;		//�ڶ������Ĵ����˿�Ҫ��ȡ�ļĴ�����ַ
output	reg[`RegBus]		rdata2;		//�ڶ������Ĵ����˿�����ļĴ���ֵ

/*********************************************************
************* ��һ�Σ�����32��32λ�Ĵ��� **************
**********************************************************/

reg[`RegBus] regs[0:`RegNum-1];

/*********************************************************
************* �ڶ��Σ�д���� **************
**********************************************************/

always@(posedge clk) begin
	if(rst == `RstDisable) begin
		if((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
			regs[waddr] <=		wdata;
		end
	end
end

/*********************************************************
************* �����Σ����˿�1�Ķ����� **************
**********************************************************/

always@(*) begin
	if(rst == `RstEnable) begin
		rdata1 <=		`ZeroWord;
	end
	else if(raddr1 == `RegNumLog2'h0) begin
		rdata1 <=		`ZeroWord;
	end
	else if((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
		rdata1 <=		wdata;
	end
	else if(re1 == `ReadEnable) begin
		rdata1 <=		regs[raddr1];
	end
	else begin
		rdata1 <=		`ZeroWord;
	end
end

/*********************************************************
************* ���ĶΣ����˿�2�Ķ����� **************
**********************************************************/

always@(*) begin
	if(rst == `RstEnable) begin
		rdata2 <=		`ZeroWord;
	end
	else if(raddr2 == `RegNumLog2'h0) begin
		rdata2 <=		`ZeroWord;
	end
	else if((raddr2 == waddr) && (we == `WriteEnable) && (re2 == `ReadEnable)) begin
		rdata2 <=		wdata;
	end
	else if(re2 == `ReadEnable) begin
		rdata2 <=		regs[raddr2];
	end
	else begin
		rdata2 <=		`ZeroWord;
	end
end
endmodule