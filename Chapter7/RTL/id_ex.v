//---------------------------- id_ex.v ----------------------------//
// 就是一个寄存器，作为流水线不同功能模块之间打拍的部分
`include "../Include/define.v"
module id_ex (
    input clk,
    input rst,

    input [`ALUOpBus] id_aluop,
    input [`ALUSelBus] id_alusel,
    input [`RegisterBus] id_reg1,
    input [`RegisterBus] id_reg2,
    input [`RegisterAddressBus]  id_wd,
    input id_wreg,

    input [5:0] stall,

    output reg [`ALUOpBus] ex_aluop,
    output reg [`ALUSelBus] ex_alusel,
    output reg [`RegisterBus] ex_reg1,
    output reg [`RegisterBus] ex_reg2,
    output reg [`RegisterAddressBus]  ex_wd,
    output reg ex_wreg


);



always@(posedge clk) begin
    if(rst == `ResetEnable) begin
        ex_aluop   <= `EXE_NOR_OP;
        ex_alusel  <= `EXE_RES_NOP;
        ex_reg1    <= `ZeroWord;
        ex_reg2    <= `ZeroWord;
        ex_wd      <= `NOPRegisterAddress;
        ex_wreg    <= `WriteDisable;
    end
    else if(stall[3] == `NoStop && stall[2] == `Stop) begin
            ex_aluop   <= `EXE_NOR_OP;
            ex_alusel  <= `EXE_RES_NOP;
            ex_reg1    <= `ZeroWord;
            ex_reg2    <= `ZeroWord;
            ex_wd      <= `NOPRegisterAddress;
            ex_wreg    <= `WriteDisable;
        end
    else if(stall[2] == `NoStop) begin
            ex_aluop   <= id_aluop;
            ex_alusel  <= id_alusel;
            ex_reg1    <= id_reg1;  
            ex_reg2    <= id_reg2;  
            ex_wd      <= id_wd  ;  
            ex_wreg    <= id_wreg;
        end

    end




    
endmodule