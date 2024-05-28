//idģ��������Ƕ�ָ��������룬�õ�������������͡������͡�Դ������1��Դ������2��
module id(
rst,
pc_i,
inst_i,
reg1_data_i,
reg2_data_i,
reg1_read_o,
reg2_read_o,
reg1_addr_o,
reg2_addr_o,
aluop_o,
alusel_o,
reg1_o,
reg2_o,
wd_o,
wreg_o,
ex_wreg_i,
ex_wd_i,
ex_wdata_i,
mem_wreg_i,
mem_wd_i,
mem_wdata_i
);
`include	"defines.v"

input	wire					rst;				//��λ�ź�
input	wire[`InstAddrBus]		pc_i;				//����׶ε�ָ���Ӧ�ĵ�ַ
input	wire[`InstBus]			inst_i;				//����׶ε�ָ��

//��ȡ��Regfile��ֵ
input	wire[`RegBus]			reg1_data_i;		//��Regfile����ĵ�һ�����Ĵ���������
input	wire[`RegBus]			reg2_data_i;		//��Regfile����ĵڶ������Ĵ���������

//�����Regfile��ֵ
output	reg						reg1_read_o;		//Regfileģ��ĵ�һ�����Ĵ����˿ڵĶ�ʹ���ź�
output	reg						reg2_read_o;		//Regfileģ��ĵڶ������Ĵ����˿ڵĶ�ʹ���ź�
output	reg[`RegAddrBus]		reg1_addr_o;		//Regfileģ��ĵ�һ�����Ĵ����˿ڵĶ���ַ�ź�
output	reg[`RegAddrBus]		reg2_addr_o;		//Regfileģ��ĵڶ������Ĵ����˿ڵĶ���ַ�ź�

//�͵�ִ�н׶ε���Ϣ
output	reg[`AluOpBus]			aluop_o;			//����׶ε�ָ��Ҫ���е������������
output	reg[`AluSelBus]			alusel_o;			//����׶ε�ָ��Ҫ���е����������
output	reg[`RegBus]			reg1_o;				//����׶ε�ָ��Ҫ���е������Դ������1
output	reg[`RegBus]			reg2_o;				//����׶ε�ָ��Ҫ���е������Դ������2
output	reg[`RegAddrBus]		wd_o;				//����׶ε�ָ��Ҫд���Ŀ�ļĴ�����ַ
output	reg						wreg_o;				//����׶ε�ָ���Ƿ���Ҫд���Ŀ�ļĴ���

//����ִ�н׶ε�ָ���������
input	wire					ex_wreg_i;			//����ִ�н׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
input	wire[`RegBus]			ex_wdata_i;			//����ִ�н׶ε�ָ��ҪдĿ�ļĴ���������
input	wire[`RegAddrBus]		ex_wd_i;			//����ִ�н׶ε�ָ��ҪдĿ�ļĴ�����ַ

//���ڷô�׶ε�ָ���������
input	wire					mem_wreg_i;			//���ڷô�׶ε�ָ���Ƿ�ҪдĿ�ļĴ���
input	wire[`RegBus]			mem_wdata_i;		//���ڷô�׶ε�ָ��ҪдĿ�ļĴ���������
input	wire[`RegAddrBus]		mem_wd_i;			//���ڷô�׶ε�ָ��ҪдĿ�ļĴ�����ַ

//ȡ��ָ���ָ���룬������
//����oriָ��ֻ��ͨ���жϵ�26-31bit��ֵ�������ж��Ƿ���oriָ��
wire[5:0]	op	=	inst_i[31:26];
wire[4:0]	op2	=	inst_i[10:6];
wire[5:0]	op3	=	inst_i[5:0];
wire[4:0]	op4	=	inst_i[20:16];

//����ָ��ִ����Ҫ��������
reg[`RegBus]	imm;

//ָʾָ���Ƿ���Ч
reg				instvalid;

/*********************************************************
************* ��һ�Σ���ָ��������� **************
**********************************************************/

always@(*) begin
	if(rst == `RstEnable) begin
		aluop_o 	<=			`EXE_NOP_OP;
		alusel_o	<=			`EXE_RES_NOP;
		wd_o		<=			`NOPRegAddr;
		wreg_o		<=			`WriteDisable;
		instvalid	<=			`InstValid;
		reg1_read_o	<=			1'b0;
		reg2_read_o	<=			1'b0;
		reg1_addr_o	<=			`NOPRegAddr;
		reg2_addr_o	<=			`NOPRegAddr;
		imm			<=			32'h0;
	end
	else begin
		aluop_o 	<=			`EXE_NOP_OP;
		alusel_o	<=			`EXE_RES_NOP;
		wd_o		<=			inst_i[15:11];
		wreg_o		<=			`WriteDisable;
		instvalid	<=			`InstValid;
		reg1_read_o	<=			1'b0;
		reg2_read_o	<=			1'b0;
		reg1_addr_o	<=			inst_i[25:21];	//	Ĭ��ͨ��Regfile���˿�1��ȡ�ļĴ�����ַ
		reg2_addr_o	<=			inst_i[20:16];	//	Ĭ��ͨ��Regfile���˿�2��ȡ�ļĴ�����ַ
		imm			<=			`ZeroWord;
	
		case(op)
			`EXE_SPECIAL_INST: begin
				case(op2)
					5'b00000: begin
						case(op3)
							`EXE_OR: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_OR_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_AND: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_AND_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_XOR: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_XOR_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_NOR: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_NOR_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_SLLV: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_SLL_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_SRLV: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_SRL_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_SRAV: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_SRA_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_SYNC: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_NOP_OP;
								alusel_o	<=			`EXE_RES_LOGIC;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
							end
							`EXE_MFHI: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_MFHI_OP;
								alusel_o	<=			`EXE_RES_MOVE;
								reg1_read_o	<=			1'b0;
								reg2_read_o	<=			1'b0;
								instvalid	<=			`InstValid;
							end
							`EXE_MFLO: begin
								wreg_o 		<=			`WriteEnable;
								aluop_o		<=			`EXE_MFLO_OP;
								alusel_o	<=			`EXE_RES_MOVE;
								reg1_read_o	<=			1'b0;
								reg2_read_o	<=			1'b0;
								instvalid	<=			`InstValid;
							end
							`EXE_MTHI: begin
								wreg_o 		<=			`WriteDisable;
								aluop_o		<=			`EXE_MTHI_OP;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b0;
								instvalid	<=			`InstValid;
							end
							`EXE_MTLO: begin
								wreg_o 		<=			`WriteDisable;
								aluop_o		<=			`EXE_MTLO_OP;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b0;
								instvalid	<=			`InstValid;
							end
							`EXE_MOVN: begin
								aluop_o		<=			`EXE_MOVN_OP;
								alusel_o	<=			`EXE_RES_MOVE;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
								//reg2_o��ֵ���ǵ�ַΪrt��ͨ�üĴ�����ֵ
								if(reg2_o != `ZeroWord) begin
									wreg_o 	<=			`WriteEnable;
								end
								else begin
									wreg_o	<=			`WriteDisable;
								end
							end
							`EXE_MOVZ: begin
								aluop_o		<=			`EXE_MOVZ_OP;
								alusel_o	<=			`EXE_RES_MOVE;
								reg1_read_o	<=			1'b1;
								reg2_read_o	<=			1'b1;
								instvalid	<=			`InstValid;
								//reg2_o��ֵ���ǵ�ַΪrt��ͨ�üĴ�����ֵ
								if(reg2_o == `ZeroWord) begin
									wreg_o 	<=			`WriteEnable;
								end
								else begin
									wreg_o	<=			`WriteDisable;
								end
							end
							default: begin
							end
						endcase
					end
					default: begin
					end
				endcase
			end
			`EXE_ORI:		begin			//����op��ֵ�ж��Ƿ���oriָ��
				// oriָ����Ҫ�����д��Ŀ�ļĴ���������wreg_oΪWriteEnable
				wreg_o			<=			`WriteEnable;
				
				// ��������������߼���������
				aluop_o			<=			`EXE_OR_OP;
				
				// �����������߼�����
				alusel_o		<=			`EXE_RES_LOGIC;
				
				// ��Ҫͨ��Regfile�Ķ��˿�1��ȡ�Ĵ���
				reg1_read_o		<=			1'b1;
				
				// ����Ҫͨ��Regfile�Ķ��˿�2��ȡ�Ĵ���
				reg2_read_o		<=			1'b0;
				
				imm 			<=			{16'h0, inst_i[15:0]};
				// ָ��ִ��Ҫд��Ŀ�ļĴ�����ַ
				wd_o			<=			inst_i[20:16];
				
				// oriָ������Чָ��
				instvalid		<=			`InstValid  ;
			end
			`EXE_ANDI: begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_AND_OP;
				alusel_o	<=			`EXE_RES_LOGIC;
				reg1_read_o	<=			1'b1;
				reg2_read_o	<=			1'b0;
				imm 		<=			{16'h0, inst_i[15:0]};
				wd_o		<=			inst_i[20:16];
				instvalid	<=			`InstValid;
			
			end
			`EXE_XORI: begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_XOR_OP;
				alusel_o	<=			`EXE_RES_LOGIC;
				reg1_read_o	<=			1'b1;
				reg2_read_o	<=			1'b0;
				imm 		<=			{16'h0, inst_i[15:0]};
				wd_o		<=			inst_i[20:16];
				instvalid	<=			`InstValid;
			end
			`EXE_LUI: begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_OR_OP;
				alusel_o	<=			`EXE_RES_LOGIC;
				reg1_read_o	<=			1'b1;
				reg2_read_o	<=			1'b0;
				imm 		<=			{16'h0, inst_i[15:0]};
				wd_o		<=			inst_i[20:16];
				instvalid	<=			`InstValid;
			end
			`EXE_PREF: begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_NOP_OP;
				alusel_o	<=			`EXE_RES_NOP;
				reg1_read_o	<=			1'b0;
				reg2_read_o	<=			1'b0;
				instvalid	<=			`InstValid;
			end
			default: begin
			end
		endcase
		
		if(inst_i[31:21] == 11'b00000000000) begin
			if(op3 == `EXE_SLL) begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_SLL_OP;
				alusel_o	<=			`EXE_RES_SHIFT;
				reg1_read_o	<=			1'b0;
				reg2_read_o	<=			1'b1;
				imm[4:0] 	<=			inst_i[10:6];
				wd_o		<=			inst_i[15:11];
				instvalid	<=			`InstValid;
			end
			else if(op3 == `EXE_SRL) begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_SLL_OP;
				alusel_o	<=			`EXE_RES_SHIFT;
				reg1_read_o	<=			1'b0;
				reg2_read_o	<=			1'b1;
				imm[4:0] 	<=			inst_i[10:6];
				wd_o		<=			inst_i[15:11];
				instvalid	<=			`InstValid;
			end
			else if(op3 == `EXE_SRA) begin
				wreg_o 		<=			`WriteEnable;
				aluop_o		<=			`EXE_SLL_OP;
				alusel_o	<=			`EXE_RES_SHIFT;
				reg1_read_o	<=			1'b0;
				reg2_read_o	<=			1'b1;
				imm[4:0] 	<=			inst_i[10:6];
				wd_o		<=			inst_i[15:11];
				instvalid	<=			`InstValid;
			end
		end
	end
end

/*********************************************************
************* �ڶ��Σ�ȷ�����������Դ������1 **************
**********************************************************/

always@(*) begin
	if(rst == `RstEnable) begin
		reg1_o <=			`ZeroWord;
	end
	else if((reg1_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg1_addr_o)) begin
		reg1_o <=			ex_wdata_i;
	end
	else if((reg1_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg1_addr_o)) begin
		reg1_o <=			mem_wdata_i;
	end
	else if(reg1_read_o == 1'b1) begin
		reg1_o <=			reg1_data_i;		//Regfile���˿�1�����ֵ
	end
	else if(reg1_read_o == 1'b0) begin			//������
		reg1_o <=			imm;
	end
	else begin
		reg1_o <=			`ZeroWord;
	end
end

/*********************************************************
************* �����Σ�ȷ�����������Դ������2 **************
**********************************************************/

always@(*) begin
	if(rst == `RstEnable) begin
		reg2_o <=			`ZeroWord;
	end
	else if((reg2_read_o == 1'b1) && (ex_wreg_i == 1'b1) && (ex_wd_i == reg2_addr_o)) begin
		reg2_o <=			ex_wdata_i;
	end
	else if((reg2_read_o == 1'b1) && (mem_wreg_i == 1'b1) && (mem_wd_i == reg2_addr_o)) begin
		reg2_o <=			mem_wdata_i;
	end
	else if(reg2_read_o == 1'b1) begin
		reg2_o <=			reg2_data_i;		//Regfile���˿�2�����ֵ
	end
	else if(reg2_read_o == 1'b0) begin			//������
		reg2_o <=			imm;
	end
	else begin
		reg2_o <=			`ZeroWord;
	end
end
endmodule