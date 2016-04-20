// Name: miniproc_tb.v
// Module: MiniPROC_TB
// 
// Outputs are for testbench observations only
//
//
// Notes: - Testbench for processor that integrates control unit, alu, and register file
//
// created by Feiling Jia, for CS14701 Spring 2016

`include "definition.v"

// NOP is a special instruction that does nothing
`define NOP 63

module MiniPROC_TB;
    //$dumpfile("miniproc.vcd");
    //$dumpvars(0,MiniPROC_TB);


//SYS_CLK will be the output port of CLK_GENERATOR module, so it has to be of wire type.
wire SYS_CLK;

// 32-bit operands that are read from register file and input to ALU module, except for 
// shifting instructions when the second operand should come from the “Shamt” field
// in the instruction
wire [`DATA_INDEX_LIMIT:0] alu_op1, alu_op2;

// alu_opcode generated by the control unit (output), so it should be wire type. 
// It will be connected to ALU module input port “funct”
wire [`ALU_FUNCT_INDEX_LIMIT:0] alu_opcode;

// Other Instruction fields
reg [5:0] OpCode, funct_reg;
reg [4:0] rf_addr_r1;
reg [4:0] rf_addr_r2;
reg [4:0] rf_addr_w;
reg [4:0] Shamt;


wire [`DATA_INDEX_LIMIT:0] rf_data_r1, rf_data_r2, alu_result;
wire [`ALU_FUNCT_INDEX_LIMIT:0] alu_funct;
reg [`DATA_INDEX_LIMIT:0] expected_result, actual_result;

// READ and WRITE control signals set by the control unit (output), then input to the register file
wire rf_read, rf_write;

// reset signals to Control unit and register file respectively
reg RST_Ctrl, RST_RF;

// record number of tests attempted and passed
integer total_test;
integer pass_test;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(SYS_CLK));

// instantiation of modules for the processor (no separate processor module required)
// Add code to create instance of Control unit
CONTROL_UNIT ctrl_inst (.DATA_R1(rf_data_r1), .DATA_R2(rf_data_r2), .READ(rf_read), 
    .WRITE(rf_write), .Shamt(Shamt), .OpCode(OpCode), .Funct(funct_reg), .ALU_OP1(alu_op1),
    .ALU_OP2(alu_op2), .ALU_Code(alu_opcode), .CLK(SYS_CLK), .RST(RST_Ctrl));


// Create instance of register file
REGISTER_FILE_32x32 rf_inst (.DATA_R1(rf_data_r1), .DATA_R2(rf_data_r2), .ADDR_R1(rf_addr_r1), .ADDR_R2(rf_addr_r2),
                             .DATA_W(alu_result),   .ADDR_W(rf_addr_w),   .READ(rf_read),      .WRITE(rf_write), 
                             .CLK(SYS_CLK),   .RST(RST_RF));

// Create instance of ALU
alu alu_inst (.result(alu_result), .op1(alu_op1), .op2(alu_op2), .funct(alu_opcode));


initial
begin

RST_RF = 1'b1;
RST_Ctrl = 1'b1;

// reset register file for testing purpose
#5 RST_RF = 1'b0;
#50 RST_RF = 1'b1;

total_test = 0;
pass_test = 0;


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[5] + reg[20], result written to reg[22] = 25
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 5;
    rf_addr_r2 = 20;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h20;
#100  
    expected_result = rf_data_r1 + rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d + %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d + %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 

// reset the control unit to STATE_FETCH to test the next instruction
#5 RST_Ctrl=1'b0;
#50 RST_Ctrl=1'b1;

// test reg[15] - reg[10], result written to reg [30] = 5
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 15;
    rf_addr_r2 = 10;
    rf_addr_w = 30;
    funct_reg=`ALU_FUNCT_WIDTH'h22;
#100  
    expected_result = rf_data_r1 - rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d - %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d - %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[5] * reg[3], result written to reg[22] = 15
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 5;
    rf_addr_r2 = 3;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h2c;
#100  
    expected_result = rf_data_r1 * rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d * %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d * %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[6] << reg[2], result written to reg[22] = 48
    OpCode = 0;
    Shamt = 2;
    rf_addr_r1 = 6;
    rf_addr_r2 = 2;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h01;
#100  
    expected_result = rf_data_r1 << rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d << %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d << %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[6] >> reg[3], result written to reg[22] = 0
    OpCode = 0;
    Shamt = 5;
    rf_addr_r1 = 21;
    rf_addr_r2 = 10;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h02;
#100  
    expected_result = rf_data_r1 >> rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d >> %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d >> %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[8] & reg[8], result written to reg[22] = 8
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 8;
    rf_addr_r2 = 8;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h24;
#100  
    expected_result = rf_data_r1 & rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d & %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d & %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[15] | reg[10], result written to reg[22] = 15
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 15;
    rf_addr_r2 = 10;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h25;
#100  
    expected_result = rf_data_r1 | rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d | %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d | %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test ~(reg[15] | reg[10]), result written to reg[22] = 4294967280
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 15;
    rf_addr_r2 = 10;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h27;
#100  
    expected_result = ~(rf_data_r1 | rf_data_r2);
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test ~(%0d | %0d): expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test ~(%0d | %0d): expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


// reset the control unit to STATE_FETCH so it starts to fetch the next instruction
#5 RST_Ctrl = 1'b0;
#50 RST_Ctrl = 1'b1;

// test reg[5] < reg[15], result written to reg[22] = 1
    OpCode = 0;
    Shamt = 0;
    rf_addr_r1 = 5;
    rf_addr_r2 = 15;
    rf_addr_w = 22;
    funct_reg=`ALU_FUNCT_WIDTH'h2a;
#100  
    expected_result = rf_data_r1 < rf_data_r2;
    actual_result = alu_result;
    if (actual_result === expected_result) begin
        $write("test %0d < %0d: expected %0d, got %0d ... [PASSED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;
        pass_test = pass_test + 1;
    end else begin
        $write("test %0d < %0d: expected %0d, got %0d ... [FAILED] \n", rf_data_r1, rf_data_r2, expected_result, actual_result);
        total_test = total_test + 1;    
    end 


#5  $write("\n");
    $write("\tTotal number of tests %d\n", total_test);
    $write("\tTotal number of pass  %d\n", pass_test);
    $write("\n");
    $stop; // stop simulation here

end
endmodule;
