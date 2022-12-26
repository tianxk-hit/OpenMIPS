//---------------------------- id.v ----------------------------//
// 完成操作码解码的部分
`include "../Include/define.v"
module id (
    input rst,
    input [`InstAddressBus] pc_i,
    input [`InstDataBus] inst_i,
    input [`RegisterBus] reg1_data_i,
    input [`RegisterBus] reg2_data_i,

    input [`RegisterBus] mem_wdata_i,
    input [`RegisterAddressBus] mem_wd_i,
    input mem_wreg_i,

    input [`RegisterBus] ex_wdata_i,
    input [`RegisterAddressBus] ex_wd_i,
    input ex_wreg_i,

    output reg [`ALUOpBus] aluop_o,
    output reg [`ALUSelBus] alusel_o,

    
    output reg [`RegisterAddressBus] wd_o,
    output reg wreg_o,
    
    output reg [`RegisterBus] reg1_o,
    output reg [`RegisterAddressBus] reg1_addr_o,
    output reg reg1_read_o,

    output reg [`RegisterBus] reg2_o,
    output reg [`RegisterAddressBus] reg2_addr_o,
    output reg reg2_read_o
);

reg instvalid;

// 指令码、功能码：需要对应 P11 页的指令格式
// R 类型的指令由 inst_i[31:26] 以及 inst_i[5:0] 指定
// I 类型的指令由 inst_i[31:26] 指定
wire [5:0] op = inst_i[31:26];
wire [4:0] op2 = inst_i[10:6];
wire [5:0] op3 = inst_i[5:0];
// 立即数
reg  [`RegisterBus] immediate;

//------------------------------------------------------------------//
// 根据操作码完成对应的配置
always@(*) begin
    if(rst == `ResetEnable) begin
        aluop_o = `EXE_NOR_OP;
        alusel_o = `EXE_RES_NOP;
        wd_o = `NOPRegisterAddress;
        wreg_o = `WriteDisable;

        reg1_addr_o = `NOPRegisterAddress;
        reg1_read_o = 1'b0;

        reg2_addr_o = `NOPRegisterAddress;
        reg2_read_o = 1'b0;

        immediate = `ZeroWord;

    end
    else
        aluop_o = `EXE_NOR_OP;
        alusel_o = `EXE_RES_NOP;

        // 配置地址为 rd 的通用寄存器保存运算结果
        wd_o = inst_i[15:11];
        wreg_o = `WriteDisable;
        // 配置为源寄存器 rs
        reg1_addr_o = inst_i[25:21];
        reg1_read_o = 1'b0;
        // 配置为目的寄存器 rt
        reg2_addr_o = inst_i[20:16];
        reg2_read_o = 1'b0;

        immediate = `ZeroWord;

        case(op)
            `EXE_SPECIAL_INST: begin
                case(op2)
                    5'b00000:
                        case(op3)
                            `EXE_OR: begin
                                // 允许写通用寄存器
                                wreg_o = `WriteEnable;
                                // 设定运算操作指令
                                aluop_o = `EXE_OR_OP;
                                // 设定为逻辑运算
                                alusel_o = `EXE_RES_LOGIC;
                                // 1'b1 表示 reg1 以及 reg2 
                                // 均需要从通用寄存器中取值
                                // 取值的通用寄存器的地址默认为 inst_i[25:21] 以及 inst_i[20:16]
                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;

                            end

                            `EXE_AND: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_AND_OP;
                                alusel_o = `EXE_RES_LOGIC;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_XOR: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_XOR_OP;
                                alusel_o = `EXE_RES_LOGIC;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_NOR: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_NOR_OP;
                                alusel_o = `EXE_RES_LOGIC;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_SLLV: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_SLL_OP;
                                // 设定为移位运算
                                alusel_o = `EXE_RES_SHIFT;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_SRLV: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_SRL_OP;
                                alusel_o = `EXE_RES_SHIFT;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_SRAV: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_SRA_OP;
                                alusel_o = `EXE_RES_SHIFT;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end
                            // openmips 没用用到，因此相当于 nop 指令
                            `EXE_SYNC: begin
                                wreg_o = `WriteDisable;
                                aluop_o = `EXE_NOP_OP;
                                alusel_o = `EXE_RES_NOP;

                                reg1_read_o = 1'b0;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_MFHI: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_MFHI_OP;
                                alusel_o = `EXE_RES_MOVE;

                                reg1_read_o = 1'b0;
                                reg2_read_o = 1'b0;
                            end

                            `EXE_MFLO: begin
                                wreg_o = `WriteEnable;
                                aluop_o = `EXE_MFLO_OP;
                                alusel_o = `EXE_RES_MOVE;

                                reg1_read_o = 1'b0;
                                reg2_read_o = 1'b0;
                            end

                            `EXE_MTHI: begin
                                wreg_o = `WriteDisable;
                                aluop_o = `EXE_MTHI_OP;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b0;
                            end

                            `EXE_MTLO: begin
                                wreg_o = `WriteDisable;
                                aluop_o = `EXE_MTLO_OP;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b0;
                            end

                            `EXE_MOVN: begin
                                if(reg2_o != `ZeroWord)
                                    wreg_o = `WriteEnable;
                                else
                                    wreg_o = `WriteDisable;
                                
                                aluop_o = `EXE_MOVN_OP;
                                alusel_o = `EXE_RES_MOVE;

                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                            `EXE_MOVZ: begin
                                if(reg2_o == `ZeroWord)
                                    wreg_o = `WriteEnable;
                                else
                                    wreg_o = `WriteDisable;
                                
                                aluop_o = `EXE_MOVZ_OP;
                                alusel_o = `EXE_RES_MOVE;
                                
                                reg1_read_o = 1'b1;
                                reg2_read_o = 1'b1;
                            end

                    default: begin
                    end 
                    endcase
                default: begin
                end   
                endcase
            end

            `EXE_ORI: begin
                // 设定运算操作指令
                aluop_o = `EXE_OR_OP;
                // 设定为逻辑运算
                alusel_o = `EXE_RES_LOGIC;
                // 写入的通用寄存器的地址，需要注意的是因为这里的指令格式不再是 R 类型
                // 而是 I 类型，因此需要重新给出写入通用寄存器的地址
                wd_o = inst_i[20:16];
                // 允许写通用寄存器
                wreg_o = `WriteEnable;
                // reg1 需要用到寄存器内的数据，因此给出地址并将 reg1_read_0 置位为 1
                reg1_addr_o = inst_i[25:21];
                reg1_read_o = 1'b1;
                // reg2 需要用到立即数中的值，因此这里将 reg2_read_o 置位为 0 
                reg2_addr_o = `NOPRegisterAddress;
                reg2_read_o = 1'b0;

                immediate = {16'd0, inst_i[15:0]};
            end

            `EXE_ANDI: begin
                aluop_o = `EXE_AND_OP;
                alusel_o = `EXE_RES_LOGIC;
                wd_o = inst_i[20:16];
                wreg_o = `WriteEnable;

                reg1_addr_o = inst_i[25:21];
                reg1_read_o = 1'b1;

                reg2_addr_o = `NOPRegisterAddress;
                reg2_read_o = 1'b0;

                immediate = {16'd0, inst_i[15:0]};

            end

            `EXE_XORI: begin
                aluop_o = `EXE_XOR_OP;
                alusel_o = `EXE_RES_LOGIC;
                wd_o = inst_i[20:16];
                wreg_o = `WriteEnable;

                reg1_addr_o = inst_i[25:21];
                reg1_read_o = 1'b1;

                reg2_addr_o = `NOPRegisterAddress;
                reg2_read_o = 1'b0;

                immediate = {16'd0, inst_i[15:0]};

            end

            // LUI 实现的功能是将立即数中的值写入到寄存器的高 16 位中
            // 因为 LUI 的指令中 inst_i[25:21] 是 0 ，所以可以通过 OR
            // 将 immediate 写入
            `EXE_LUI: begin
                aluop_o = `EXE_OR_OP;
                alusel_o = `EXE_RES_LOGIC;
                wd_o = inst_i[20:16];
                wreg_o = `WriteEnable;

                reg1_addr_o = inst_i[25:21];
                reg1_read_o = 1'b1;

                reg2_addr_o = `NOPRegisterAddress;
                reg2_read_o = 1'b0;

                immediate = {inst_i[15:0], 16'd0};

            end

            // openmips 没用用到，因此相当于 nop 指令
            `EXE_PREF: begin
                aluop_o = `EXE_NOP_OP;
                alusel_o = `EXE_RES_NOP;
                wreg_o = `WriteDisable;

                reg1_read_o = 1'b0;

                reg2_read_o = 1'b0;


            end

            default: begin
            end
        endcase

        // 这里需要简单说明一下：EXE_SLL 以及 EXE_SLLV 这两个不同的指令给出了
        // 相同的操作数，因为这两种具体的操作是相同的，都是向左移位，区别在于
        // EXE_SLL 是从 inst_i[10:6] 确定移位多少
        // EXE_SLLV 是从 inst_i[25:21] 确定移位多少
        // 这里的处理比较巧妙，实际上将两者的移位都写到 reg1 中了
        if (inst_i[31:21] == 11'b000_0000_0000) begin
            if(op3 == `EXE_SLL) begin
                aluop_o = `EXE_SLL_OP;
                alusel_o = `EXE_RES_SHIFT;
                wd_o = inst_i[15:11];
                wreg_o = `WriteEnable;

                reg1_addr_o = `NOPRegisterAddress;
                reg1_read_o = 1'b0;

                reg2_addr_o = inst_i[20:16];
                reg2_read_o = 1'b1;

                immediate[4:0] = inst_i[10:6];


            end
            else if(op3 == `EXE_SRL) begin
                aluop_o = `EXE_SRL_OP;
                alusel_o = `EXE_RES_SHIFT;
                wd_o = inst_i[15:11];
                wreg_o = `WriteEnable;

                reg1_addr_o = `NOPRegisterAddress;
                reg1_read_o = 1'b0;

                reg2_addr_o = inst_i[20:16];
                reg2_read_o = 1'b1;

                immediate[4:0] = inst_i[10:6];


            end
            else if(op3 == `EXE_SRA) begin
                aluop_o = `EXE_SRA_OP;
                alusel_o = `EXE_RES_SHIFT;
                wd_o = inst_i[15:11];
                wreg_o = `WriteEnable;

                reg1_addr_o = `NOPRegisterAddress;
                reg1_read_o = 1'b0;

                reg2_addr_o = inst_i[20:16];
                reg2_read_o = 1'b1;

                immediate[4:0] = inst_i[10:6];

            end



        end


    end

//------------------------------------------------------------------//
// 确定进行运算的源操作数 1 和源操作数 2，实际上就是一个 MUX
always@(*) begin
    if(rst == `ResetEnable) 
        reg1_o = `ZeroWord;
    else begin
        // 为了处理流水线相关问题，这里使用到了数据前推技巧（具体可以参考 P111）
        if(reg1_read_o == 1'b1 && ex_wreg_i == 1'b1 && ex_wd_i == reg1_addr_o)
            reg1_o = ex_wdata_i;
        // 为了处理流水线相关问题，这里使用到了数据前推技巧（具体可以参考 P111）
        else if(reg1_read_o == 1'b1 && mem_wreg_i == 1'b1 && mem_wd_i == reg1_addr_o)
            reg1_o = mem_wdata_i;
        // reg1_read_o == 1'b1 就使用寄存器中的值
        else if(reg1_read_o == 1'b1) 
            reg1_o = reg1_data_i;
        // reg1_read_o == 1'b0 就使用立即数中的值
        else
           reg1_o = immediate;

    end

end

always@(*) begin
    if(rst == `ResetEnable) 
        reg2_o = `ZeroWord;
    else begin
        if(reg2_read_o == 1'b1 && ex_wreg_i == 1'b1 && ex_wd_i == reg2_addr_o)
            reg2_o = ex_wdata_i;
        else if(reg2_read_o == 1'b1 && mem_wreg_i == 1'b1 && mem_wd_i == reg2_addr_o)
            reg2_o = mem_wdata_i;
        else if(reg2_read_o == 1'b1) 
            reg2_o = reg2_data_i;
        else
           reg2_o = immediate;
    end

end

endmodule